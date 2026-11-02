use std::str::FromStr;

use clap::{Args, Subcommand};
use eyre::OptionExt;
use forgejo_api::{
    Forgejo,
    structs::{
        ActionRun, ActionRunJob, ListActionRunsQuery, ListActionRunsQueryStatus,
        RepoGetActionJobLogsQuery,
    },
};

use crate::{
    SpecialRender, ftl_bail, ftl_eyre, h, lh,
    json::JsonArgs,
    repo::{RepoArg, RepoInfo, RepoName},
};

#[derive(Args, Clone, Debug)]
pub struct RunCommand {
    #[clap(help = h!("arg-remote"))]
    #[clap(long, short = 'R', global = true)]
    remote: Option<String>,

    #[clap(help = h!("arg-repo"))]
    #[clap(long, short, global = true)]
    repo: Option<RepoArg>,

    #[clap(subcommand)]
    command: RunSubcommand,
}

#[derive(Subcommand, Clone, Debug)]
pub enum RunSubcommand {
    #[clap(about = h!("cmd-run-list"))]
    List {
        #[clap(help = h!("arg-run-list-status"))]
        #[clap(long, short)]
        status: Option<RunStatus>,
        #[clap(help = h!("arg-run-list-branch"))]
        #[clap(long, short)]
        branch: Option<String>,
        #[clap(help = h!("arg-run-list-event"))]
        #[clap(long, short)]
        event: Option<String>,
        #[clap(help = h!("arg-run-list-workflow"))]
        #[clap(long, short)]
        workflow: Option<String>,
        #[clap(help = h!("arg-run-list-commit"))]
        #[clap(long, short)]
        commit: Option<String>,
        #[clap(help = h!("arg-run-list-limit"))]
        #[clap(long, short = 'L', default_value_t = 20)]
        limit: u32,
        #[clap(flatten)]
        json: JsonArgs,
    },
    #[clap(about = h!("cmd-run-view"), long_about = lh!("cmd-run-view"))]
    View {
        #[clap(help = h!("arg-run-run"))]
        run: RunRef,
        #[clap(help = h!("arg-run-job"))]
        #[clap(long, short)]
        job: Option<String>,
        #[clap(help = h!("arg-run-view-log"))]
        #[clap(long, conflicts_with = "log_failed")]
        log: bool,
        #[clap(help = h!("arg-run-view-log_failed"))]
        #[clap(long)]
        log_failed: bool,
        #[clap(flatten)]
        json: JsonArgs,
    },
    #[clap(about = h!("cmd-run-watch"))]
    Watch {
        #[clap(help = h!("arg-run-run"))]
        run: RunRef,
        #[clap(help = h!("arg-run-watch-interval"))]
        #[clap(long, short, default_value_t = 10)]
        interval: u64,
    },
    #[clap(about = h!("cmd-run-rerun"))]
    Rerun {
        #[clap(help = h!("arg-run-run"))]
        run: RunRef,
        #[clap(help = h!("arg-run-rerun-failed"))]
        #[clap(long, conflicts_with = "job")]
        failed: bool,
        #[clap(help = h!("arg-run-job"))]
        #[clap(long, short)]
        job: Option<String>,
    },
    #[clap(about = h!("cmd-run-cancel"))]
    Cancel {
        #[clap(help = h!("arg-run-run"))]
        run: RunRef,
    },
}

#[derive(clap::ValueEnum, Clone, Copy, Debug)]
pub enum RunStatus {
    Waiting,
    Running,
    Success,
    Failure,
    Cancelled,
    Skipped,
    Blocked,
}

impl From<RunStatus> for ListActionRunsQueryStatus {
    fn from(value: RunStatus) -> Self {
        match value {
            RunStatus::Waiting => ListActionRunsQueryStatus::Waiting,
            RunStatus::Running => ListActionRunsQueryStatus::Running,
            RunStatus::Success => ListActionRunsQueryStatus::Success,
            RunStatus::Failure => ListActionRunsQueryStatus::Failure,
            RunStatus::Cancelled => ListActionRunsQueryStatus::Cancelled,
            RunStatus::Skipped => ListActionRunsQueryStatus::Skipped,
            RunStatus::Blocked => ListActionRunsQueryStatus::Blocked,
        }
    }
}

/// A run as the web UI numbers it: `19617`, or a URL like
/// `https://host/owner/repo/actions/runs/19617/jobs/0`, which also names the
/// repo and, optionally, a job by its position.
#[derive(Clone, Debug)]
pub struct RunRef {
    repo: Option<RepoArg>,
    number: i64,
    job: Option<usize>,
}

impl FromStr for RunRef {
    type Err = eyre::Report;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let invalid = || ftl_eyre!("msg-run-invalid-ref", run = s);
        let Some((repo, rest)) = s.split_once("/actions/runs/") else {
            let number = s.trim_start_matches('#').parse().map_err(|_| invalid())?;
            return Ok(Self {
                repo: None,
                number,
                job: None,
            });
        };
        let repo = RepoArg::from_str(repo).map_err(|_| invalid())?;
        let mut parts = rest.trim_end_matches('/').split('/');
        let number = parts.next().and_then(|x| x.parse().ok()).ok_or_else(invalid)?;
        let job = match (parts.next(), parts.next()) {
            (Some("jobs"), Some(job)) => Some(job.parse().map_err(|_| invalid())?),
            _ => None,
        };
        Ok(Self {
            repo: Some(repo),
            number,
            job,
        })
    }
}

impl RunCommand {
    pub async fn run(self, keys: &mut crate::KeyInfo, host_name: Option<&str>) -> eyre::Result<()> {
        let run_repo = match &self.command {
            RunSubcommand::View { run, .. }
            | RunSubcommand::Watch { run, .. }
            | RunSubcommand::Rerun { run, .. }
            | RunSubcommand::Cancel { run } => run.repo.as_ref(),
            RunSubcommand::List { .. } => None,
        };
        let repo = RepoInfo::get_current(
            host_name,
            run_repo.or(self.repo.as_ref()),
            self.remote.as_deref(),
            keys,
        )?;
        let api = keys.get_api(repo.host_url()).await?;
        let repo = repo
            .name()
            .ok_or_eyre("can't figure what repo to access, try specifying with `--repo`")?;

        match self.command {
            RunSubcommand::List {
                status,
                branch,
                event,
                workflow,
                commit,
                limit,
                json,
            } => {
                let query = ListActionRunsQuery {
                    event: event.map(|x| vec![x]),
                    status: status.map(|x| vec![x.into()]),
                    run_number: None,
                    head_sha: commit,
                    r#ref: branch.map(|x| match x.starts_with("refs/") {
                        true => x,
                        false => format!("refs/heads/{x}"),
                    }),
                    workflow_id: workflow,
                };
                let runs = api
                    .list_action_runs(repo.owner(), repo.name(), query)
                    .page(1)
                    .page_size(limit)
                    .await?
                    .workflow_runs
                    .unwrap_or_default();
                if json.enabled() {
                    return json.print_omitting(&runs, OMITTED_RUN_FIELDS);
                }
                for run in &runs {
                    print_run_line(run);
                }
            }
            RunSubcommand::View {
                run,
                job,
                log,
                log_failed,
                json,
            } => {
                let run_info = get_run(repo, &api, run.number).await?;
                let jobs = get_jobs(repo, &api, &run_info).await?;
                let jobs = select_jobs(jobs, run.job, job.as_deref())?;
                if log || log_failed {
                    print_logs(repo, &api, &jobs, log_failed).await?;
                } else if json.enabled() {
                    let mut value = serde_json::to_value(&run_info)?;
                    value["jobs"] = serde_json::to_value(&jobs)?;
                    json.print_omitting(&value, OMITTED_RUN_FIELDS)?;
                } else {
                    print_run(&run_info, &jobs);
                }
            }
            RunSubcommand::Watch { run, interval } => {
                let mut last = None;
                let run_info = loop {
                    let run_info = get_run(repo, &api, run.number).await?;
                    let status = run_info.status.clone().unwrap_or_default();
                    if !is_pending(&status) {
                        break run_info;
                    }
                    if last.as_ref() != Some(&status) {
                        print_run_line(&run_info);
                        last = Some(status);
                    }
                    tokio::time::sleep(std::time::Duration::from_secs(interval)).await;
                };
                let jobs = get_jobs(repo, &api, &run_info).await?;
                print_run(&run_info, &jobs);
                let status = run_info.status.as_deref().unwrap_or_default();
                if status != "success" {
                    ftl_bail!("msg-run-watch-not_success", status);
                }
            }
            RunSubcommand::Rerun { run, failed, job } => {
                let run_info = get_run(repo, &api, run.number).await?;
                let run_id = run_info.id.ok_or_eyre("run does not have id")?;
                if !failed && run.job.is_none() && job.is_none() {
                    api.rerun_action_run(repo.owner(), repo.name(), run_id)
                        .await?;
                    println!("Rerunning run #{}", run.number);
                    return Ok(());
                }
                let jobs = get_jobs(repo, &api, &run_info).await?;
                let jobs = match failed {
                    true => jobs
                        .into_iter()
                        .filter(|x| matches!(x.status.as_deref(), Some("failure" | "cancelled")))
                        .collect(),
                    false => select_jobs(jobs, run.job, job.as_deref())?,
                };
                if jobs.is_empty() {
                    ftl_bail!("msg-run-rerun-none");
                }
                for job in &jobs {
                    let id = job.id.ok_or_eyre("job does not have id")?;
                    api.repo_rerun_action_job(repo.owner(), repo.name(), id)
                        .await?;
                    println!("Rerunning {}", job.name.as_deref().unwrap_or("?"));
                }
            }
            RunSubcommand::Cancel { run } => {
                let run_info = get_run(repo, &api, run.number).await?;
                let run_id = run_info.id.ok_or_eyre("run does not have id")?;
                api.cancel_action_run(repo.owner(), repo.name(), run_id)
                    .await?;
                println!("Cancelled run #{}", run.number);
            }
        }
        Ok(())
    }
}

/// The event payload holds the whole PR or push and dwarfs everything else,
/// so it is only printed when asked for by name.
const OMITTED_RUN_FIELDS: &[&str] = &["event_payload", "trigger_event_payload", "repository"];

fn is_pending(status: &str) -> bool {
    matches!(status, "waiting" | "running" | "blocked" | "unknown")
}

async fn get_run(repo: &RepoName, api: &Forgejo, number: i64) -> eyre::Result<ActionRun> {
    let query = ListActionRunsQuery {
        run_number: Some(number),
        ..Default::default()
    };
    api.list_action_runs(repo.owner(), repo.name(), query)
        .await?
        .workflow_runs
        .unwrap_or_default()
        .into_iter()
        .next()
        .ok_or_else(|| ftl_eyre!("msg-run-not_found", number))
}

async fn get_jobs(repo: &RepoName, api: &Forgejo, run: &ActionRun) -> eyre::Result<Vec<ActionRunJob>> {
    let id = run.id.ok_or_eyre("run does not have id")?;
    let jobs = api
        .list_action_run_jobs(repo.owner(), repo.name(), id)
        .await?;
    // Only a single job comes with its steps, which --log-failed needs.
    let jobs = jobs.into_iter().map(|job| async move {
        match job.id {
            Some(id) => api.repo_get_action_job(repo.owner(), repo.name(), id).await,
            None => Ok(job),
        }
    });
    Ok(futures::future::try_join_all(jobs).await?)
}

/// `position` comes from a job URL; `selector` from `--job`, either a job id or
/// a job name.
fn select_jobs(
    jobs: Vec<ActionRunJob>,
    position: Option<usize>,
    selector: Option<&str>,
) -> eyre::Result<Vec<ActionRunJob>> {
    if let Some(selector) = selector {
        let id = selector.parse::<i64>().ok();
        let names = jobs
            .iter()
            .filter_map(|x| x.name.clone())
            .collect::<Vec<_>>();
        let found = jobs
            .into_iter()
            .filter(|x| x.name.as_deref() == Some(selector) || (id.is_some() && x.id == id))
            .collect::<Vec<_>>();
        if found.is_empty() {
            ftl_bail!(
                "msg-run-job-not_found",
                job = selector,
                jobs = names.join(", "),
            );
        }
        return Ok(found);
    }
    match position {
        Some(position) => {
            let count = jobs.len();
            let job = jobs
                .into_iter()
                .nth(position)
                .ok_or_else(|| ftl_eyre!("msg-run-job-out_of_range", position, count))?;
            Ok(vec![job])
        }
        None => Ok(jobs),
    }
}

async fn print_logs(
    repo: &RepoName,
    api: &Forgejo,
    jobs: &[ActionRunJob],
    failed_only: bool,
) -> eyre::Result<()> {
    let failed = |status: Option<&str>| matches!(status, Some("failure" | "cancelled"));
    let mut printed = false;
    for job in jobs {
        if failed_only && !failed(job.status.as_deref()) {
            continue;
        }
        let id = job.id.ok_or_eyre("job does not have id")?;
        let name = job.name.as_deref().unwrap_or("?");
        let steps = job.steps.as_deref().unwrap_or_default();
        // A job can fail before any step does, e.g. when no runner picks it up;
        // then the whole log is all there is.
        let failed_steps = steps
            .iter()
            .filter(|x| failed(x.status.as_deref()))
            .collect::<Vec<_>>();
        let steps = match failed_only && !failed_steps.is_empty() {
            true => failed_steps,
            false => steps.iter().collect(),
        };
        if steps.is_empty() {
            println!("=== {name}");
            print_log(repo, api, id, None).await?;
        }
        for step in steps {
            if step.status.as_deref() == Some("skipped") {
                continue;
            }
            let step_name = step.name.as_deref().unwrap_or("?");
            println!("=== {name} / {step_name}");
            let number = step.number.and_then(|x| u32::try_from(x).ok());
            print_log(repo, api, id, number).await?;
        }
        printed = true;
    }
    if !printed && failed_only {
        println!("No failed jobs.");
    }
    Ok(())
}

async fn print_log(
    repo: &RepoName,
    api: &Forgejo,
    job: i64,
    step: Option<u32>,
) -> eyre::Result<()> {
    use std::io::Write;
    let query = RepoGetActionJobLogsQuery {
        step,
        ..Default::default()
    };
    let log = api
        .repo_get_action_job_logs(repo.owner(), repo.name(), job, query)
        .await?;
    let mut stdout = std::io::stdout().lock();
    stdout.write_all(&log)?;
    if !log.is_empty() && !log.ends_with(b"\n") {
        writeln!(stdout)?;
    }
    Ok(())
}

fn status_symbol(status: Option<&str>) -> String {
    let SpecialRender {
        fancy,
        reset,
        bright_green,
        light_grey,
        bright_red,
        yellow,
        ..
    } = *crate::special_render();
    match status {
        x if !fancy => x.unwrap_or("?").to_owned(),
        Some("success") => format!("{bright_green}✓{reset}"),
        Some("failure") => format!("{bright_red}×{reset}"),
        Some("cancelled") => format!("{light_grey}!{reset}"),
        Some("skipped") => format!("{light_grey}-{reset}"),
        Some("running") => format!("{yellow}●{reset}"),
        Some("waiting" | "blocked") => format!("{light_grey}○{reset}"),
        Some(x) => x.to_owned(),
        None => "?".to_owned(),
    }
}

fn print_run_line(run: &ActionRun) {
    let sha = run.commit_sha.as_deref().unwrap_or_default();
    println!(
        "{} #{} {} {} {} {}",
        status_symbol(run.status.as_deref()),
        run.index_in_repo.unwrap_or_default(),
        run.workflow_id.as_deref().unwrap_or("?"),
        run.prettyref.as_deref().unwrap_or("?"),
        &sha[..sha.len().min(10)],
        run.title.as_deref().unwrap_or_default(),
    );
}

fn print_run(run: &ActionRun, jobs: &[ActionRunJob]) {
    print_run_line(run);
    if let Some(url) = &run.html_url {
        println!("{url}");
    }
    for job in jobs {
        println!(
            "  {} {} (job {})",
            status_symbol(job.status.as_deref()),
            job.name.as_deref().unwrap_or("?"),
            job.id.unwrap_or_default(),
        );
        if matches!(job.status.as_deref(), Some("failure" | "cancelled")) {
            for step in job.steps.as_deref().unwrap_or_default() {
                if matches!(step.status.as_deref(), Some("failure" | "cancelled")) {
                    println!(
                        "      {} {}",
                        status_symbol(step.status.as_deref()),
                        step.name.as_deref().unwrap_or("?"),
                    );
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn run_refs() {
        let x = RunRef::from_str("19617").unwrap();
        assert_eq!((x.number, x.job), (19617, None));
        assert!(x.repo.is_none());
        let x = RunRef::from_str("http://heimdall:3000/Inno/Mono/actions/runs/19617/jobs/2").unwrap();
        assert_eq!((x.number, x.job), (19617, Some(2)));
        let repo = x.repo.unwrap();
        assert_eq!((repo.owner(), repo.name()), ("Inno", "Mono"));
        assert!(RunRef::from_str("abc").is_err());
        assert!(RunRef::from_str("http://h/a/b/actions/runs/x").is_err());
    }
}

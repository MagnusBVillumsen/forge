use std::collections::BTreeMap;
use std::num::NonZeroU32;
use std::path::PathBuf;
use std::str::FromStr;

use clap::{Args, Subcommand};
use eyre::{Context, OptionExt, eyre};
use forgejo_api::structs::{
    Comment, CreateIssueCommentOption, CreateIssueOption, EditIssueOption, IssueGetCommentsQuery,
    IssueMeta,
};
use forgejo_api::{CountHeader, Forgejo};

use crate::repo::{RepoArg, RepoInfo, RepoName};
use crate::json::JsonArgs;
use crate::{ftl_bail, ftl_ensure, ftl_eprintln, ftl_eyre, ftl_println, h, lh, milestones};

pub mod template;

#[derive(Args, Clone, Debug)]
pub struct IssueCommand {
    #[clap(help = h!("arg-remote"))]
    #[clap(long, short = 'R', global = true)]
    remote: Option<String>,
    #[clap(subcommand)]
    command: IssueSubcommand,
}

#[derive(Subcommand, Clone, Debug)]
pub enum IssueSubcommand {
    #[clap(about = h!("cmd-issue-create"))]
    Create {
        #[clap(help = h!("arg-issue-create-title"))]
        #[clap(group = "method", required = true)]
        title: Option<String>,

        #[clap(help = h!("arg-issue-create-body"), long_help = lh!("arg-issue-create-body"))]
        #[clap(long, conflicts_with = "template")]
        body: Option<String>,

        #[clap(help = h!("arg-issue-create-body_file"))]
        #[clap(long, conflicts_with = "body")]
        body_file: Option<PathBuf>,

        #[clap(help = h!("arg-issue-create-template"), long_help = lh!("arg-issue-create-template"))]
        #[clap(long)]
        template: Option<String>,

        #[clap(help = h!("arg-issue-create-no_template"), long_help = lh!("arg-issue-create-no_template"))]
        #[clap(long, conflicts_with = "template")]
        no_template: bool,

        #[clap(help = h!("arg-issue-create-milestone"))]
        #[clap(long)]
        milestone: Option<String>,

        #[clap(help = h!("arg-issue-create-repo"))]
        #[clap(long, short)]
        repo: Option<RepoArg>,

        #[clap(help = h!("arg-issue-create-web"))]
        #[clap(long, group = "method")]
        web: bool,
    },
    #[clap(about = h!("cmd-issue-edit"))]
    Edit {
        issue: IssueId,
        #[clap(subcommand)]
        command: EditCommand,
    },
    #[clap(about = h!("cmd-issue-comment"))]
    Comment {
        #[clap(help = h!("arg-issue-comment-issue"))]
        issue: IssueId,

        #[clap(help = h!("arg-issue-comment-body"), long_help = lh!("arg-issue-comment-body"))]
        body: Option<String>,

        #[clap(help = h!("arg-issue-comment-body_file"))]
        #[clap(long, conflicts_with = "body")]
        body_file: Option<PathBuf>,
    },
    #[clap(about = h!("cmd-issue-assign"))]
    Assign {
        #[clap(help = h!("arg-issue-assign-issue"))]
        issue: IssueId,
        #[clap(help = h!("arg-issue-assign-users"))]
        users: Vec<String>,
    },
    #[clap(about = h!("cmd-issue-unassign"))]
    Unassign {
        #[clap(help = h!("arg-issue-unassign-issue"))]
        issue: IssueId,
        #[clap(help = h!("arg-issue-unassign-users"))]
        users: Vec<String>,
    },
    #[clap(about = h!("cmd-issue-close"))]
    Close {
        #[clap(help = h!("arg-issue-close-issue"))]
        issue: IssueId,
        #[clap(help = h!("arg-issue-close-with_msg"))]
        #[clap(long, short)]
        with_msg: Option<Option<String>>,
    },
    #[clap(about = h!("cmd-issue-search"), visible_alias = "list")]
    Search {
        #[clap(flatten)]
        json: JsonArgs,

        #[clap(help = h!("arg-issue-search-repo"))]
        #[clap(long, short)]
        repo: Option<RepoArg>,

        query: Option<String>,

        #[clap(long, short)]
        labels: Option<String>,

        #[clap(long, short)]
        creator: Option<String>,

        #[clap(long, short)]
        assignee: Option<String>,

        #[clap(help = h!("arg-issue-search-state"))]
        #[clap(long, short)]
        state: Option<State>,

        #[clap(conflicts_with = "all", value_parser = crate::prs::parse_non_zero_u32)]
        #[clap(long, short, default_value_t = NonZeroU32::MIN)]
        page: NonZeroU32,

        #[clap(help = h!("arg-issue-search-all"))]
        #[clap(long, conflicts_with = "page")]
        all: bool,

        #[clap(help = h!("arg-issue-search-milestones"))]
        #[clap(long, short)]
        milestones: Option<String>,
    },
    #[clap(about = h!("cmd-issue-view"))]
    View {
        #[clap(help = h!("arg-issue-view-issue"))]
        id: IssueId,
        #[clap(flatten)]
        json: JsonArgs,
        #[clap(subcommand)]
        command: Option<ViewCommand>,
    },
    #[clap(about = h!("cmd-issue-templates"))]
    Templates {
        #[clap(help = h!("arg-issue-templates-repo"))]
        #[clap(long, short)]
        repo: Option<RepoArg>,
    },
    #[clap(about = h!("cmd-issue-browse"))]
    Browse { id: IssueId },
    #[clap(about = h!("cmd-issue-depend"))]
    Depend(IssueDependCommand),
    #[clap(about = h!("cmd-issue-block"))]
    Block(IssueBlockCommand),
}

#[derive(Clone, Debug)]
pub struct IssueId {
    pub repo: Option<RepoArg>,
    pub number: i64,
}

impl FromStr for IssueId {
    type Err = IssueIdError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (repo, number) = match s.rsplit_once("#") {
            Some((repo, number)) => (Some(repo.parse::<RepoArg>()?), number),
            None => (None, s),
        };
        Ok(Self {
            repo,
            number: number.parse::<u64>()? as i64,
        })
    }
}

#[derive(Debug, Clone)]
pub enum IssueIdError {
    Repo(crate::repo::RepoArgError),
    Number(std::num::ParseIntError),
}

impl std::fmt::Display for IssueIdError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            IssueIdError::Repo(e) => e.fmt(f),
            IssueIdError::Number(e) => e.fmt(f),
        }
    }
}

impl From<crate::repo::RepoArgError> for IssueIdError {
    fn from(value: crate::repo::RepoArgError) -> Self {
        Self::Repo(value)
    }
}

impl From<std::num::ParseIntError> for IssueIdError {
    fn from(value: std::num::ParseIntError) -> Self {
        Self::Number(value)
    }
}

impl std::error::Error for IssueIdError {}

#[derive(clap::ValueEnum, Clone, Copy, Debug)]
pub enum State {
    Open,
    Closed,
    All,
}

impl From<State> for forgejo_api::structs::IssueListIssuesQueryState {
    fn from(value: State) -> Self {
        match value {
            State::Open => forgejo_api::structs::IssueListIssuesQueryState::Open,
            State::Closed => forgejo_api::structs::IssueListIssuesQueryState::Closed,
            State::All => forgejo_api::structs::IssueListIssuesQueryState::All,
        }
    }
}

#[derive(Subcommand, Clone, Debug)]
pub enum EditCommand {
    #[clap(about = h!("cmd-issue-edit-title"))]
    Title { new_title: Option<String> },
    #[clap(about = h!("cmd-issue-edit-body"))]
    Body { new_body: Option<String> },
    #[clap(about = h!("cmd-issue-edit-comment"))]
    Comment {
        idx: usize,
        new_body: Option<String>,
    },
    #[clap(about = h!("cmd-issue-edit-labels"))]
    Labels {
        #[clap(help = h!("arg-issue-edit-labels-add"))]
        #[clap(long, short)]
        add: Vec<String>,

        #[clap(help = h!("arg-issue-edit-labels-rm"))]
        #[clap(long, short)]
        rm: Vec<String>,
    },
    #[clap(about = h!("cmd-issue-edit-milestone"))]
    #[group(required = true)]
    Milestone {
        #[clap(group = "arg")]
        new_milestone: Option<String>,

        #[clap(group = "arg")]
        #[clap(long, short)]
        unset: bool,
    },
}

#[derive(Subcommand, Clone, Debug)]
pub enum ViewCommand {
    #[clap(about = h!("cmd-issue-view-body"))]
    Body,
    #[clap(about = h!("cmd-issue-view-comment"))]
    Comment { idx: usize },
    #[clap(about = h!("cmd-issue-view-comments"))]
    Comments,
    #[clap(about = h!("cmd-issue-view-assignees"))]
    Assignees,
}

#[derive(Args, Clone, Debug)]
pub struct IssueDependCommand {
    #[clap(subcommand)]
    pub command: IssueDependSubcommand,
}

#[derive(Subcommand, Clone, Debug)]
pub enum IssueDependSubcommand {
    #[clap(about = h!("cmd-depend-add"))]
    Add {
        #[clap(help = h!("arg-issue-depend-add-issue"))]
        issue: IssueId,
        #[clap(help = h!("arg-depend-add-target"))]
        target: Vec<IssueId>,
    },
    #[clap(about = h!("cmd-depend-remove"))]
    Remove {
        #[clap(help = h!("arg-issue-depend-remove-issue"))]
        issue: IssueId,
        #[clap(help = h!("arg-depend-remove-target"))]
        target: Vec<IssueId>,
    },
    #[clap(about = h!("cmd-depend-list"))]
    List {
        #[clap(help = h!("arg-issue-depend-list-issue"))]
        issue: IssueId,
    },
}

#[derive(Args, Clone, Debug)]
pub struct IssueBlockCommand {
    #[clap(subcommand)]
    pub command: IssueBlockSubcommand,
}

#[derive(Subcommand, Clone, Debug)]
pub enum IssueBlockSubcommand {
    #[clap(about = h!("cmd-block-add"))]
    Add {
        #[clap(help = h!("arg-issue-block-add-issue"))]
        issue: IssueId,
        #[clap(help = h!("arg-issue-block-add-target"))]
        target: Vec<IssueId>,
    },
    #[clap(about = h!("cmd-block-remove"))]
    Remove {
        #[clap(help = h!("arg-issue-block-remove-issue"))]
        issue: IssueId,
        #[clap(help = h!("arg-block-remove-target"))]
        target: Vec<IssueId>,
    },
    #[clap(about = h!("cmd-block-list"))]
    List {
        #[clap(help = h!("arg-issue-block-list-issue"))]
        issue: IssueId,
    },
}

impl IssueCommand {
    pub async fn run(self, keys: &mut crate::KeyInfo, host_name: Option<&str>) -> eyre::Result<()> {
        use IssueSubcommand::*;
        let repo = RepoInfo::get_current(host_name, self.repo(), self.remote.as_deref(), keys)?;
        let api = keys.get_api(repo.host_url()).await?;
        let repo = repo.name().ok_or_else(|| self.no_repo_error())?;
        match self.command {
            Create {
                repo: _,
                title,
                body,
                body_file,
                template,
                milestone,
                no_template,
                web,
            } => {
                create_issue(
                    repo,
                    &api,
                    title,
                    body,
                    body_file,
                    template,
                    milestone,
                    no_template,
                    web,
                )
                .await?
            }
            View { id, json, command } if json.enabled() => {
                view_issue_json(repo, &api, id.number, command, &json).await?
            }
            View { id, command, .. } => match command.unwrap_or(ViewCommand::Body) {
                ViewCommand::Body => view_issue(repo, &api, id.number).await?,
                ViewCommand::Comment { idx } => view_comment(repo, &api, id.number, idx).await?,
                ViewCommand::Comments => view_comments(repo, &api, id.number).await?,
                ViewCommand::Assignees => view_assignees(repo, &api, id.number).await?,
            },
            Search {
                json,
                repo: _,
                query,
                labels,
                creator,
                assignee,
                state,
                page,
                all,
                milestones,
            } => {
                view_issues(
                    repo,
                    &api,
                    &json,
                    query,
                    labels,
                    creator,
                    assignee,
                    state,
                    if all { None } else { Some(page) },
                    milestones,
                )
                .await?
            }
            Templates { .. } => view_issue_templates(repo, &api).await?,
            Edit { issue, command } => match command {
                EditCommand::Title { new_title } => {
                    edit_title(repo, &api, issue.number, new_title).await?
                }
                EditCommand::Body { new_body } => {
                    edit_body(repo, &api, issue.number, new_body).await?
                }
                EditCommand::Comment { idx, new_body } => {
                    edit_comment(repo, &api, issue.number, idx, new_body).await?
                }
                EditCommand::Labels { add, rm } => {
                    crate::edit_labels(repo, &api, issue.number, add, rm).await?;
                }
                EditCommand::Milestone {
                    new_milestone,
                    unset,
                } => edit_milestone(repo, &api, issue.number, new_milestone, unset).await?,
            },
            Assign { issue, users } => assign_to_issue(repo, &api, issue.number, users).await?,
            Unassign { issue, users } => {
                unassign_from_issue(repo, &api, issue.number, users).await?
            }
            Close { issue, with_msg } => close_issue(repo, &api, issue.number, with_msg).await?,
            Browse { id } => browse_issue(repo, &api, id.number).await?,
            Comment {
                issue,
                body,
                body_file,
            } => add_comment(repo, &api, issue.number, body, body_file).await?,
            Depend(cmd) => match cmd.command {
                IssueDependSubcommand::Add { issue, target } => {
                    add_dependencies(repo, &api, issue, target).await?
                }
                IssueDependSubcommand::Remove { issue, target } => {
                    remove_dependencies(repo, &api, issue, target).await?
                }
                IssueDependSubcommand::List { issue } => {
                    view_dependencies(repo, &api, issue).await?
                }
            },
            Block(cmd) => match cmd.command {
                IssueBlockSubcommand::Add { issue, target } => {
                    add_blocks(repo, &api, issue, target).await?
                }
                IssueBlockSubcommand::Remove { issue, target } => {
                    remove_blocks(repo, &api, issue, target).await?
                }
                IssueBlockSubcommand::List { issue } => view_blocks(repo, &api, issue).await?,
            },
        }
        Ok(())
    }

    fn repo(&self) -> Option<&RepoArg> {
        use IssueSubcommand::*;
        match &self.command {
            Create { repo, .. } | Search { repo, .. } | Templates { repo } => repo.as_ref(),
            View { id: issue, .. }
            | Edit { issue, .. }
            | Assign { issue, .. }
            | Unassign { issue, .. }
            | Close { issue, .. }
            | Comment { issue, .. }
            | Browse { id: issue, .. } => issue.repo.as_ref(),
            Depend(cmd) => match &cmd.command {
                IssueDependSubcommand::Add { issue, .. }
                | IssueDependSubcommand::Remove { issue, .. }
                | IssueDependSubcommand::List { issue } => issue.repo.as_ref(),
            },
            Block(cmd) => match &cmd.command {
                IssueBlockSubcommand::Add { issue, .. }
                | IssueBlockSubcommand::Remove { issue, .. }
                | IssueBlockSubcommand::List { issue } => issue.repo.as_ref(),
            },
        }
    }

    fn no_repo_error(&self) -> eyre::Error {
        use IssueSubcommand::*;
        match &self.command {
            Create { .. } | Search { .. } | Templates { .. } => {
                eyre::eyre!("can't figure what repo to access, try specifying with `--repo`")
            }
            View { id: issue, .. }
            | Edit { issue, .. }
            | Assign { issue, .. }
            | Unassign { issue, .. }
            | Close { issue, .. }
            | Comment { issue, .. }
            | Browse { id: issue, .. } => eyre::eyre!(
                "can't figure out what repo to access, try specifying with `{{owner}}/{{repo}}#{}`",
                issue.number
            ),
            Depend(_) | Block(_) => {
                ftl_eyre!("msg-issue-depend-no_repo_info")
            }
        }
    }
}

pub async fn label_names_to_ids(
    repo: &RepoName,
    api: &Forgejo,
    names: Vec<String>,
) -> eyre::Result<Vec<i64>> {
    let query = forgejo_api::structs::IssueListLabelsQuery { sort: None };
    let (_, all_labels) = api
        .issue_list_labels(repo.owner(), repo.name(), query)
        .await?;
    let mut all_labels = all_labels
        .into_iter()
        .filter_map(|l| Some((l.name?, l.id?)))
        .collect::<BTreeMap<_, _>>();
    Ok(names
        .into_iter()
        .filter_map(|name| all_labels.remove(&name))
        .collect())
}

pub async fn maybe_label_names_to_ids(
    repo: &RepoName,
    api: &Forgejo,
    names: Option<Vec<String>>,
) -> eyre::Result<Option<Vec<i64>>> {
    Ok(match names {
        Some(names) => Some(crate::issues::label_names_to_ids(repo, api, names).await?),
        None => None,
    })
}

#[allow(clippy::too_many_arguments)]
async fn create_issue(
    repo: &RepoName,
    api: &Forgejo,
    title: Option<String>,
    body: Option<String>,
    body_file: Option<PathBuf>,
    template: Option<String>,
    milestone: Option<String>,
    no_template: bool,
    web: bool,
) -> eyre::Result<()> {
    match (title, web) {
        (Some(title), false) => {
            let body_from_file = match body_file {
                None => None,
                Some(ref path) => Some(crate::read_file_or_stdin(path).await?),
            };
            let body = body.or(body_from_file);

            let has_templates = api
                .repo_get_issue_templates(repo.owner(), repo.name())
                .await
                .is_ok();
            let blank_issues_enabled = api
                .repo_get_issue_config(repo.owner(), repo.name())
                .await?
                .blank_issues_enabled
                .unwrap_or(true);

            let opts = if let Some(template_name) = template {
                ftl_ensure!(
                    has_templates,
                    "msg-issue-create-no_templates",
                    owner = repo.owner(),
                    repo = repo.name(),
                );

                let milestone = match milestone {
                    Some(m) => Some(milestones::get_milestone_id(repo, api, m).await?),
                    None => None,
                };

                let (template_file, is_yaml) =
                    template::get_template_file(repo, api, &template_name).await?;
                let (body, metadata) =
                    crate::issues::template::generate_from_template(body, template_file, is_yaml)
                        .await?;

                CreateIssueOption {
                    body: Some(body),
                    title,
                    #[allow(deprecated)]
                    assignee: None,
                    assignees: None,
                    closed: None,
                    due_date: None,
                    labels: maybe_label_names_to_ids(repo, api, metadata.labels).await?,
                    milestone,
                    r#ref: metadata.r#ref,
                }
            } else {
                ftl_ensure!(
                    blank_issues_enabled,
                    "msg-issue-create-templates_required",
                    owner = repo.owner(),
                    repo = repo.name(),
                );
                ftl_ensure!(
                    !has_templates || no_template,
                    "msg-issue-create-templates_enabled",
                    owner = repo.owner(),
                    repo = repo.name(),
                );
                let body = match body {
                    Some(body) => body,
                    None => {
                        let mut body = String::new();
                        crate::editor(&mut body, Some("md")).await?;
                        body
                    }
                };
                CreateIssueOption {
                    body: Some(body),
                    title,
                    #[allow(deprecated)]
                    assignee: None,
                    assignees: None,
                    closed: None,
                    due_date: None,
                    labels: None,
                    milestone: None,
                    r#ref: None,
                }
            };

            let issue = api
                .issue_create_issue(repo.owner(), repo.name(), opts)
                .await?;
            let number = issue
                .number
                .ok_or_else(|| eyre::eyre!("issue does not have number"))?;
            let title = issue
                .title
                .as_ref()
                .ok_or_else(|| eyre::eyre!("issue does not have title"))?;
            ftl_eprintln!("msg-issue-create-success", number, title);
        }
        (None, true) => {
            let base_repo = api.repo_get(repo.owner(), repo.name()).await?;
            let mut issue_create_url = base_repo
                .html_url
                .clone()
                .ok_or_eyre("repo does not have html url")?;
            issue_create_url
                .path_segments_mut()
                .expect("invalid url")
                .extend(["issues", "new"]);
            open::that_detached(issue_create_url.as_str()).wrap_err("Failed to open URL")?;
        }
        _ => {
            unreachable!()
        }
    }
    Ok(())
}

pub async fn view_issue(repo: &RepoName, api: &Forgejo, number: i64) -> eyre::Result<()> {
    let issue = api
        .issue_get_issue(repo.owner(), repo.name(), number)
        .await?;
    let repo_info = api.repo_get(repo.owner(), repo.name()).await?;

    // if it's a pull request, display it as one instead
    if issue.pull_request.is_some() {
        crate::prs::view_pr(repo, api, Some(number)).await?;
        return Ok(());
    }

    let title = issue
        .title
        .as_ref()
        .ok_or_else(|| eyre::eyre!("issue does not have title"))?;
    let user = issue
        .user
        .as_ref()
        .ok_or_else(|| eyre::eyre!("issue does not have creator"))?;
    let username = user
        .login
        .as_ref()
        .ok_or_else(|| eyre::eyre!("user does not have login"))?;
    let state = issue
        .state
        .ok_or_else(|| eyre::eyre!("pr does not have state"))?;
    let comments = issue.comments.unwrap_or_default();

    use forgejo_api::structs::StateType;
    let state = match state {
        StateType::Open => "open",
        StateType::Closed => "closed",
    };
    ftl_println!(
        "msg-issue-view-header",
        title,
        number,
        author = username,
        state,
    );

    crate::render_label_list(&issue.labels.unwrap_or_default())?;

    if let Some(body) = &issue.body
        && !body.is_empty()
    {
        println!("\n{}", crate::markdown(body));
    }
    println!();

    crate::repo::archived_warning(&repo_info)?;

    ftl_println!("msg-issue-view-comment_count", comments);
    Ok(())
}

#[allow(clippy::too_many_arguments)]
async fn view_issues(
    repo: &RepoName,
    api: &Forgejo,
    json: &JsonArgs,
    query_str: Option<String>,
    labels: Option<String>,
    creator: Option<String>,
    assignee: Option<String>,
    state: Option<State>,
    page: Option<NonZeroU32>,
    milestones: Option<String>,
) -> eyre::Result<()> {
    const PAGE_SIZE: u32 = crate::prs::SEARCH_PAGE_SIZE;
    let labels = labels
        .map(|s| s.split(',').map(|s| s.to_string()).collect::<Vec<_>>())
        .unwrap_or_default();
    let query = forgejo_api::structs::IssueListIssuesQuery {
        q: query_str,
        labels: Some(labels.join(",")),
        created_by: creator,
        assigned_by: assignee,
        state: state.map(|s| s.into()),
        r#type: Some(forgejo_api::structs::IssueListIssuesQueryType::Issues),
        milestones,
        since: None,
        before: None,
        mentioned_by: None,
        sort: None,
    };
    if json.enabled() {
        let issues = match page {
            Some(page) => {
                api.issue_list_issues(repo.owner(), repo.name(), query)
                    .page_size(PAGE_SIZE)
                    .page(page.get())
                    .await?
                    .1
            }
            None => {
                api.issue_list_issues(repo.owner(), repo.name(), query)
                    .all()
                    .await?
            }
        };
        return json.print(&issues);
    }
    let issues = if let Some(page) = page {
        let page = page.get();
        let (header, issues) = api
            .issue_list_issues(repo.owner(), repo.name(), query)
            .page_size(PAGE_SIZE)
            .page(page)
            .await?;

        let total_pages = header
            .count()
            .ok_or_eyre("expected header to return a number")?
            .div_ceil(PAGE_SIZE as usize);

        ftl_println!(
            "msg-issue-search-page-total",
            page,
            total_pages,
            issues = issues.len(),
        );

        issues
    } else {
        let issues = api
            .issue_list_issues(repo.owner(), repo.name(), query)
            .all()
            .await?;
        ftl_println!(
            "msg-issue-search-page-total",
            page = 1,
            total_pages = 1,
            issues = issues.len(),
        );
        issues
    };

    for issue in issues {
        let number = issue
            .number
            .ok_or_else(|| eyre::eyre!("issue does not have number"))?;
        let title = issue
            .title
            .as_ref()
            .ok_or_else(|| eyre::eyre!("issue does not have title"))?;
        let user = issue
            .user
            .as_ref()
            .ok_or_else(|| eyre::eyre!("issue does not have creator"))?;
        let username = user
            .login
            .as_ref()
            .ok_or_else(|| eyre::eyre!("user does not have login"))?;
        ftl_println!("msg-issue-search-entry", number, title, author = username);
    }
    Ok(())
}

pub async fn view_issue_templates(repo: &RepoName, api: &Forgejo) -> eyre::Result<()> {
    let crate::SpecialRender {
        dash, bold, reset, ..
    } = crate::special_render();

    let mut total_count = 0;

    if let Ok(templates) = api
        .repo_get_issue_templates(repo.owner(), repo.name())
        .await
    {
        total_count += templates.len();
        for template in templates {
            let filename = template
                .file_name
                .as_deref()
                .ok_or_eyre("template does not have filename")?;
            let name = filename
                .rsplit_once(".")
                .map(|(s, _)| s)
                .unwrap_or(filename);
            let name = name.rsplit_once("/").map(|(_, s)| s).unwrap_or(name);
            let display_name = template.name.as_deref().filter(|s| !s.is_empty());
            print!("{bold}{name}{reset}");
            if let Some(display_name) = display_name {
                print!(" {dash} {display_name}");
            }
            println!();
            let desc = template.about.as_deref().filter(|s| !s.is_empty());
            if let Some(desc) = desc {
                println!("{}", crate::render_text(desc));
            }
            println!();
        }
    }

    let config = api.repo_get_issue_config(repo.owner(), repo.name()).await?;
    let contact_links = config.contact_links.unwrap_or_default();
    total_count += contact_links.len();
    for contact in contact_links {
        let url = contact.url.ok_or_eyre("contact info does not have url")?;
        let name = contact.name.ok_or_eyre("contact info does not have name")?;
        println!("{bold}{url}{reset} {dash} {name}");
        let desc = contact.about.as_deref().filter(|s| !s.is_empty());
        if let Some(desc) = desc {
            println!("{}", crate::render_text(desc));
        }
        println!();
    }

    if total_count == 0 {
        ftl_eprintln!("msg-issue-templates-none");
    }
    if config.blank_issues_enabled.unwrap_or(true) {
        ftl_eprintln!("msg-issue-templates-blank_allowed");
    } else {
        ftl_eprintln!("msg-issue-templates-blank_not_allowed");
    }
    Ok(())
}

async fn view_issue_json(
    repo: &RepoName,
    api: &Forgejo,
    number: i64,
    command: Option<ViewCommand>,
    json: &JsonArgs,
) -> eyre::Result<()> {
    match command.unwrap_or(ViewCommand::Body) {
        ViewCommand::Body => {
            json.print(&api.issue_get_issue(repo.owner(), repo.name(), number).await?)
        }
        ViewCommand::Assignees => {
            let issue = api.issue_get_issue(repo.owner(), repo.name(), number).await?;
            json.print(&issue.assignees.unwrap_or_default())
        }
        ViewCommand::Comments => json.print(&get_comments(repo, api, number).await?),
        ViewCommand::Comment { idx } => {
            let comments = get_comments(repo, api, number).await?;
            let comment = comments
                .get(idx)
                .ok_or_else(|| eyre!("comment {idx} doesn't exist"))?;
            json.print(comment)
        }
    }
}

pub async fn get_comments(repo: &RepoName, api: &Forgejo, id: i64) -> eyre::Result<Vec<Comment>> {
    let query = IssueGetCommentsQuery {
        since: None,
        before: None,
    };
    let (_, comments) = api
        .issue_get_comments(repo.owner(), repo.name(), id, query)
        .await?;
    Ok(comments)
}

pub async fn view_comment(repo: &RepoName, api: &Forgejo, id: i64, idx: usize) -> eyre::Result<()> {
    let query = IssueGetCommentsQuery {
        since: None,
        before: None,
    };
    let (_, comments) = api
        .issue_get_comments(repo.owner(), repo.name(), id, query)
        .await?;
    let comment = comments
        .get(idx)
        .ok_or_else(|| eyre!("comment {idx} doesn't exist"))?;
    print_comment(comment)?;
    Ok(())
}

pub async fn view_comments(repo: &RepoName, api: &Forgejo, id: i64) -> eyre::Result<()> {
    let query = IssueGetCommentsQuery {
        since: None,
        before: None,
    };
    let (_, comments) = api
        .issue_get_comments(repo.owner(), repo.name(), id, query)
        .await?;
    for comment in comments {
        print_comment(&comment)?;
        println!();
    }
    Ok(())
}

pub async fn view_assignees(repo: &RepoName, api: &Forgejo, number: i64) -> eyre::Result<()> {
    let issue = api
        .issue_get_issue(repo.owner(), repo.name(), number)
        .await?;
    let assignees = issue.assignees.unwrap_or_default();
    if assignees.is_empty() {
        ftl_println!("msg-view-assignees-empty");
        return Ok(());
    }
    ftl_println!("msg-view-assignees-header", count = assignees.len(),);
    for user in assignees {
        let full_name = user.full_name.as_deref().filter(|name| !name.is_empty());
        let login = user
            .login
            .as_ref()
            .ok_or_else(|| eyre::eyre!("assignee does not have login"))?;
        ftl_println!("msg-view-assignees-entry", full_name, login);
    }
    Ok(())
}

fn print_comment(comment: &Comment) -> eyre::Result<()> {
    let body = comment
        .body
        .as_ref()
        .ok_or_else(|| eyre::eyre!("comment does not have body"))?;
    let user = comment
        .user
        .as_ref()
        .ok_or_else(|| eyre::eyre!("comment does not have user"))?;
    let full_name = user.full_name.as_deref().filter(|name| !name.is_empty());
    let username = user
        .login
        .as_ref()
        .ok_or_else(|| eyre::eyre!("user does not have login"))?;

    ftl_println!(
        "msg-issue-view-comments-comment_header",
        full_name,
        username,
    );
    println!("{}", crate::markdown(body));
    let assets = comment
        .assets
        .as_ref()
        .ok_or_else(|| eyre::eyre!("comment does not have assets"))?;
    if !assets.is_empty() {
        ftl_println!(
            "msg-issue-view-comments-attachments",
            attachments = assets.len(),
        );
    }
    Ok(())
}

pub async fn browse_issue(repo: &RepoName, api: &Forgejo, id: i64) -> eyre::Result<()> {
    let issue = api.issue_get_issue(repo.owner(), repo.name(), id).await?;
    let html_url = issue
        .html_url
        .as_ref()
        .ok_or_else(|| eyre::eyre!("issue does not have html_url"))?;
    open::that_detached(html_url.as_str()).wrap_err("Failed to open URL")?;
    Ok(())
}

pub async fn add_comment(
    repo: &RepoName,
    api: &Forgejo,
    issue: i64,
    body: Option<String>,
    body_file: Option<PathBuf>,
) -> eyre::Result<()> {
    let body_from_file = match body_file {
        None => None,
        Some(ref path) => Some(crate::read_file_or_stdin(path).await?),
    };
    let body = match body.or(body_from_file) {
        Some(body) => body,
        None => {
            let mut body = String::new();
            crate::editor(&mut body, Some("md")).await?;
            body
        }
    };
    api.issue_create_comment(
        repo.owner(),
        repo.name(),
        issue,
        forgejo_api::structs::CreateIssueCommentOption {
            body,
            updated_at: None,
        },
    )
    .await?;
    Ok(())
}

pub async fn edit_title(
    repo: &RepoName,
    api: &Forgejo,
    issue: i64,
    new_title: Option<String>,
) -> eyre::Result<()> {
    let new_title = match new_title {
        Some(s) => s,
        None => {
            let issue_info = api
                .issue_get_issue(repo.owner(), repo.name(), issue)
                .await?;
            let mut title = issue_info
                .title
                .ok_or_else(|| eyre::eyre!("issue does not have title"))?;
            crate::editor(&mut title, Some("md")).await?;
            title
        }
    };
    let new_title = new_title.trim();
    if new_title.is_empty() {
        ftl_bail!("msg-issue-edit-title-empty");
    }
    if new_title.contains('\n') {
        ftl_bail!("msg-issue-edit-title-no_newlines");
    }
    api.issue_edit_issue(
        repo.owner(),
        repo.name(),
        issue,
        forgejo_api::structs::EditIssueOption {
            title: Some(new_title.to_owned()),
            #[allow(deprecated)]
            assignee: None,
            assignees: None,
            body: None,
            due_date: None,
            milestone: None,
            r#ref: None,
            state: None,
            unset_due_date: None,
            updated_at: None,
        },
    )
    .await?;
    Ok(())
}

pub async fn edit_body(
    repo: &RepoName,
    api: &Forgejo,
    issue: i64,
    new_body: Option<String>,
) -> eyre::Result<()> {
    let new_body = match new_body {
        Some(s) => s,
        None => {
            let issue_info = api
                .issue_get_issue(repo.owner(), repo.name(), issue)
                .await?;
            let mut body = issue_info
                .body
                .ok_or_else(|| eyre::eyre!("issue does not have body"))?;
            crate::editor(&mut body, Some("md")).await?;
            body
        }
    };
    api.issue_edit_issue(
        repo.owner(),
        repo.name(),
        issue,
        forgejo_api::structs::EditIssueOption {
            body: Some(new_body),
            #[allow(deprecated)]
            assignee: None,
            assignees: None,
            due_date: None,
            milestone: None,
            r#ref: None,
            state: None,
            title: None,
            unset_due_date: None,
            updated_at: None,
        },
    )
    .await?;
    Ok(())
}

pub async fn edit_comment(
    repo: &RepoName,
    api: &Forgejo,
    issue: i64,
    idx: usize,
    new_body: Option<String>,
) -> eyre::Result<()> {
    let (_, comments) = api
        .issue_get_comments(
            repo.owner(),
            repo.name(),
            issue,
            IssueGetCommentsQuery {
                since: None,
                before: None,
            },
        )
        .await?;
    let comment = comments
        .get(idx)
        .ok_or_else(|| eyre!("comment not found"))?;
    let new_body = match new_body {
        Some(s) => s,
        None => {
            let mut body = comment
                .body
                .clone()
                .ok_or_else(|| eyre::eyre!("issue does not have body"))?;
            crate::editor(&mut body, Some("md")).await?;
            body
        }
    };
    let id = comment
        .id
        .ok_or_else(|| eyre::eyre!("comment does not have id"))?;
    api.issue_edit_comment(
        repo.owner(),
        repo.name(),
        id,
        forgejo_api::structs::EditIssueCommentOption {
            body: new_body,
            updated_at: None,
        },
    )
    .await?;
    Ok(())
}

pub async fn assign_to_issue(
    repo: &RepoName,
    api: &Forgejo,
    index: i64,
    users: Vec<String>,
) -> eyre::Result<()> {
    let num_to_add = users.len();
    let issue = api
        .issue_get_issue(repo.owner(), repo.name(), index)
        .await?;
    let mut assignees = issue
        .assignees
        .unwrap_or_default()
        .into_iter()
        .filter_map(|user| user.login)
        .collect::<Vec<_>>();
    let assigned_before = assignees.len();
    assignees.extend(users);
    assignees
        .iter_mut()
        .for_each(|name| name.make_ascii_lowercase());
    assignees.sort_unstable();
    assignees.dedup();
    let assigned_after = assignees.len();
    let opt = forgejo_api::structs::EditIssueOption {
        #[allow(deprecated)]
        assignee: None,
        assignees: Some(assignees),
        body: None,
        due_date: None,
        milestone: None,
        r#ref: None,
        state: None,
        title: None,
        unset_due_date: None,
        updated_at: None,
    };
    api.issue_edit_issue(repo.owner(), repo.name(), index, opt)
        .await?;
    let added = assigned_after - assigned_before;
    let duplicate = num_to_add - added;
    ftl_println!(
        "msg-issue-assign-success",
        owner = repo.owner(),
        repo = repo.name(),
        number = index,
        added,
        duplicate,
    );
    Ok(())
}

pub async fn unassign_from_issue(
    repo: &RepoName,
    api: &Forgejo,
    index: i64,
    users: Vec<String>,
) -> eyre::Result<()> {
    let num_to_remove = users.len();
    let issue = api
        .issue_get_issue(repo.owner(), repo.name(), index)
        .await?;
    let mut assignees = issue
        .assignees
        .unwrap_or_default()
        .into_iter()
        .filter_map(|user| user.login)
        .collect::<Vec<_>>();
    let assigned_before = assignees.len();
    assignees.retain(|a| !users.iter().any(|b| a.eq_ignore_ascii_case(b)));
    let assigned_after = assignees.len();
    let opt = forgejo_api::structs::EditIssueOption {
        #[allow(deprecated)]
        assignee: None,
        assignees: Some(assignees),
        body: None,
        due_date: None,
        milestone: None,
        r#ref: None,
        state: None,
        title: None,
        unset_due_date: None,
        updated_at: None,
    };
    api.issue_edit_issue(repo.owner(), repo.name(), index, opt)
        .await?;
    let removed = assigned_before - assigned_after;
    let duplicate = num_to_remove - removed;
    ftl_println!(
        "msg-issue-unassign-success",
        owner = repo.owner(),
        repo = repo.name(),
        number = index,
        removed,
        duplicate,
    );
    Ok(())
}

pub async fn close_issue(
    repo: &RepoName,
    api: &Forgejo,
    issue: i64,
    message: Option<Option<String>>,
) -> eyre::Result<()> {
    if let Some(message) = message {
        let body = match message {
            Some(m) => m,
            None => {
                let mut s = String::new();
                crate::editor(&mut s, Some("md")).await?;
                s
            }
        };

        let opt = CreateIssueCommentOption {
            body,
            updated_at: None,
        };
        api.issue_create_comment(repo.owner(), repo.name(), issue, opt)
            .await?;
    }

    let edit = EditIssueOption {
        state: Some("closed".into()),
        #[allow(deprecated)]
        assignee: None,
        assignees: None,
        body: None,
        due_date: None,
        milestone: None,
        r#ref: None,
        title: None,
        unset_due_date: None,
        updated_at: None,
    };
    let issue_data = api
        .issue_edit_issue(repo.owner(), repo.name(), issue, edit)
        .await?;

    let issue_title = issue_data
        .title
        .as_deref()
        .ok_or_eyre("issue does not have title")?;

    ftl_println!(
        "msg-issue-close-success",
        number = issue,
        title = issue_title,
    );

    Ok(())
}

fn host_repo<'a>(issue: &'a IssueId, fallback: &'a RepoName) -> (&'a str, &'a str) {
    match &issue.repo {
        Some(r) => (r.owner(), r.name()),
        None => (fallback.owner(), fallback.name()),
    }
}

fn issue_meta_for(target: &IssueId, host_owner: &str, host_repo: &str) -> IssueMeta {
    match &target.repo {
        Some(r) => IssueMeta {
            index: target.number,
            owner: r.owner().to_string(),
            repo: r.name().to_string(),
        },
        None => IssueMeta {
            index: target.number,
            owner: host_owner.to_string(),
            repo: host_repo.to_string(),
        },
    }
}

async fn print_issue_list(
    header_msg: &str,
    host_owner: &str,
    host_repo_name: &str,
    host_number: i64,
    empty_msg: &str,
    list: Vec<forgejo_api::structs::Issue>,
) -> eyre::Result<()> {
    ftl_println!(
        header_msg,
        owner = host_owner,
        repo = host_repo_name,
        number = host_number,
    );
    if list.is_empty() {
        ftl_println!(empty_msg);
        return Ok(());
    }
    for issue in list {
        let number = issue
            .number
            .ok_or_else(|| eyre::eyre!("issue does not have number"))?;
        let title = issue
            .title
            .as_deref()
            .ok_or_else(|| eyre::eyre!("issue does not have title"))?;
        use forgejo_api::structs::StateType;
        let state = match (issue.state, &issue.pull_request) {
            (Some(StateType::Open), Some(pr)) if pr.draft == Some(true) => "draft",
            (Some(StateType::Closed), Some(pr)) if pr.merged == Some(true) => "merged",
            (Some(StateType::Closed), _) => "closed",
            _ => "open",
        };
        ftl_println!("msg-issue-dep-list-entry", number, title, state);
    }
    Ok(())
}

pub async fn add_dependencies(
    repo: &RepoName,
    api: &Forgejo,
    issue: IssueId,
    targets: Vec<IssueId>,
) -> eyre::Result<()> {
    if targets.is_empty() {
        ftl_bail!("msg-issue-dep-target-required");
    }
    let (host_owner, host_repo_name) = host_repo(&issue, repo);
    let count = targets.len();
    for target in &targets {
        let meta = issue_meta_for(target, host_owner, host_repo_name);
        api.issue_create_issue_dependencies(host_owner, host_repo_name, issue.number, meta)
            .await?;
    }
    ftl_println!("msg-issue-depend-add-success", count, issue = issue.number,);
    Ok(())
}

pub async fn remove_dependencies(
    repo: &RepoName,
    api: &Forgejo,
    issue: IssueId,
    targets: Vec<IssueId>,
) -> eyre::Result<()> {
    if targets.is_empty() {
        ftl_bail!("msg-issue-dep-target-required");
    }
    let (host_owner, host_repo_name) = host_repo(&issue, repo);
    let count = targets.len();
    for target in &targets {
        let meta = issue_meta_for(target, host_owner, host_repo_name);
        api.issue_remove_issue_dependencies(host_owner, host_repo_name, issue.number, meta)
            .await?;
    }
    ftl_println!(
        "msg-issue-depend-remove-success",
        count,
        issue = issue.number,
    );
    Ok(())
}

pub async fn view_dependencies(repo: &RepoName, api: &Forgejo, issue: IssueId) -> eyre::Result<()> {
    let (host_owner, host_repo_name) = host_repo(&issue, repo);
    let list = api
        .issue_list_issue_dependencies(host_owner, host_repo_name, issue.number)
        .await?;
    print_issue_list(
        "msg-issue-depend-list-header",
        host_owner,
        host_repo_name,
        issue.number,
        "msg-issue-depend-list-empty",
        list,
    )
    .await
}

pub async fn add_blocks(
    repo: &RepoName,
    api: &Forgejo,
    issue: IssueId,
    targets: Vec<IssueId>,
) -> eyre::Result<()> {
    if targets.is_empty() {
        ftl_bail!("msg-issue-dep-target-required");
    }
    let (host_owner, host_repo_name) = host_repo(&issue, repo);
    let count = targets.len();
    for target in &targets {
        let meta = issue_meta_for(target, host_owner, host_repo_name);
        api.issue_create_issue_blocking(host_owner, host_repo_name, issue.number, meta)
            .await?;
    }
    ftl_println!("msg-issue-block-add-success", count, issue = issue.number,);
    Ok(())
}

pub async fn remove_blocks(
    repo: &RepoName,
    api: &Forgejo,
    issue: IssueId,
    targets: Vec<IssueId>,
) -> eyre::Result<()> {
    if targets.is_empty() {
        ftl_bail!("msg-issue-dep-target-required");
    }
    let (host_owner, host_repo_name) = host_repo(&issue, repo);
    let count = targets.len();
    for target in &targets {
        let meta = issue_meta_for(target, host_owner, host_repo_name);
        api.issue_remove_issue_blocking(host_owner, host_repo_name, issue.number, meta)
            .await?;
    }
    ftl_println!(
        "msg-issue-block-remove-success",
        count,
        issue = issue.number,
    );
    Ok(())
}

pub async fn view_blocks(repo: &RepoName, api: &Forgejo, issue: IssueId) -> eyre::Result<()> {
    let (host_owner, host_repo_name) = host_repo(&issue, repo);
    let list = api
        .issue_list_blocks(host_owner, host_repo_name, issue.number)
        .await?;
    print_issue_list(
        "msg-issue-block-list-header",
        host_owner,
        host_repo_name,
        issue.number,
        "msg-issue-block-list-empty",
        list,
    )
    .await
}

pub async fn edit_milestone(
    repo: &RepoName,
    api: &forgejo_api::Forgejo,
    num: i64,
    milestone: Option<String>,
    unset: bool,
) -> eyre::Result<()> {
    match (milestone, unset) {
        (Some(_), true) | (None, false) => unreachable!(),
        (Some(milestone), false) => {
            // TODO: it's possible to omit this ID resolution with more flexible API bindings, see
            // comments in milestones.rs
            let id = milestones::get_milestone_id(repo, api, milestone).await?;

            api.issue_edit_issue(
                repo.owner(),
                repo.name(),
                num,
                EditIssueOption {
                    #[allow(deprecated)]
                    assignee: None,
                    assignees: None,
                    body: None,
                    due_date: None,
                    milestone: Some(id),
                    r#ref: None,
                    state: None,
                    title: None,
                    unset_due_date: None,
                    updated_at: None,
                },
            )
            .await?;
        }
        (None, true) => {
            api.issue_edit_issue(
                repo.owner(),
                repo.name(),
                num,
                EditIssueOption {
                    #[allow(deprecated)]
                    assignee: None,
                    assignees: None,
                    body: None,
                    due_date: None,
                    milestone: Some(0),
                    r#ref: None,
                    state: None,
                    title: None,
                    unset_due_date: None,
                    updated_at: None,
                },
            )
            .await?;
        }
    }
    Ok(())
}

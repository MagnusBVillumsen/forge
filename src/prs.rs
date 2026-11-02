use std::collections::BTreeMap;
use std::num::NonZeroU32;
use std::path::PathBuf;
use std::{io::Write, str::FromStr};

use clap::{Args, Subcommand};
use eyre::{Context, OptionExt};
use forgejo_api::{
    CountHeader, Forgejo,
    structs::{
        CreatePullRequestOption, MergePullRequestOption, PullReview, PullReviewComment,
        PullReviewRequestOptions, RepoGetPullRequestCommitsQuery, RepoGetPullRequestFilesQuery,
        StateType,
    },
};
use futures::stream::{StreamExt, TryStreamExt};

use crate::{
    SpecialRender,
    json::JsonArgs,
    issues::IssueId,
    localization::AsFluent,
    repo::{RepoArg, RepoInfo, RepoName},
};
use crate::{
    ftl_bail, ftl_ensure, ftl_eprintln, ftl_eyre, ftl_format, ftl_println, h, lh, milestones,
};

#[derive(Args, Clone, Debug)]
pub struct PrCommand {
    #[clap(help = h!("arg-remote"))]
    #[clap(long, short = 'R')]
    remote: Option<String>,
    #[clap(subcommand)]
    command: PrSubcommand,
}

#[derive(Subcommand, Clone, Debug)]
pub enum PrSubcommand {
    #[clap(about = h!("cmd-pr-search"), visible_alias = "list")]
    Search {
        #[clap(flatten)]
        json: JsonArgs,

        query: Option<String>,

        #[clap(long, short)]
        labels: Option<String>,

        #[clap(long, short)]
        creator: Option<String>,

        #[clap(long, short)]
        assignee: Option<String>,

        #[clap(help = h!("arg-pr-search-state"))]
        #[clap(long, short)]
        state: Option<crate::issues::State>,

        #[clap(help = h!("arg-pr-search-repo"))]
        #[clap(long, short)]
        repo: Option<RepoArg>,

        #[clap(conflicts_with = "all", value_parser = parse_non_zero_u32)]
        #[clap(long, short, default_value_t = NonZeroU32::MIN)]
        page: NonZeroU32,

        #[clap(help = h!("arg-pr-search-all"))]
        #[clap(long, conflicts_with = "page")]
        all: bool,

        #[clap(help = h!("arg-pr-search-milestones"))]
        #[clap(long, short)]
        milestones: Option<String>,
    },
    #[clap(about = h!("cmd-pr-create"))]
    Create {
        #[clap(help = h!("arg-pr-create-base"))]
        #[clap(long)]
        base: Option<String>,

        #[clap(help = h!("arg-pr-create-head"))]
        #[clap(long, group = "source")]
        head: Option<String>,

        #[clap(help = h!("arg-pr-create-title"), long_help = lh!("arg-pr-create-title"))]
        #[clap(group = "web-or-cmd")]
        title: Option<String>,

        #[clap(help = h!("arg-pr-create-body"), long_help = lh!("arg-pr-create-body"))]
        #[clap(long)]
        body: Option<String>,

        #[clap(long, conflicts_with = "body")]
        body_file: Option<PathBuf>,

        #[clap(help = h!("arg-pr-create-autofill"), long_help = lh!("arg-pr-create-autofill"))]
        #[clap(short = 'A', long, alias = "fill")]
        autofill: bool,

        #[clap(help = h!("arg-pr-create-repo"))]
        #[clap(long, short)]
        repo: Option<RepoArg>,

        #[clap(help = h!("arg-pr-create-web"))]
        #[clap(short, long, group = "web-or-cmd", group = "web-or-agit")]
        web: bool,

        #[clap(help = h!("arg-pr-create-agit"))]
        #[clap(short, long, group = "source", group = "web-or-agit")]
        agit: bool,

        #[clap(help = h!("arg-pr-create-milestone"))]
        #[clap(long)]
        milestone: Option<String>,
    },
    #[clap(about = h!("cmd-pr-view"))]
    View {
        #[clap(help = h!("arg-pr-view-id"))]
        id: Option<IssueId>,
        #[clap(flatten)]
        json: JsonArgs,
        #[clap(subcommand)]
        command: Option<ViewCommand>,
    },
    #[clap(about = h!("cmd-pr-status"))]
    Status {
        #[clap(help = h!("arg-pr-status-id"))]
        id: Option<IssueId>,
        #[clap(help = h!("arg-pr-status-wait"))]
        #[clap(long)]
        wait: bool,
        #[clap(flatten)]
        json: JsonArgs,
    },
    #[clap(about = h!("cmd-pr-checkout"))]
    Checkout {
        #[clap(help = h!("arg-pr-checkout-pr"), long_help = lh!("arg-pr-checkout-pr"))]
        #[clap(id = "ID")]
        pr: PrNumber,

        #[clap(help = h!("arg-pr-checkout-branch_name"), long_help = lh!("arg-pr-checkout-branch_name"))]
        #[clap(long, id = "NAME")]
        branch_name: Option<String>,

        #[clap(help = h!("arg-pr-checkout-ssh"))]
        #[clap(long, short = 'S')]
        ssh: Option<Option<bool>>,

        #[clap(help = h!("arg-pr-checkout-identity_file"))]
        #[clap(long, short = 'I')]
        identity_file: Option<PathBuf>,
    },
    #[clap(about = h!("cmd-pr-comment"))]
    Comment {
        #[clap(help = h!("arg-pr-comment-pr"))]
        pr: Option<IssueId>,

        #[clap(help = h!("arg-pr-comment-body"), long_help = lh!("arg-pr-comment-body"))]
        body: Option<String>,

        #[clap(help = h!("arg-pr-comment-body_file"))]
        #[clap(long, conflicts_with = "body")]
        body_file: Option<PathBuf>,
    },
    #[clap(about = h!("cmd-pr-assign"))]
    Assign {
        #[clap(long, short)]
        pr: Option<IssueId>,
        #[clap(help = h!("arg-pr-assign-users"))]
        users: Vec<String>,
    },
    #[clap(about = h!("cmd-pr-unassign"))]
    Unassign {
        #[clap(long, short)]
        pr: Option<IssueId>,
        #[clap(help = h!("arg-pr-unassign-users"))]
        users: Vec<String>,
    },
    #[clap(about = h!("cmd-pr-depend"))]
    Depend(PrDependCommand),
    #[clap(about = h!("cmd-pr-block"))]
    Block(PrBlockCommand),
    #[clap(about = h!("cmd-pr-edit"))]
    Edit {
        #[clap(help = h!("arg-pr-edit-pr"))]
        pr: Option<IssueId>,
        #[clap(subcommand)]
        command: EditCommand,
    },
    #[clap(about = h!("cmd-pr-close"))]
    Close {
        #[clap(help = h!("arg-pr-close-pr"))]
        pr: Option<IssueId>,
        #[clap(help = h!("arg-pr-close-with_msg"), long_help = lh!("arg-pr-close-with_msg"))]
        #[clap(long, short)]
        with_msg: Option<Option<String>>,
    },
    #[clap(about = h!("cmd-pr-merge"))]
    Merge {
        #[clap(help = h!("arg-pr-merge-pr"))]
        pr: Option<IssueId>,

        #[clap(help = h!("arg-pr-merge-method"))]
        #[clap(long, short = 'M')]
        method: Option<MergeMethod>,

        #[clap(help = h!("arg-pr-merge-delete"))]
        #[clap(long, short)]
        delete: bool,

        #[clap(help = h!("arg-pr-merge-title"))]
        #[clap(long, short)]
        title: Option<String>,

        #[clap(help = h!("arg-pr-merge-message"))]
        #[clap(long, short)]
        message: Option<Option<String>>,
    },
    #[clap(about = h!("cmd-pr-browse"))]
    Browse {
        #[clap(help = h!("arg-pr-browse-id"))]
        id: Option<IssueId>,
    },
    #[clap(about = h!("cmd-pr-review"))]
    Review {
        #[clap(help = h!("arg-pr-review-id"))]
        id: Option<IssueId>,
        #[clap(subcommand)]
        command: Option<ReviewCommand>,
    },
}

#[derive(clap::ValueEnum, Clone, Copy, Debug)]
pub enum MergeMethod {
    Merge,
    Rebase,
    RebaseMerge,
    Squash,
    Manual,
    FastForwardOnly,
}

#[derive(Clone, Copy, Debug)]
pub enum PrNumber {
    This(i64),
    Parent(i64),
}

impl PrNumber {
    fn number(self) -> i64 {
        match self {
            PrNumber::This(x) => x,
            PrNumber::Parent(x) => x,
        }
    }
}

impl FromStr for PrNumber {
    type Err = std::num::ParseIntError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if let Some(num) = s.strip_prefix("^") {
            Ok(Self::Parent(num.parse::<u64>()? as i64))
        } else {
            Ok(Self::This(s.parse::<u64>()? as i64))
        }
    }
}

impl From<MergeMethod> for forgejo_api::structs::MergePullRequestOptionDo {
    fn from(value: MergeMethod) -> Self {
        use forgejo_api::structs::MergePullRequestOptionDo::*;
        match value {
            MergeMethod::Merge => Merge,
            MergeMethod::Rebase => Rebase,
            MergeMethod::RebaseMerge => RebaseMerge,
            MergeMethod::Squash => Squash,
            MergeMethod::Manual => ManuallyMerged,
            MergeMethod::FastForwardOnly => FastForwardOnly,
        }
    }
}

#[derive(Subcommand, Clone, Debug)]
pub enum EditCommand {
    #[clap(about = h!("cmd-pr-edit-title"))]
    Title {
        #[clap(help = h!("arg-pr-edit-title-new_title"), long_help = lh!("arg-pr-edit-title-new_title"))]
        new_title: Option<String>,
    },
    #[clap(about = h!("cmd-pr-edit-body"))]
    Body {
        #[clap(help = h!("arg-pr-edit-body-new_body"), long_help = lh!("arg-pr-edit-body-new_body"))]
        new_body: Option<String>,
    },
    #[clap(about = h!("cmd-pr-edit-comment"))]
    Comment {
        #[clap(help = h!("arg-pr-edit-comment-idx"))]
        idx: usize,

        #[clap(help = h!("arg-pr-edit-comment-new_body"), long_help = lh!("arg-pr-edit-comment-new_body"))]
        new_body: Option<String>,
    },
    #[clap(about = h!("cmd-pr-edit-labels"))]
    Labels {
        #[clap(help = h!("arg-pr-edit-labels-add"))]
        #[clap(long, short)]
        add: Vec<String>,

        #[clap(help = h!("arg-pr-edit-labels-rm"))]
        #[clap(long, short)]
        rm: Vec<String>,
    },
    #[clap(about = h!("cmd-pr-edit-milestone"))]
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
    #[clap(about = h!("cmd-pr-view-body"))]
    Body,
    #[clap(about = h!("cmd-pr-view-comment"))]
    Comment {
        #[clap(help = h!("arg-pr-view-comment-idx"))]
        idx: usize,
    },
    #[clap(about = h!("cmd-pr-view-comments"))]
    Comments,
    #[clap(about = h!("cmd-pr-view-labels"))]
    Labels,
    #[clap(about = h!("cmd-pr-view-assignees"))]
    Assignees,
    #[clap(about = h!("cmd-pr-view-diff"))]
    Diff {
        #[clap(help = h!("arg-pr-view-diff-patch"))]
        #[clap(long, short)]
        patch: bool,
        #[clap(help = h!("arg-pr-view-diff-editor"))]
        #[clap(long, short)]
        editor: bool,
    },
    #[clap(about = h!("cmd-pr-view-files"))]
    Files,
    #[clap(about = h!("cmd-pr-view-commits"))]
    Commits {
        #[clap(help = h!("arg-pr-view-commits-oneline"))]
        #[clap(long, short)]
        oneline: bool,
    },
}

#[derive(Args, Clone, Debug)]
pub struct PrDependCommand {
    #[clap(subcommand)]
    pub command: PrDependSubcommand,
}

#[derive(Subcommand, Clone, Debug)]
pub enum PrDependSubcommand {
    #[clap(about = h!("cmd-depend-add"))]
    Add {
        #[clap(help = h!("arg-pr-depend-add-pr"))]
        #[clap(long, short)]
        pr: Option<IssueId>,
        #[clap(help = h!("arg-depend-add-target"))]
        target: Vec<IssueId>,
    },
    #[clap(about = h!("cmd-depend-remove"))]
    Remove {
        #[clap(help = h!("arg-pr-depend-remove-pr"))]
        #[clap(long, short)]
        pr: Option<IssueId>,
        #[clap(help = h!("arg-depend-remove-target"))]
        target: Vec<IssueId>,
    },
    #[clap(about = h!("cmd-depend-list"))]
    List {
        #[clap(help = h!("arg-pr-depend-list-pr"))]
        #[clap(long, short)]
        pr: Option<IssueId>,
    },
}

#[derive(Args, Clone, Debug)]
pub struct PrBlockCommand {
    #[clap(subcommand)]
    pub command: PrBlockSubcommand,
}

#[derive(Subcommand, Clone, Debug)]
pub enum PrBlockSubcommand {
    #[clap(about = h!("cmd-block-add"))]
    Add {
        #[clap(help = h!("arg-pr-block-add-pr"))]
        #[clap(long, short)]
        pr: Option<IssueId>,
        #[clap(help = h!("arg-pr-block-add-target"))]
        target: Vec<IssueId>,
    },
    #[clap(about = h!("cmd-block-remove"))]
    Remove {
        #[clap(help = h!("arg-pr-block-remove-pr"))]
        #[clap(long, short)]
        pr: Option<IssueId>,
        #[clap(help = h!("arg-block-remove-target"))]
        target: Vec<IssueId>,
    },
    #[clap(about = h!("cmd-block-list"))]
    List {
        #[clap(help = h!("arg-pr-block-list-pr"))]
        #[clap(long, short)]
        pr: Option<IssueId>,
    },
}

#[derive(Subcommand, Clone, Debug)]
pub enum ReviewCommand {
    #[clap(about = h!("cmd-pr-review-list"))]
    List {
        #[clap(help = h!("arg-pr-review-list-comments"))]
        #[clap(long, short)]
        comments: bool,
        #[clap(help = h!("arg-pr-review-list-all"))]
        #[clap(long, short)]
        all: bool,
    },
    #[clap(about = h!("cmd-pr-review-request"))]
    #[group(required = true, multiple = true)]
    Request {
        #[clap(help = h!("arg-pr-review-request-reviewers"))]
        reviewers: Option<Vec<String>>,

        #[clap(help = h!("arg-pr-review-request-team"))]
        #[clap(long = "team", short)]
        team_reviewers: Option<Vec<String>>,
    },
}

// Used in `issues` module
pub const SEARCH_PAGE_SIZE: u32 = 25;

pub fn parse_non_zero_u32(s: &str) -> eyre::Result<NonZeroU32> {
    s.parse::<u32>()
        .ok()
        .and_then(NonZeroU32::new)
        .ok_or_else(|| ftl_eyre!("msg-pr-search-page-argument-error"))
}

impl PrCommand {
    pub async fn run(self, keys: &mut crate::KeyInfo, host_name: Option<&str>) -> eyre::Result<()> {
        use PrSubcommand::*;
        let repo_info =
            RepoInfo::get_current(host_name, self.repo(), self.remote.as_deref(), keys)?;
        let api = keys.get_api(repo_info.host_url()).await?;
        let repo = repo_info.name().ok_or_else(|| self.no_repo_error())?;
        match self.command {
            Create {
                title,
                base,
                head,
                body,
                body_file,
                autofill,
                repo: _,
                web,
                agit,
                milestone,
            } => {
                create_pr(
                    repo,
                    &api,
                    title,
                    base,
                    head,
                    body,
                    body_file,
                    autofill,
                    web,
                    agit,
                    milestone,
                    repo_info.remote_name(),
                )
                .await?
            }
            Merge {
                pr,
                method,
                delete,
                title,
                message,
            } => {
                merge_pr(
                    repo,
                    &api,
                    pr.map(|id| id.number),
                    method,
                    delete,
                    title,
                    message,
                )
                .await?
            }
            View { id, json, command } if json.enabled() => {
                view_pr_json(repo, &api, id.map(|id| id.number), command, &json).await?
            }
            View { id, command, .. } => {
                let id = id.map(|id| id.number);
                match command.unwrap_or(ViewCommand::Body) {
                    ViewCommand::Body => view_pr(repo, &api, id).await?,
                    ViewCommand::Comment { idx } => {
                        let (repo, id) = try_get_pr_number(repo, &api, id).await?;
                        crate::issues::view_comment(&repo, &api, id, idx).await?
                    }
                    ViewCommand::Comments => {
                        let (repo, id) = try_get_pr_number(repo, &api, id).await?;
                        crate::issues::view_comments(&repo, &api, id).await?
                    }
                    ViewCommand::Labels => view_pr_labels(repo, &api, id).await?,
                    ViewCommand::Assignees => {
                        let (repo, id) = try_get_pr_number(repo, &api, id).await?;
                        crate::issues::view_assignees(&repo, &api, id).await?
                    }
                    ViewCommand::Diff { patch, editor } => {
                        view_diff(repo, &api, id, patch, editor).await?
                    }
                    ViewCommand::Files => view_pr_files(repo, &api, id).await?,
                    ViewCommand::Commits { oneline } => {
                        view_pr_commits(repo, &api, id, oneline).await?
                    }
                }
            }
            Status { id, wait, json } => {
                view_pr_status(repo, &api, id.map(|id| id.number), wait, &json).await?
            }
            Search {
                json,
                query,
                labels,
                creator,
                assignee,
                state,
                repo: _,
                page,
                all,
                milestones,
            } => {
                view_prs(
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
            Assign { pr, users } => {
                let (repo, pr) = try_get_pr_number(repo, &api, pr.map(|pr| pr.number)).await?;
                crate::issues::assign_to_issue(&repo, &api, pr, users).await?
            }
            Unassign { pr, users } => {
                let (repo, pr) = try_get_pr_number(repo, &api, pr.map(|pr| pr.number)).await?;
                crate::issues::unassign_from_issue(&repo, &api, pr, users).await?
            }
            Depend(cmd) => match cmd.command {
                PrDependSubcommand::Add { pr, target } => {
                    let (repo, number) =
                        try_get_pr_number(repo, &api, pr.as_ref().map(|pr| pr.number)).await?;
                    let pr = IssueId {
                        repo: pr.and_then(|pr| pr.repo),
                        number,
                    };
                    crate::issues::add_dependencies(&repo, &api, pr, target).await?
                }
                PrDependSubcommand::Remove { pr, target } => {
                    let (repo, number) =
                        try_get_pr_number(repo, &api, pr.as_ref().map(|pr| pr.number)).await?;
                    let pr = IssueId {
                        repo: pr.and_then(|pr| pr.repo),
                        number,
                    };
                    crate::issues::remove_dependencies(&repo, &api, pr, target).await?
                }
                PrDependSubcommand::List { pr } => {
                    let (repo, number) =
                        try_get_pr_number(repo, &api, pr.as_ref().map(|pr| pr.number)).await?;
                    let pr = IssueId {
                        repo: pr.and_then(|pr| pr.repo),
                        number,
                    };
                    crate::issues::view_dependencies(&repo, &api, pr).await?
                }
            },
            Block(cmd) => match cmd.command {
                PrBlockSubcommand::Add { pr, target } => {
                    let (repo, number) =
                        try_get_pr_number(repo, &api, pr.as_ref().map(|pr| pr.number)).await?;
                    let pr = IssueId {
                        repo: pr.and_then(|pr| pr.repo),
                        number,
                    };
                    crate::issues::add_blocks(&repo, &api, pr, target).await?
                }
                PrBlockSubcommand::Remove { pr, target } => {
                    let (repo, number) =
                        try_get_pr_number(repo, &api, pr.as_ref().map(|pr| pr.number)).await?;
                    let pr = IssueId {
                        repo: pr.and_then(|pr| pr.repo),
                        number,
                    };
                    crate::issues::remove_blocks(&repo, &api, pr, target).await?
                }
                PrBlockSubcommand::List { pr } => {
                    let (repo, number) =
                        try_get_pr_number(repo, &api, pr.as_ref().map(|pr| pr.number)).await?;
                    let pr = IssueId {
                        repo: pr.and_then(|pr| pr.repo),
                        number,
                    };
                    crate::issues::view_blocks(&repo, &api, pr).await?
                }
            },
            Edit { pr, command } => {
                let pr = pr.map(|pr| pr.number);
                match command {
                    EditCommand::Title { new_title } => {
                        let (repo, id) = try_get_pr_number(repo, &api, pr).await?;
                        crate::issues::edit_title(&repo, &api, id, new_title).await?
                    }
                    EditCommand::Body { new_body } => {
                        let (repo, id) = try_get_pr_number(repo, &api, pr).await?;
                        crate::issues::edit_body(&repo, &api, id, new_body).await?
                    }
                    EditCommand::Comment { idx, new_body } => {
                        let (repo, id) = try_get_pr_number(repo, &api, pr).await?;
                        crate::issues::edit_comment(&repo, &api, id, idx, new_body).await?
                    }
                    EditCommand::Labels { add, rm } => {
                        edit_pr_labels(repo, &api, pr, add, rm).await?
                    }
                    EditCommand::Milestone {
                        new_milestone,
                        unset,
                    } => edit_pr_milestone(repo, &api, pr, new_milestone, unset).await?,
                }
            }
            Close { pr, with_msg } => {
                let (repo, pr) = try_get_pr_number(repo, &api, pr.map(|pr| pr.number)).await?;
                crate::issues::close_issue(&repo, &api, pr, with_msg).await?
            }
            Checkout {
                pr,
                branch_name,
                ssh,
                identity_file: identity,
            } => {
                let url_host = crate::host_name(repo_info.host_url());
                let ssh = ssh
                    .unwrap_or_else(|| Some(keys.default_ssh.contains(url_host)))
                    .unwrap_or(true);
                checkout_pr(repo, &api, pr, branch_name, ssh, identity).await?
            }
            Browse { id } => {
                let (repo, id) = try_get_pr_number(repo, &api, id.map(|pr| pr.number)).await?;
                browse_pr(&repo, &api, id).await?
            }
            Comment {
                pr,
                body,
                body_file,
            } => {
                let (repo, pr) = try_get_pr_number(repo, &api, pr.map(|pr| pr.number)).await?;
                crate::issues::add_comment(&repo, &api, pr, body, body_file).await?
            }
            Review { id, command } => {
                let id = id.map(|id| id.number);
                match command.unwrap_or(ReviewCommand::List {
                    comments: false,
                    all: false,
                }) {
                    ReviewCommand::List { comments, all } => {
                        view_pr_reviews(repo, &api, id, comments, all).await?
                    }
                    ReviewCommand::Request {
                        reviewers,
                        team_reviewers,
                    } => request_pr_review(repo, &api, id, reviewers, team_reviewers).await?,
                }
            }
        }
        Ok(())
    }

    fn repo(&self) -> Option<&RepoArg> {
        use PrSubcommand::*;
        match &self.command {
            Search { repo, .. } | Create { repo, .. } => repo.as_ref(),
            Checkout { .. } => None,
            Depend(cmd) => match &cmd.command {
                PrDependSubcommand::Add { pr, .. }
                | PrDependSubcommand::Remove { pr, .. }
                | PrDependSubcommand::List { pr } => pr.as_ref().and_then(|x| x.repo.as_ref()),
            },
            Block(cmd) => match &cmd.command {
                PrBlockSubcommand::Add { pr, .. }
                | PrBlockSubcommand::Remove { pr, .. }
                | PrBlockSubcommand::List { pr } => pr.as_ref().and_then(|x| x.repo.as_ref()),
            },
            View { id: pr, .. }
            | Status { id: pr, .. }
            | Comment { pr, .. }
            | Assign { pr, .. }
            | Unassign { pr, .. }
            | Edit { pr, .. }
            | Close { pr, .. }
            | Merge { pr, .. }
            | Browse { id: pr }
            | Review { id: pr, .. } => pr.as_ref().and_then(|x| x.repo.as_ref()),
        }
    }

    fn no_repo_error(&self) -> eyre::Error {
        use PrSubcommand::*;
        match &self.command {
            Search { .. } | Create { .. } => {
                eyre::eyre!("can't figure what repo to access, try specifying with `--repo`")
            }
            Checkout { .. } => {
                if git2::Repository::discover(".").is_ok() {
                    eyre::eyre!(
                        "can't figure out what repo to access, try setting a remote tracking branch"
                    )
                } else {
                    eyre::eyre!("pr checkout only works if the current directory is a git repo")
                }
            }
            Depend(_) | Block(_) => {
                ftl_eyre!("msg-pr-depend-no_repo_info")
            }
            View { id: pr, .. }
            | Status { id: pr, .. }
            | Comment { pr, .. }
            | Assign { pr, .. }
            | Unassign { pr, .. }
            | Edit { pr, .. }
            | Close { pr, .. }
            | Merge { pr, .. }
            | Browse { id: pr, .. }
            | Review { id: pr, .. } => match pr {
                Some(pr) => eyre::eyre!(
                    "can't figure out what repo to access, try specifying with `{{owner}}/{{repo}}#{}`",
                    pr.number
                ),
                None => eyre::eyre!(
                    "can't figure out what repo to access, try specifying with `{{owner}}/{{repo}}#{{pr}}`",
                ),
            },
        }
    }
}

pub async fn view_pr(repo: &RepoName, api: &Forgejo, id: Option<i64>) -> eyre::Result<()> {
    let pr = try_get_pr(repo, api, id).await?;
    let id = pr.number.ok_or_eyre("pr does not have number")?;
    let repo = repo_name_from_pr(&pr)?;
    let repo_info = api.repo_get(repo.owner(), repo.name()).await?;

    let mut additions = 0;
    let mut deletions = 0;
    let query = RepoGetPullRequestFilesQuery {
        ..Default::default()
    };
    let files = api
        .repo_get_pull_request_files(repo.owner(), repo.name(), id, query)
        .all()
        .await?;
    for file in files {
        additions += file.additions.unwrap_or_default();
        deletions += file.deletions.unwrap_or_default();
    }
    let title = pr
        .title
        .as_deref()
        .ok_or_else(|| eyre::eyre!("pr does not have title"))?;
    let title_no_wip = title
        .strip_prefix("WIP: ")
        .or_else(|| title.strip_prefix("WIP:"));
    let (title, is_draft) = match title_no_wip {
        Some(title) => (title, true),
        None => (title, false),
    };
    let state = pr
        .state
        .ok_or_else(|| eyre::eyre!("pr does not have state"))?;
    let is_merged = pr.merged.unwrap_or_default();
    let state = match state {
        StateType::Open if is_draft => "draft",
        StateType::Open => "open",
        StateType::Closed if is_merged => "merged",
        StateType::Closed => "closed",
    };
    let base = pr.base.as_ref().ok_or_eyre("pr does not have base")?;
    let base_repo = base
        .repo
        .as_ref()
        .ok_or_eyre("base does not have repo")?
        .full_name
        .as_deref()
        .ok_or_eyre("base repo does not have name")?;
    let base_name = base
        .label
        .as_deref()
        .ok_or_eyre("base does not have label")?;
    let head = pr.head.as_ref().ok_or_eyre("pr does not have head")?;
    let head_repo = head
        .repo
        .as_ref()
        .ok_or_eyre("head does not have repo")?
        .full_name
        .as_deref()
        .ok_or_eyre("head repo does not have name")?;
    let head_name = head
        .label
        .as_deref()
        .ok_or_eyre("head does not have label")?;
    let head_name = if base_repo != head_repo {
        format!("{head_repo}:{head_name}")
    } else {
        head_name.to_owned()
    };
    let user = pr
        .user
        .as_ref()
        .ok_or_else(|| eyre::eyre!("pr does not have creator"))?;
    let username = user
        .login
        .as_ref()
        .ok_or_else(|| eyre::eyre!("user does not have login"))?;
    let comments = pr.comments.unwrap_or_default();

    let head_branch = if head_name.is_empty() {
        None
    } else {
        Some(head_name)
    };
    ftl_println!(
        "msg-pr-view-header",
        title,
        number = id,
        username,
        state,
        additions,
        deletions,
        head_branch,
        base_branch = base_name,
    );

    crate::render_label_list(pr.labels.as_deref().unwrap_or_default())?;

    if let Some(body) = &pr.body
        && !body.trim().is_empty()
    {
        println!("\n{}", crate::markdown(body));
    }
    println!();

    crate::repo::archived_warning(&repo_info)?;

    ftl_println!("msg-pr-view-comment_count", comments);
    Ok(())
}

async fn view_pr_json(
    repo: &RepoName,
    api: &Forgejo,
    id: Option<i64>,
    command: Option<ViewCommand>,
    json: &JsonArgs,
) -> eyre::Result<()> {
    let pr = try_get_pr(repo, api, id).await?;
    let number = pr.number.ok_or_eyre("pr does not have number")?;
    let repo = repo_name_from_pr(&pr)?;
    match command.unwrap_or(ViewCommand::Body) {
        ViewCommand::Body => json.print(&pr),
        ViewCommand::Labels => json.print(&pr.labels.unwrap_or_default()),
        ViewCommand::Assignees => json.print(&pr.assignees.unwrap_or_default()),
        ViewCommand::Comments => {
            json.print(&crate::issues::get_comments(&repo, api, number).await?)
        }
        ViewCommand::Comment { idx } => {
            let comments = crate::issues::get_comments(&repo, api, number).await?;
            let comment = comments
                .get(idx)
                .ok_or_else(|| eyre::eyre!("comment {idx} doesn't exist"))?;
            json.print(comment)
        }
        ViewCommand::Files => {
            let files = api
                .repo_get_pull_request_files(
                    repo.owner(),
                    repo.name(),
                    number,
                    RepoGetPullRequestFilesQuery::default(),
                )
                .all()
                .await?;
            json.print(&files)
        }
        ViewCommand::Commits { .. } => {
            let query = RepoGetPullRequestCommitsQuery {
                files: Some(false),
                ..Default::default()
            };
            let commits = api
                .repo_get_pull_request_commits(repo.owner(), repo.name(), number, query)
                .all()
                .await?;
            json.print(&commits)
        }
        ViewCommand::Diff { .. } => ftl_bail!("msg-json-diff"),
    }
}

async fn view_pr_labels(repo: &RepoName, api: &Forgejo, pr: Option<i64>) -> eyre::Result<()> {
    let pr = try_get_pr(repo, api, pr).await?;
    let labels = pr.labels.as_deref().unwrap_or_default();
    crate::render_label_list(labels)?;
    Ok(())
}

async fn view_pr_status(
    repo: &RepoName,
    api: &Forgejo,
    id: Option<i64>,
    wait: bool,
    json: &JsonArgs,
) -> eyre::Result<()> {
    if json.enabled() {
        let mut wait_duration = 5.0;
        let mut pr_status = get_pr_status(repo, api, id).await?;
        while wait && !pr_status.finished() {
            tokio::time::sleep(std::time::Duration::from_secs_f64(wait_duration)).await;
            wait_duration *= 1.5;
            pr_status = get_pr_status(repo, api, id).await?;
        }
        return json.print(&pr_status.to_json()?);
    }
    if wait {
        let SpecialRender { fancy, .. } = *crate::special_render();
        let mut wait_duration = 5.0;
        let mut prev_statuses_len = 0;
        let pr_status = loop {
            let pr_status = get_pr_status(repo, api, id).await?;
            if fancy {
                if prev_statuses_len > 0 {
                    println!("\x1b[{prev_statuses_len}A");
                }
                print_pr_status(&pr_status)?;
            } else {
                print!(".");
                std::io::stdout().flush()?;
            }
            if pr_status.finished() {
                break pr_status;
            }
            if let PrStatus::Open {
                commit_statuses, ..
            } = &pr_status
            {
                prev_statuses_len = commit_statuses.len() + 2;
            }
            tokio::time::sleep(std::time::Duration::from_secs_f64(wait_duration)).await;
            wait_duration *= 1.5;
        };
        if !fancy {
            print_pr_status(&pr_status)?;
        }
    } else {
        let pr_status = get_pr_status(repo, api, id).await?;
        print_pr_status(&pr_status)?;
    }
    Ok(())
}

enum PrStatus {
    Merged {
        pr: forgejo_api::structs::PullRequest,
    },
    Open {
        pr: forgejo_api::structs::PullRequest,
        commit_statuses: Vec<forgejo_api::structs::CommitStatus>,
    },
}

impl PrStatus {
    fn finished(&self) -> bool {
        match self {
            PrStatus::Merged { .. } => true,
            PrStatus::Open {
                commit_statuses, ..
            } => commit_statuses
                .iter()
                .flat_map(|x| x.status.as_ref())
                .all(|state| *state != forgejo_api::structs::CommitStatusState::Pending),
        }
    }

    fn to_json(&self) -> eyre::Result<serde_json::Value> {
        let (pr, statuses) = match self {
            PrStatus::Merged { pr } => (pr, &[][..]),
            PrStatus::Open {
                pr,
                commit_statuses,
            } => (pr, &commit_statuses[..]),
        };
        let mut pr_json = serde_json::to_value(pr)?;
        let state = match pr.state {
            _ if pr.merged == Some(true) => "merged",
            Some(StateType::Open) if pr.draft == Some(true) => "draft",
            Some(StateType::Open) if pr.title.as_deref().is_some_and(|s| s.starts_with("WIP:")) => {
                "draft"
            }
            Some(StateType::Open) => "open",
            Some(StateType::Closed) => "closed",
            None => "unknown",
        };
        Ok(serde_json::json!({
            "number": pr.number,
            "state": state,
            "mergeable": pr.mergeable,
            "head_sha": pr.head.as_ref().and_then(|x| x.sha.as_deref()),
            "merged_by": pr.merged_by.as_ref().and_then(|x| x.login.as_deref()),
            "merged_at": pr_json["merged_at"].take(),
            "statuses": statuses,
        }))
    }
}

async fn get_pr_status(repo: &RepoName, api: &Forgejo, id: Option<i64>) -> eyre::Result<PrStatus> {
    let pr = try_get_pr(repo, api, id).await?;
    if pr.merged.ok_or_eyre("pr merge status unknown")? {
        Ok(PrStatus::Merged { pr })
    } else {
        let sha = pr
            .head
            .as_ref()
            .and_then(|head| head.sha.as_deref())
            .ok_or_eyre("pr does not have head sha")?;
        let mut commit_statuses = api
            .repo_get_combined_status_by_ref(repo.owner(), repo.name(), sha)
            .stream_pages()
            .map_ok(|page| {
                futures::stream::iter(
                    page.statuses
                        .unwrap_or_default()
                        .into_iter()
                        .map(Result::<_, forgejo_api::ForgejoError>::Ok),
                )
            })
            .try_flatten()
            .try_collect::<Vec<_>>()
            .await?;
        commit_statuses.sort_by(|a, b| a.context.cmp(&b.context));

        Ok(PrStatus::Open {
            pr,
            commit_statuses,
        })
    }
}

fn print_pr_status(pr_status: &PrStatus) -> eyre::Result<()> {
    let SpecialRender { bullet, .. } = *crate::special_render();
    match pr_status {
        PrStatus::Merged { pr } => {
            let merged_by = pr
                .merged_by
                .as_ref()
                .ok_or_eyre("pr not merged by anyone")?;
            let merged_by = merged_by
                .login
                .as_deref()
                .ok_or_eyre("pr merger does not have login")?;
            let merged_at = pr.merged_at.ok_or_eyre("pr does not have merge date")?;
            ftl_println!(
                "msg-pr-status-merged",
                merged_by,
                merged_at = merged_at.ftl(),
            );
        }
        PrStatus::Open {
            pr,
            commit_statuses,
        } => {
            let state = pr.state.ok_or_eyre("pr does not have state")?;
            let is_draft = pr.title.as_deref().is_some_and(|s| s.starts_with("WIP:"));
            let state = match state {
                StateType::Open if is_draft => "draft",
                StateType::Open => "open",
                StateType::Closed => "closed",
            };
            let mergeable = pr.mergeable.ok_or_eyre("pr does not have mergeable")?;
            ftl_println!("msg-pr-status-header", state, mergeable = mergeable.ftl());

            use forgejo_api::structs::CommitStatusState;

            for status in commit_statuses {
                let state = status
                    .status
                    .as_ref()
                    .ok_or_eyre("status does not have status")?;
                let context = status
                    .context
                    .as_deref()
                    .ok_or_eyre("status does not have context")?;
                print!("{bullet} ");
                let state = match state {
                    CommitStatusState::Success => "success",
                    CommitStatusState::Pending => "pending",
                    CommitStatusState::Warning => "warning",
                    CommitStatusState::Failure => "failure",
                    CommitStatusState::Skipped => "skipped",
                    CommitStatusState::Error => "error",
                };
                ftl_println!("msg-pr-status-entry", state, context);
            }
        }
    }
    Ok(())
}

fn print_pr_review(review: &PullReview) -> eyre::Result<()> {
    let reviewer = review
        .user
        .as_ref()
        .and_then(|u| u.login.as_deref())
        .or_else(|| review.team.as_ref().and_then(|t| t.name.as_deref()))
        .unwrap_or("???");

    let review_type = match review.state.as_deref() {
        Some("APPROVED") => "approved",
        Some("REQUEST_CHANGES") => "changes-requested",
        Some("COMMENT") => "comment",
        Some("PENDING") => "pending",
        _ => "other",
    };

    let comments_count = review.comments_count.unwrap_or_default();
    let review_ts = review.updated_at.or(review.submitted_at);
    let state = if review.stale.unwrap_or(false) {
        "stale"
    } else if review.dismissed.unwrap_or(false) {
        "dismissed"
    } else {
        ""
    };

    ftl_println!(
        "msg-pr-review-list-review_header",
        review_type,
        reviewer,
        comments = comments_count,
        timestamp = review_ts.map(|ts| ts.ftl()),
        state,
    );

    if let Some(body) = &review.body
        && !body.trim().is_empty()
    {
        println!("{}", crate::markdown(body));
    }

    Ok(())
}

fn print_pr_reviews_comments(comments: &[PullReviewComment]) -> eyre::Result<()> {
    // Group comments by file and position:
    let comments_by_file = comments
        .iter()
        .map(|c| {
            (
                match (c.path.as_deref(), c.position) {
                    // If the comment is on a specific line in a specific file, group by that.
                    // Otherwise, group all comments with unknown position together.
                    (Some(path), position) => (
                        path,
                        position.unwrap_or(c.original_position.unwrap_or_default()),
                    ),
                    _ => ("???", 0),
                },
                c,
            )
        })
        .fold(BTreeMap::new(), |mut m, (k, v)| {
            m.entry(k).or_insert_with(Vec::new).push(v);
            m
        });

    for comment_group in comments_by_file {
        print_pr_reviews_comment(comment_group)?;
    }
    Ok(())
}

fn print_pr_reviews_comment(
    ((path, position), comments): ((&str, u64), Vec<&PullReviewComment>),
) -> eyre::Result<()> {
    let crate::SpecialRender {
        dark_grey, reset, ..
    } = crate::special_render();

    let mut first = true;

    for comment in comments {
        let body = comment.body.as_deref().unwrap_or("").trim();

        if body.is_empty() {
            continue;
        }

        // Only print the file and position for the first non-empty comment in a
        // group of comments on the same file and position.
        if first {
            first = false;
            println!();
            ftl_println!("msg-pr-review-list-comment_position", path, position);
            if let Some(diff_hunk) = &comment.diff_hunk {
                println!("{dark_grey}{diff_hunk}{reset}");
            }
        }

        let user = comment
            .user
            .as_ref()
            .and_then(|u| u.login.as_deref())
            .unwrap_or("???");

        let resolver = comment.resolver.as_ref().and_then(|u| u.login.as_deref());
        ftl_println!(
            "msg-pr-review-list-comment_header",
            commenter = user,
            resolver,
        );
        println!("{}", crate::markdown(body));
    }

    Ok(())
}

async fn edit_pr_labels(
    repo: &RepoName,
    api: &Forgejo,
    pr: Option<i64>,
    add: Vec<String>,
    rm: Vec<String>,
) -> eyre::Result<()> {
    let pr = try_get_pr(repo, api, pr).await?;
    let pr_number = pr.number.ok_or_eyre("pr does not have number")?;
    let repo = repo_name_from_pr(&pr)?;

    crate::edit_labels(&repo, api, pr_number, add, rm).await?;

    Ok(())
}

async fn edit_pr_milestone(
    repo: &RepoName,
    api: &Forgejo,
    pr: Option<i64>,
    milestone: Option<String>,
    unset: bool,
) -> eyre::Result<()> {
    match (milestone, unset) {
        (Some(_), true) | (None, false) => unreachable!(),
        (Some(milestone), false) => {
            let pr = try_get_pr(repo, api, pr).await?;
            let pr_number = pr.number.ok_or_eyre("pr does not have number")?;
            let repo = repo_name_from_pr(&pr)?;

            // TODO: it's possible to omit this ID resolution with more flexible API bindings, see
            // comments in milestones.rs
            let id = milestones::get_milestone_id(&repo, api, milestone).await?;

            api.repo_edit_pull_request(
                repo.owner(),
                repo.name(),
                pr_number,
                forgejo_api::structs::EditPullRequestOption {
                    allow_maintainer_edit: None,
                    assignee: None,
                    assignees: None,
                    base: None,
                    body: None,
                    due_date: None,
                    labels: None,
                    milestone: Some(id),
                    state: None,
                    title: None,
                    unset_due_date: None,
                },
            )
            .await?;
        }
        (None, true) => {
            let pr = try_get_pr(repo, api, pr).await?;
            let pr_number = pr.number.ok_or_eyre("pr does not have number")?;
            let repo = repo_name_from_pr(&pr)?;

            api.repo_edit_pull_request(
                repo.owner(),
                repo.name(),
                pr_number,
                forgejo_api::structs::EditPullRequestOption {
                    allow_maintainer_edit: None,
                    assignee: None,
                    assignees: None,
                    base: None,
                    body: None,
                    due_date: None,
                    labels: None,
                    milestone: Some(0), // id 0 unsets
                    state: None,
                    title: None,
                    unset_due_date: None,
                },
            )
            .await?;
        }
    }

    Ok(())
}

pub async fn get_template_file(
    repo: &RepoName,
    api: &Forgejo,
) -> eyre::Result<Option<(Vec<u8>, bool)>> {
    const FILES: [&str; 8] = [
        ".forgejo/pull_request_template",
        ".forgejo/PULL_REQUEST_TEMPLATE",
        ".gitea/pull_request_template",
        ".gitea/PULL_REQUEST_TEMPLATE",
        ".github/pull_request_template",
        ".github/PULL_REQUEST_TEMPLATE",
        "docs/pull_request_template",
        "docs/PULL_REQUEST_TEMPLATE",
    ];
    const EXTS: [&str; 3] = ["md", "yml", "yaml"];
    let query = forgejo_api::structs::RepoGetRawFileQuery { r#ref: None };
    for file in FILES {
        for ext in EXTS {
            let path = format!("{file}.{ext}");
            let file = api
                .repo_get_raw_file(repo.owner(), repo.name(), &path, query.clone())
                .await;
            match file {
                Ok(file) => {
                    let is_yaml = matches!(ext, "yml" | "yaml");
                    return Ok(Some((file.to_vec(), is_yaml)));
                }
                Err(forgejo_api::ForgejoError::ApiError(forgejo_api::ApiError {
                    kind: forgejo_api::ApiErrorKind::NotFound { .. },
                    ..
                })) => (),
                Err(e) => return Err(e.into()),
            }
        }
    }
    Ok(None)
}

#[allow(clippy::too_many_arguments)]
async fn create_pr(
    repo: &RepoName,
    api: &Forgejo,
    title: Option<String>,
    base: Option<String>,
    head: Option<String>,
    body: Option<String>,
    body_file: Option<PathBuf>,
    autofill: bool,
    web: bool,
    agit: bool,
    milestone: Option<String>,
    remote_name: Option<&str>,
) -> eyre::Result<()> {
    let mut repo_data = api.repo_get(repo.owner(), repo.name()).await?;

    let head_branch_name = match head {
        _ if agit => None,
        Some(head) => Some(head),
        None => {
            let local_repo = git2::Repository::discover(".")?;
            let config = local_repo.config()?;
            let head = local_repo.head()?;
            eyre::ensure!(
                head.is_branch(),
                "HEAD is not on branch, can't guess head branch"
            );

            let branch_shorthand = head
                .shorthand()
                .wrap_err("current branch does not have utf8 name")?;

            let remote_name = config.get_string(&format!("branch.{branch_shorthand}.remote"))?;
            let remote_url = crate::ssh_url_parse(
                local_repo
                    .find_remote(&remote_name)?
                    .url()
                    .wrap_err("remote does not have utf8 url")?,
            )?;
            let remote_host = crate::repo_url_host_name(&remote_url);

            let repo_http_host = crate::repo_url_host_name(
                repo_data
                    .clone_url
                    .as_ref()
                    .ok_or_eyre("repo does not have clone url")?,
            );
            let repo_ssh_host = crate::repo_url_host_name(
                repo_data
                    .ssh_url
                    .as_ref()
                    .ok_or_eyre("repo does not have ssh url")?,
            );

            ftl_ensure!(
                remote_host == repo_http_host || remote_host == repo_ssh_host,
                "msg-pr-create-cross_instance",
                base_instance = repo_http_host,
                head_instance = remote_host,
            );

            let remote_head_name =
                config.get_string(&format!("branch.{branch_shorthand}.merge"))?;
            Some(
                remote_head_name
                    .strip_prefix("refs/heads/")
                    .unwrap_or(&remote_head_name)
                    .to_owned(),
            )
        }
    };

    let (base, base_is_parent) = match base {
        Some(base) => match base.strip_prefix("^") {
            Some("") => (None, true),
            Some(stripped) => (Some(stripped.to_owned()), true),
            None => (Some(base), false),
        },
        None => (None, false),
    };

    let (repo_owner, repo_name, base_repo, head) = if base_is_parent {
        let parent_repo = *repo_data
            .parent
            .take()
            .ok_or_eyre("cannot create pull request upstream, there is no upstream")?;
        let parent_owner = parent_repo
            .owner
            .as_ref()
            .ok_or_eyre("parent has no owner")?
            .login
            .as_deref()
            .ok_or_eyre("parent owner has no login")?
            .to_owned();
        let parent_name = parent_repo
            .name
            .as_deref()
            .ok_or_eyre("parent has no name")?
            .to_owned();

        (
            parent_owner,
            parent_name,
            parent_repo,
            head_branch_name
                .as_ref()
                .map(|head| format!("{}:{}", repo.owner(), head)),
        )
    } else {
        (
            repo.owner().to_owned(),
            repo.name().to_owned(),
            repo_data,
            head_branch_name.clone(),
        )
    };

    let base = match base {
        Some(base) => base,
        None => base_repo
            .default_branch
            .as_deref()
            .ok_or_eyre("repo does not have default branch")?
            .to_owned(),
    };

    if web {
        // --web and --agit are mutually exclusive, so this shouldn't ever fail
        let head = head.unwrap();
        let mut pr_create_url = base_repo
            .html_url
            .clone()
            .ok_or_eyre("repo does not have html url")?;
        pr_create_url
            .path_segments_mut()
            .expect("invalid url")
            .extend(["compare", &format!("{base}...{head}")]);
        open::that_detached(pr_create_url.as_str()).wrap_err("Failed to open URL")?;
    } else {
        let body_from_file = match body_file {
            None => None,
            Some(ref path) => Some(crate::read_file_or_stdin(path).await?),
        };
        let body = body.or(body_from_file);
        match head.zip(head_branch_name) {
            Some((head, head_branch_name)) => {
                let milestone = match milestone {
                    Some(m) => Some(milestones::get_milestone_id(repo, api, m).await?),
                    None => None,
                };

                let base_opt = CreatePullRequestOption {
                    assignee: None,
                    assignees: None,
                    base: Some(base.to_owned()),
                    body: None,
                    due_date: None,
                    head: Some(head.clone()),
                    labels: None,
                    milestone,
                    title: None,
                };
                let opt = if let Some((template_file, is_yaml)) =
                    get_template_file(repo, api).await?
                {
                    let title = title.ok_or_eyre("title is required")?;
                    let (body, metadata) = crate::issues::template::generate_from_template(
                        body,
                        template_file,
                        is_yaml,
                    )
                    .await?;
                    CreatePullRequestOption {
                        body: Some(body),
                        labels: crate::issues::maybe_label_names_to_ids(repo, api, metadata.labels)
                            .await?,
                        title: Some(title),
                        ..base_opt
                    }
                } else {
                    let pr_compare = api
                        .repo_compare_diff(
                            &repo_owner,
                            &repo_name,
                            &format!("{base}...{head}"),
                            forgejo_api::structs::RepoCompareDiffQuery::default(),
                        )
                        .await?;
                    let commit_messages = pr_compare
                        .commits
                        .as_ref()
                        .ok_or_eyre("failed to get branch comparison")?
                        .iter()
                        .map(get_commit_msg)
                        .collect::<Result<Vec<_>, _>>()?;

                    let (guessed_title, guessed_body) = {
                        if commit_messages.len() == 1 {
                            let (commit_title, commit_body) = commit_messages[0];
                            (commit_title.to_owned(), commit_body.to_owned())
                        } else {
                            (
                                head_branch_name,
                                body_from_commit_messages(commit_messages.iter().copied()),
                            )
                        }
                    };
                    let title = match title {
                        Some(title) => title,
                        None if autofill => guessed_title,
                        None => eyre::bail!("title is required"),
                    };
                    let body = match body {
                        Some(body) => body,
                        None if autofill => guessed_body,
                        None => {
                            let mut body = guessed_body;
                            crate::editor(&mut body, Some("md")).await?;
                            body
                        }
                    };
                    CreatePullRequestOption {
                        body: Some(body),
                        title: Some(title),
                        ..base_opt
                    }
                };
                let pr = api
                    .repo_create_pull_request(&repo_owner, &repo_name, opt)
                    .await?;
                let number = pr
                    .number
                    .ok_or_else(|| eyre::eyre!("pr does not have number"))?;
                let title = pr
                    .title
                    .as_ref()
                    .ok_or_else(|| eyre::eyre!("pr does not have title"))?;
                ftl_println!("msg-pr-create-success", number, title);
            }
            // no head means agit
            None => {
                let local_repo = git2::Repository::open(".")?;

                let mut git_config = local_repo.config()?;
                let clone_url = base_repo
                    .clone_url
                    .as_ref()
                    .ok_or_eyre("base repo does not have clone url")?;

                let git_auth = auth_git2::GitAuthenticator::new();

                let current_branch = git2::Branch::wrap(local_repo.head()?.resolve()?);
                let current_branch_name = current_branch
                    .name()?
                    .ok_or_eyre("branch name is not utf8")?;

                let mut remote = if let Some(remote_name) = remote_name {
                    local_repo.find_remote(remote_name)?
                } else {
                    local_repo.remote_anonymous(clone_url.as_str())?
                };

                let head_id = local_repo.head()?.peel_to_commit()?.id();

                let mut fetch_options = git2::FetchOptions::new();
                let mut remote_callbacks = git2::RemoteCallbacks::new();
                remote_callbacks.credentials(git_auth.credentials(&git_config));
                fetch_options.remote_callbacks(remote_callbacks);
                remote.fetch(&[&base], Some(&mut fetch_options), None)?;
                drop(fetch_options);
                let base_id = local_repo
                    .find_reference("FETCH_HEAD")?
                    .peel_to_commit()?
                    .id();

                let merge_base = local_repo.merge_base(base_id, head_id)?;
                let mut revwalk = local_repo.revwalk()?;
                revwalk.push_head()?;
                revwalk.hide(merge_base)?;
                revwalk.set_sorting(
                    git2::Sort::TOPOLOGICAL | git2::Sort::TIME | git2::Sort::REVERSE,
                )?;

                let mut commit_messages = Vec::new();
                for id in revwalk {
                    let commit = local_repo.find_commit(id?)?;
                    let title = String::from_utf8_lossy(
                        commit
                            .summary_bytes()
                            .ok_or_eyre("invalid commit message summary")?,
                    );
                    let body = String::from_utf8_lossy(commit.body_bytes().unwrap_or_default());
                    commit_messages.push((title.into_owned(), body.into_owned()));
                }

                let (title, body) =
                    if let Some((template_file, is_yaml)) = get_template_file(repo, api).await? {
                        let title = title.ok_or_eyre("title is required")?;
                        let (body, _) = crate::issues::template::generate_from_template(
                            body,
                            template_file,
                            is_yaml,
                        )
                        .await?;
                        (title, body)
                    } else {
                        let (guessed_title, guessed_body) = {
                            if commit_messages.len() == 1 {
                                commit_messages.remove(0)
                            } else {
                                let iter = commit_messages.iter().map(|(t, b)| (&**t, &**b));
                                let body = body_from_commit_messages(iter);
                                (current_branch_name.to_owned(), body)
                            }
                        };
                        let title = match title {
                            Some(title) => title,
                            None if autofill => guessed_title,
                            None => eyre::bail!("title is required"),
                        };
                        let body = match body {
                            Some(body) => body,
                            None if autofill => guessed_body,
                            None => {
                                let mut body = guessed_body;
                                crate::editor(&mut body, Some("md")).await?;
                                body
                            }
                        };
                        (title, body)
                    };

                let mut push_options = git2::PushOptions::new();

                let mut remote_callbacks = git2::RemoteCallbacks::new();
                remote_callbacks.credentials(git_auth.credentials(&git_config));
                push_options.remote_callbacks(remote_callbacks);

                push_options.remote_push_options(&[
                    &format!("topic={current_branch_name}"),
                    &format!("title={title}"),
                    &format!("description={body}"),
                ]);
                remote.push(&[&format!("HEAD:refs/for/{base}")], Some(&mut push_options))?;

                // needed so the mutable reference later is valid
                drop(push_options);

                ftl_println!("msg-pr-create-agit_success", title);

                let merge_setting_name = format!("branch.{current_branch_name}.merge");
                let remote_setting_name = format!("branch.{current_branch_name}.remote");
                let cfg_push_default = git_config.get_string("push.default").ok();
                let cfg_branch_merge = git_config.get_string(&merge_setting_name).ok();
                let cfg_branch_remote = git_config.get_string(&remote_setting_name).ok();

                let topic_setting = format!("refs/for/{base}/{current_branch_name}");

                let default_is_upstream = cfg_push_default.is_some_and(|s| s == "upstream");
                let branch_merge_is_agit = cfg_branch_merge.is_some_and(|s| s == topic_setting);
                let branch_remote_is_agit = cfg_branch_remote.is_some_and(|s| s == topic_setting);
                if !default_is_upstream || !branch_merge_is_agit || !branch_remote_is_agit {
                    loop {
                        let response = crate::ftl_prompt!("msg-pr-create-agit_push_cfg_prompt")?;
                        #[allow(clippy::wildcard_in_or_patterns)]
                        match response {
                            Some("yes") => {
                                let remote = remote_name.unwrap_or(clone_url.as_str());
                                git_config.set_str("push.default", "upstream")?;
                                git_config.set_str(&merge_setting_name, &topic_setting)?;
                                git_config.set_str(&remote_setting_name, remote)?;
                                ftl_println!("msg-pr-create-agit_force_push_warning");
                                break;
                            }
                            Some("help") => {
                                ftl_println!("msg-pr-create-agit_push_cfg_warning");
                                println!("  push.default = upstream");
                                println!("  branch.{current_branch_name}.merge = {topic_setting}");
                            }
                            Some("no") | _ => break,
                        }
                    }
                }
            }
        }
    }

    Ok(())
}

fn get_commit_msg(commit: &forgejo_api::structs::Commit) -> eyre::Result<(&str, &str)> {
    let commit = commit.commit.as_ref().ok_or_eyre("missing commit info")?;
    let commit_message = commit
        .message
        .as_deref()
        .ok_or_eyre("commit does not have message")?;
    let (commit_title, commit_body) = commit_message
        .split_once('\n')
        .unwrap_or((commit_message, ""));
    Ok((commit_title, commit_body.trim_start_matches(['\n', '\r'])))
}

fn body_from_commit_messages<'s>(msgs: impl Iterator<Item = (&'s str, &'s str)>) -> String {
    let mut body = String::new();
    for (commit_title, commit_body) in msgs {
        body.push_str(commit_title);
        body.push('\n');
        for (i, line) in commit_body.lines().enumerate() {
            if i == 0 {
                body.push_str(": ");
            } else {
                body.push_str("  ");
            }
            body.push_str(line);
            body.push('\n');
        }
        body.push('\n');
    }
    body
}

async fn merge_pr(
    repo: &RepoName,
    api: &Forgejo,
    pr: Option<i64>,
    method: Option<MergeMethod>,
    delete: bool,
    title: Option<String>,
    message: Option<Option<String>>,
) -> eyre::Result<()> {
    let repo_info = api.repo_get(repo.owner(), repo.name()).await?;

    let pr_info = try_get_pr(repo, api, pr).await?;
    let repo = repo_name_from_pr(&pr_info)?;
    let pr_html_url = pr_info
        .html_url
        .as_ref()
        .ok_or_eyre("pr does not have url")?;

    let default_merge = repo_info
        .default_merge_style
        .map(|x| x.into())
        .unwrap_or(forgejo_api::structs::MergePullRequestOptionDo::Merge);
    let merge_style = method.map(|x| x.into()).unwrap_or(default_merge);

    use forgejo_api::structs::MergePullRequestOptionDo::*;
    if title.is_some() {
        match merge_style {
            Rebase => eyre::bail!("rebase does not support commit title"),
            FastForwardOnly => eyre::bail!("ff-only does not support commit title"),
            ManuallyMerged => eyre::bail!("manually merged does not support commit title"),
            _ => (),
        }
    }
    let default_message = || {
        ftl_format!(
            "msg-pr-merge-default_message",
            pr_url = pr_html_url.as_str(),
        )
        .into_owned()
    };
    let message = match message {
        Some(Some(s)) => s,
        Some(None) => {
            let mut body = default_message();
            crate::editor(&mut body, Some("md")).await?;
            body
        }
        None => default_message(),
    };

    let request = MergePullRequestOption {
        r#do: merge_style,
        merge_commit_id: None,
        merge_message_field: Some(message),
        merge_title_field: title,
        delete_branch_after_merge: Some(delete),
        force_merge: None,
        head_commit_id: None,
        merge_when_checks_succeed: None,
    };
    let number = pr_info.number.ok_or_eyre("pr does not have number")?;
    api.repo_merge_pull_request(repo.owner(), repo.name(), number, request)
        .await?;

    let title = pr_info
        .title
        .as_deref()
        .ok_or_eyre("pr does not have title")?;
    let pr_base = pr_info.base.as_ref().ok_or_eyre("pr does not have base")?;
    let base_branch = pr_base
        .label
        .as_ref()
        .ok_or_eyre("base does not have label")?;
    ftl_println!("msg-pr-merge-success", number, title, base_branch);
    Ok(())
}

async fn checkout_pr(
    repo: &RepoName,
    api: &Forgejo,
    pr: PrNumber,
    branch_name: Option<String>,
    ssh: bool,
    identity_file: Option<PathBuf>,
) -> eyre::Result<()> {
    let local_repo = git2::Repository::discover(".").unwrap();

    let mut options = git2::StatusOptions::new();
    options.include_ignored(false);
    let has_no_uncommitted = local_repo.statuses(Some(&mut options)).unwrap().is_empty();
    ftl_ensure!(has_no_uncommitted, "msg-pr-checkout-dirty");

    let remote_repo = match pr {
        PrNumber::Parent(_) => {
            let mut this_repo = api.repo_get(repo.owner(), repo.name()).await?;
            let name = this_repo.full_name.as_deref().unwrap_or("???/???");
            *this_repo
                .parent
                .take()
                .ok_or_else(|| ftl_eyre!("msg-pr-checkout-not_fork", repo = name))?
        }
        PrNumber::This(_) => api.repo_get(repo.owner(), repo.name()).await?,
    };

    let (repo_owner, repo_name) = repo_name_from_repo(&remote_repo)?;

    let pull_data = api
        .repo_get_pull_request(repo_owner, repo_name, pr.number())
        .await?;

    let url = crate::repo::git_url(&remote_repo, ssh)?;
    let url_host = url.host_str().ok_or_eyre("url has no host")?;
    let mut remote = local_repo.remote_anonymous(url.as_str())?;
    let branch_name =
        branch_name.unwrap_or_else(|| format!("pr-{}-{}-{}", url_host, repo_owner, pr.number(),));

    let mut auth = auth_git2::GitAuthenticator::new();
    if let Some(id) = identity_file {
        auth = auth.add_ssh_key_from_file(id, None);
    } else if url.scheme() == "ssh" {
        auth = crate::repo::load_ssh_keys(auth, url_host);
    }

    auth.fetch(
        &local_repo,
        &mut remote,
        &[&format!("pull/{}/head", pr.number())],
        None,
    )?;

    let reference = local_repo.find_reference("FETCH_HEAD")?.resolve()?;
    let commit = reference.peel_to_commit()?;

    let mut branch_is_new = true;
    let branch =
        if let Ok(mut branch) = local_repo.find_branch(&branch_name, git2::BranchType::Local) {
            branch_is_new = false;
            branch
                .get_mut()
                .set_target(commit.id(), "update pr branch")?;
            branch
        } else {
            local_repo.branch(&branch_name, &commit, false)?
        };
    let branch_ref = branch.get().name().wrap_err("branch does not have name")?;

    local_repo.set_head(branch_ref)?;
    local_repo
        // for some reason, `.force()` is required to make it actually update
        // file contents. thank you git2 examples for noticing this too, I would
        // have pulled out so much hair figuring this out myself.
        .checkout_head(Some(git2::build::CheckoutBuilder::default().force()))
        .unwrap();

    let title = pull_data.title.as_deref().ok_or_eyre("pr has no title")?;
    ftl_println!(
        "msg-pr-checkout-success",
        number = pr.number(),
        title,
        new_branch = branch_is_new.ftl(),
        branch_name,
    );

    Ok(())
}

#[allow(clippy::too_many_arguments)]
async fn view_prs(
    repo: &RepoName,
    api: &Forgejo,
    json: &JsonArgs,
    query_str: Option<String>,
    labels: Option<String>,
    creator: Option<String>,
    assignee: Option<String>,
    state: Option<crate::issues::State>,
    page: Option<NonZeroU32>,
    milestones: Option<String>,
) -> eyre::Result<()> {
    let labels = labels
        .map(|s| s.split(',').map(|s| s.to_string()).collect::<Vec<_>>())
        .unwrap_or_default();
    let query = forgejo_api::structs::IssueListIssuesQuery {
        q: query_str,
        labels: Some(labels.join(",")),
        created_by: creator,
        assigned_by: assignee,
        state: state.map(|s| s.into()),
        r#type: Some(forgejo_api::structs::IssueListIssuesQueryType::Pulls),
        milestones,
        since: None,
        before: None,
        mentioned_by: None,
        sort: None,
    };
    if json.enabled() {
        let prs = match page {
            Some(page) => {
                api.issue_list_issues(repo.owner(), repo.name(), query)
                    .page_size(SEARCH_PAGE_SIZE)
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
        return json.print(&prs);
    }
    let prs = if let Some(page) = page {
        let page = page.get();
        let (header, prs) = api
            .issue_list_issues(repo.owner(), repo.name(), query)
            .page_size(SEARCH_PAGE_SIZE)
            .page(page)
            .await?;

        let total_pages = header
            .count()
            .ok_or_eyre("expected header to return a number")?
            .div_ceil(SEARCH_PAGE_SIZE as usize);

        ftl_println!(
            "msg-pr-search-page-total",
            page,
            total_pages,
            pull_requests = prs.len(),
        );

        prs
    } else {
        let prs = api
            .issue_list_issues(repo.owner(), repo.name(), query)
            .all()
            .await?;
        ftl_println!(
            "msg-pr-search-page-total",
            page = 1,
            total_pages = 1,
            pull_requests = prs.len()
        );
        prs
    };

    for pr in prs {
        let number = pr
            .number
            .ok_or_else(|| eyre::eyre!("pr does not have number"))?;
        let title = pr
            .title
            .as_ref()
            .ok_or_else(|| eyre::eyre!("pr does not have title"))?;
        let user = pr
            .user
            .as_ref()
            .ok_or_else(|| eyre::eyre!("pr does not have creator"))?;
        let author = user
            .login
            .as_ref()
            .ok_or_else(|| eyre::eyre!("user does not have login"))?;
        ftl_println!("msg-pr-search-entry", number, title, author);
    }
    Ok(())
}

async fn view_diff(
    repo: &RepoName,
    api: &Forgejo,
    pr: Option<i64>,
    patch: bool,
    editor: bool,
) -> eyre::Result<()> {
    let pr = try_get_pr(repo, api, pr).await?;
    let pr_number = pr.number.ok_or_eyre("pr does not have number")?;
    let repo = repo_name_from_pr(&pr)?;
    let diff_type = if patch { "patch" } else { "diff" };
    let diff = api
        .repo_download_pull_diff_or_patch(
            repo.owner(),
            repo.name(),
            pr_number,
            diff_type,
            forgejo_api::structs::RepoDownloadPullDiffOrPatchQuery::default(),
        )
        .await?;
    if editor {
        let mut view = diff.clone();
        crate::editor(&mut view, Some(diff_type)).await?;
        if view != diff {
            ftl_eprintln!("msg-pr-view-diff-volatile");
        }
    } else {
        println!("{diff}");
    }
    Ok(())
}

async fn view_pr_files(repo: &RepoName, api: &Forgejo, pr: Option<i64>) -> eyre::Result<()> {
    let pr = try_get_pr(repo, api, pr).await?;
    let pr_number = pr.number.ok_or_eyre("pr does not have number")?;
    let repo = repo_name_from_pr(&pr)?;
    let crate::SpecialRender {
        bright_red,
        bright_green,
        reset,
        ..
    } = crate::special_render();

    let files = api
        .repo_get_pull_request_files(
            repo.owner(),
            repo.name(),
            pr_number,
            RepoGetPullRequestFilesQuery::default(),
        )
        .all()
        .await?;
    let max_additions = files
        .iter()
        .map(|x| x.additions.unwrap_or_default())
        .max()
        .unwrap_or_default();
    let max_deletions = files
        .iter()
        .map(|x| x.deletions.unwrap_or_default())
        .max()
        .unwrap_or_default();

    let additions_width = max_additions.checked_ilog10().unwrap_or_default() as usize + 1;
    let deletions_width = max_deletions.checked_ilog10().unwrap_or_default() as usize + 1;

    for file in files {
        let name = file.filename.as_deref().unwrap_or("???");
        let additions = file.additions.unwrap_or_default();
        let deletions = file.deletions.unwrap_or_default();
        println!(
            "{bright_green}+{additions:<additions_width$} {bright_red}-{deletions:<deletions_width$}{reset} {name}"
        );
    }
    Ok(())
}

async fn view_pr_commits(
    repo: &RepoName,
    api: &Forgejo,
    pr: Option<i64>,
    oneline: bool,
) -> eyre::Result<()> {
    let pr = try_get_pr(repo, api, pr).await?;
    let pr_number = pr.number.ok_or_eyre("pr does not have number")?;
    let repo = repo_name_from_pr(&pr)?;
    let query = RepoGetPullRequestCommitsQuery {
        files: Some(false),
        ..Default::default()
    };
    let commits = api
        .repo_get_pull_request_commits(repo.owner(), repo.name(), pr_number, query)
        .all()
        .await?;

    let max_additions = commits
        .iter()
        .filter_map(|x| x.stats.as_ref())
        .map(|x| x.additions.unwrap_or_default())
        .max()
        .unwrap_or_default();
    let max_deletions = commits
        .iter()
        .filter_map(|x| x.stats.as_ref())
        .map(|x| x.deletions.unwrap_or_default())
        .max()
        .unwrap_or_default();

    let additions_width = max_additions.checked_ilog10().unwrap_or_default() as usize + 1;
    let deletions_width = max_deletions.checked_ilog10().unwrap_or_default() as usize + 1;

    let crate::SpecialRender {
        bright_red,
        bright_green,
        yellow,
        reset,
        ..
    } = crate::special_render();
    for commit in commits {
        let repo_commit = commit
            .commit
            .as_ref()
            .ok_or_eyre("commit does not have commit?")?;

        let message = repo_commit.message.as_deref().unwrap_or("[no msg]");
        let name = message.lines().next().unwrap_or(message);

        let sha = commit
            .sha
            .as_deref()
            .ok_or_eyre("commit does not have sha")?;
        let short_sha = &sha[..7];

        let stats = commit
            .stats
            .as_ref()
            .ok_or_eyre("commit does not have stats")?;
        let additions = stats.additions.unwrap_or_default();
        let deletions = stats.deletions.unwrap_or_default();

        if oneline {
            println!(
                "{yellow}{short_sha} {bright_green}+{additions:<additions_width$} {bright_red}-{deletions:<deletions_width$}{reset} {name}"
            );
        } else {
            let author = repo_commit
                .author
                .as_ref()
                .ok_or_eyre("commit has no author")?;
            let author_name = author.name.as_deref().ok_or_eyre("author has no name")?;
            let author_email = author.email.as_deref().ok_or_eyre("author has no email")?;
            let date = commit
                .created
                .as_ref()
                .ok_or_eyre("commit as no creation date")?;

            println!(
                "{yellow}commit {sha}{reset} ({bright_green}+{additions}{reset}, {bright_red}-{deletions}{reset})"
            );
            println!("Author: {author_name} <{author_email}>");
            print!("Date:   ");
            let format = time::macros::format_description!(
                "[weekday repr:short] [month repr:short] [day] [hour repr:24]:[minute]:[second] [year] [offset_hour sign:mandatory][offset_minute]"
            );
            date.format_into(&mut std::io::stdout().lock(), format)?;
            println!();
            println!();
            for line in message.lines() {
                println!("    {line}");
            }
            println!();
        }
    }
    Ok(())
}

pub async fn view_pr_reviews(
    repo: &RepoName,
    api: &Forgejo,
    pr: Option<i64>,
    comments: bool,
    include_stale: bool,
) -> eyre::Result<()> {
    let pr = try_get_pr(repo, api, pr).await?;
    let pr_number = pr.number.ok_or_eyre("pr does not have number")?;
    let repo = repo_name_from_pr(&pr)?;
    let reviews = api
        .repo_list_pull_reviews(repo.owner(), repo.name(), pr_number)
        .all()
        .await?;

    if reviews.is_empty() {
        ftl_println!("msg-pr-review-list-none");
        return Ok(());
    }

    let mut first = false;

    for review in &reviews {
        // skip request review reviews, since they are usually not relevant
        if (!include_stale && (review.stale.unwrap_or(false) || review.dismissed.unwrap_or(false)))
            || (review.state.as_deref() == Some("REQUEST_REVIEW"))
        {
            continue;
        }
        if !first {
            first = true;
        } else {
            println!();
        }
        print_pr_review(review)?;
        if comments {
            let review_id = match review.id {
                Some(id) => id,
                None => return Ok(()),
            };
            let review_comments = api
                .repo_get_pull_review_comments(repo.owner(), repo.name(), pr_number, review_id)
                .await?;
            print_pr_reviews_comments(&review_comments)?;
        }
    }

    // if first is still false, that means all reviews were stale or dismissed and nothing was printed.
    if !first {
        ftl_println!("msg-pr-review-list-only_stale");
    }

    Ok(())
}

async fn request_pr_review(
    repo: &RepoName,
    api: &Forgejo,
    pr: Option<i64>,
    reviewers: Option<Vec<String>>,
    team_reviewers: Option<Vec<String>>,
) -> eyre::Result<()> {
    let pr = try_get_pr(repo, api, pr).await?;
    let pr_number = pr.number.ok_or_eyre("pr does not have number")?;
    let repo = repo_name_from_pr(&pr)?;

    api.repo_create_pull_review_requests(
        repo.owner(),
        repo.name(),
        pr_number,
        PullReviewRequestOptions {
            reviewers,
            team_reviewers,
        },
    )
    .await?;

    ftl_println!("msg-pr-review-request-success", number = pr_number);

    Ok(())
}

pub async fn browse_pr(repo: &RepoName, api: &Forgejo, id: i64) -> eyre::Result<()> {
    let pr = api
        .repo_get_pull_request(repo.owner(), repo.name(), id)
        .await?;
    let html_url = pr
        .html_url
        .as_ref()
        .ok_or_else(|| eyre::eyre!("pr does not have html_url"))?;
    open::that_detached(html_url.as_str()).wrap_err("Failed to open URL")?;
    Ok(())
}

async fn try_get_pr_number(
    repo: &RepoName,
    api: &Forgejo,
    number: Option<i64>,
) -> eyre::Result<(RepoName, i64)> {
    let pr = match number {
        Some(number) => (repo.clone(), number),
        None => {
            let pr = guess_pr(repo, api)
                .await
                .wrap_err_with(|| ftl_format!("msg-pr-couldnt_guess"))?;
            let number = pr.number.ok_or_eyre("pr does not have number")?;
            let repo = repo_name_from_pr(&pr)?;
            (repo, number)
        }
    };
    Ok(pr)
}

async fn try_get_pr(
    repo: &RepoName,
    api: &Forgejo,
    number: Option<i64>,
) -> eyre::Result<forgejo_api::structs::PullRequest> {
    let pr = match number {
        Some(number) => {
            api.repo_get_pull_request(repo.owner(), repo.name(), number)
                .await?
        }
        None => guess_pr(repo, api)
            .await
            .wrap_err_with(|| ftl_format!("msg-pr-couldnt_guess"))?,
    };
    Ok(pr)
}

async fn guess_pr(
    repo: &RepoName,
    api: &Forgejo,
) -> eyre::Result<forgejo_api::structs::PullRequest> {
    let local_repo = git2::Repository::discover(".")?;
    let head = local_repo.head()?;
    eyre::ensure!(head.is_branch(), "head is not on branch");
    let local_branch = git2::Branch::wrap(head);
    let local_branch_name = local_branch.name()?.ok_or_eyre("branch name is not utf8")?;
    let config = local_repo.config()?;
    let remote_head_name = config.get_string(&format!("branch.{local_branch_name}.merge"))?;

    let maybe_agit = remote_head_name
        .strip_prefix("refs/for/")
        .and_then(|s| s.split_once("/"));

    if let Some((base, head)) = maybe_agit {
        let username = api
            .user_get_current()
            .await?
            .login
            .ok_or_eyre("user does not have username")?
            .to_lowercase();
        let head = format!("{username}/{head}");
        return Ok(api
            .repo_get_pull_request_by_base_head(repo.owner(), repo.name(), base, &head)
            .await?);
    } else if let Some(remote_head_short) = remote_head_name.strip_prefix("refs/heads/") {
        let this_repo = api.repo_get(repo.owner(), repo.name()).await?;

        // check for PRs on the main branch first
        let base = this_repo
            .default_branch
            .as_deref()
            .ok_or_eyre("repo does not have default branch")?;
        if let Ok(pr) = api
            .repo_get_pull_request_by_base_head(repo.owner(), repo.name(), base, remote_head_short)
            .await
        {
            return Ok(pr);
        }

        let this_full_name = this_repo
            .full_name
            .as_deref()
            .ok_or_eyre("repo does not have full name")?;
        let parent_remote_head_name = format!("{this_full_name}:{remote_head_short}");

        if let Some(parent) = this_repo.parent.as_deref() {
            let (parent_owner, parent_name) = repo_name_from_repo(parent)?;
            let parent_base = this_repo
                .default_branch
                .as_deref()
                .ok_or_eyre("repo does not have default branch")?;
            if let Ok(pr) = api
                .repo_get_pull_request_by_base_head(
                    parent_owner,
                    parent_name,
                    parent_base,
                    &parent_remote_head_name,
                )
                .await
            {
                return Ok(pr);
            }
        }

        // then iterate all branches
        if let Some(pr) =
            find_pr_from_branch(repo.owner(), repo.name(), api, remote_head_short).await?
        {
            return Ok(pr);
        }

        if let Some(parent) = this_repo.parent.as_deref() {
            let (parent_owner, parent_name) = repo_name_from_repo(parent)?;

            if let Some(pr) =
                find_pr_from_branch(parent_owner, parent_name, api, &parent_remote_head_name)
                    .await?
            {
                return Ok(pr);
            }
        }
    }

    ftl_bail!("msg-pr-not_found");
}

async fn find_pr_from_branch(
    repo_owner: &str,
    repo_name: &str,
    api: &Forgejo,
    head: &str,
) -> eyre::Result<Option<forgejo_api::structs::PullRequest>> {
    api.repo_list_branches(repo_owner, repo_name)
        .stream()
        .map_err(|e| e.into())
        .try_filter_map(|branch| check_branch_pair(repo_owner, repo_name, api, branch, head))
        .boxed_local()
        .try_next()
        .await
}

async fn check_branch_pair(
    repo_owner: &str,
    repo_name: &str,
    api: &Forgejo,
    base: forgejo_api::structs::Branch,
    head: &str,
) -> eyre::Result<Option<forgejo_api::structs::PullRequest>> {
    let base_name = base
        .name
        .as_deref()
        .ok_or_eyre("remote branch does not have name")?;
    match api
        .repo_get_pull_request_by_base_head(repo_owner, repo_name, base_name, head)
        .await
    {
        Ok(pr) => Ok(Some(pr)),
        Err(_) => Ok(None),
    }
}

fn repo_name_from_repo(repo: &forgejo_api::structs::Repository) -> eyre::Result<(&str, &str)> {
    let owner = repo
        .owner
        .as_ref()
        .ok_or_eyre("repo does not have owner")?
        .login
        .as_deref()
        .ok_or_eyre("repo owner does not have name")?;
    let name = repo.name.as_deref().ok_or_eyre("repo does not have name")?;
    Ok((owner, name))
}

fn repo_name_from_pr(pr: &forgejo_api::structs::PullRequest) -> eyre::Result<RepoName> {
    let base_branch = pr.base.as_ref().ok_or_eyre("pr does not have base")?;
    let repo = base_branch
        .repo
        .as_ref()
        .ok_or_eyre("branch does not have repo")?;
    let (owner, name) = repo_name_from_repo(repo)?;
    let repo_name = RepoName::new(owner.to_owned(), name.to_owned());
    Ok(repo_name)
}

//async fn guess_pr(
//    repo: &RepoName,
//    api: &Forgejo,
//) -> eyre::Result<forgejo_api::structs::PullRequest> {
//    let local_repo = git2::Repository::open(".")?;
//    let head_id = local_repo.head()?.peel_to_commit()?.id();
//    let sha = oid_to_string(head_id);
//    let pr = api
//        .repo_get_commit_pull_request(repo.owner(), repo.name(), &sha)
//        .await?;
//    Ok(pr)
//}
//
//fn oid_to_string(oid: git2::Oid) -> String {
//    let mut s = String::with_capacity(40);
//    for byte in oid.as_bytes() {
//        s.push(
//            char::from_digit((byte & 0xF) as u32, 16).expect("every nibble is a valid hex digit"),
//        );
//        s.push(
//            char::from_digit(((byte >> 4) & 0xF) as u32, 16)
//                .expect("every nibble is a valid hex digit"),
//        );
//    }
//    s
//}

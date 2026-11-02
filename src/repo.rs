use std::{io::Write, path::PathBuf, str::FromStr};

use base64ct::Encoding;
use clap::{Args, Subcommand};
use eyre::{Context, OptionExt, Result, eyre};
use forgejo_api::{
    ApiError, ApiErrorKind, Forgejo, ForgejoError,
    structs::{CreateRepoOption, Repository},
};
use url::Url;

use crate::{
    DisplayOptional, SpecialRender, ftl_bail, ftl_eprintln, ftl_eyre, ftl_format, ftl_print,
    ftl_println, ftl_write, h, lh,
};

pub struct RepoInfo {
    url: Url,
    name: Option<RepoName>,
    remote_name: Option<String>,
}

impl RepoInfo {
    pub fn get_current(
        host: Option<&str>,
        repo: Option<&RepoArg>,
        remote: Option<&str>,
        keys: &crate::keys::KeyInfo,
    ) -> eyre::Result<Self> {
        // l = domain/owner/name
        // s = owner/name
        // x = is present
        // i = found locally by git
        //
        // | repo | host | remote | ans-host | ans-repo |
        // |------|------|--------|----------|----------|
        // | l    | x    | x      | repo     | repo     |
        // | l    | x    | i      | repo     | repo     |
        // | l    | x    |        | repo     | repo     |
        // | l    |      | x      | repo     | repo     |
        // | l    |      | i      | repo     | repo     |
        // | l    |      |        | repo     | repo     |
        // | s    | x    | x      | host     | repo     |
        // | s    | x    | i      | host     | repo     |
        // | s    | x    |        | host     | repo     |
        // | s    |      | x      | remote   | repo     |
        // | s    |      | i      | remote   | repo     |
        // | s    |      |        | err      | repo     |
        // |      | x    | x      | remote   | remote   |
        // |      | x    | i      | host     | ?remote  |
        // |      | x    |        | host     | none     |
        // |      |      | x      | remote   | remote   |
        // |      |      | i      | remote   | remote   |
        // |      |      |        | err      | remote   |

        let mut repo_url: Option<Url> = None;
        let mut repo_name: Option<RepoName> = None;

        if let Some(repo) = repo {
            if let Some(host) = &repo.host {
                repo_url = Url::parse(host)
                    .ok()
                    .filter(|x| !x.cannot_be_a_base())
                    .or_else(|| Url::parse(&format!("https://{host}/")).ok())
                    .map(|url| keys.deref_alias(url))
            }
            repo_name = Some(RepoName {
                owner: repo.owner.clone(),
                name: repo.name.clone(),
            });
        }

        let repo_url = repo_url;
        let repo_name = repo_name;

        let host_url = host.and_then(|host| {
            Url::parse(host)
                .ok()
                .filter(|x| !x.cannot_be_a_base())
                .or_else(|| Url::parse(&format!("https://{host}/")).ok())
                .map(|url| keys.deref_alias(url))
        });

        let mut final_remote_name = None;

        let (remote_url, remote_repo_name) = {
            let mut out = (None, None);
            if let Ok(local_repo) = git2::Repository::discover(".") {
                let mut name = remote.map(|s| s.to_owned());

                // if there's only one remote, use that
                if name.is_none() {
                    let all_remotes = local_repo.remotes()?;
                    if all_remotes.len() == 1
                        && let Ok(Some(remote_name)) = all_remotes.get(0)
                    {
                        name = Some(remote_name.to_owned());
                    }
                }

                // if the current branch is tracking a remote branch, use that remote
                if name.is_none() {
                    let head = local_repo.head()?;
                    let branch_name = head.name().wrap_err("branch name not UTF-8")?;

                    if let Ok(remote_name) = local_repo.branch_upstream_remote(branch_name) {
                        let remote_name_s = remote_name.as_str().wrap_err("remote name invalid")?;

                        if let Some(host_url) = &host_url {
                            let remote = local_repo.find_remote(remote_name_s)?;
                            let url_s = std::str::from_utf8(remote.url_bytes())?;
                            let url = crate::ssh_url_parse(url_s)?;
                            let (url, _) = url_strip_repo_name(url)?;
                            let url = keys.deref_alias(url);

                            if crate::host_name(&url) == crate::host_name(host_url) {
                                name = Some(remote_name_s.to_owned());
                            }
                        } else {
                            name = Some(remote_name_s.to_owned());
                        }
                    }
                }

                // if there's a remote whose host url matches the one
                // specified with `--host`, use that
                //
                // This is different than using `--host` itself, since this
                // will include the repo name, which `--host` can't do.
                if name.is_none()
                    && let Some(host_url) = &host_url
                {
                    let all_remotes = local_repo.remotes()?;
                    for remote_name in all_remotes.iter() {
                        let Ok(Some(remote_name)) = remote_name else {
                            continue;
                        };
                        let remote = local_repo.find_remote(remote_name)?;

                        if let Ok(url) = remote.url() {
                            let url = crate::ssh_url_parse(url)?;
                            let (url, _) = url_strip_repo_name(url)?;
                            let url = keys.deref_alias(url);
                            if crate::host_name(&url) == crate::host_name(host_url)
                                && url.path() == host_url.path()
                            {
                                name = Some(remote_name.to_owned());
                                break;
                            }
                        }
                    }
                }

                if let Some(name) = name
                    && let Ok(remote) = local_repo.find_remote(&name)
                {
                    let url_s = std::str::from_utf8(remote.url_bytes())?;
                    let url = crate::ssh_url_parse(url_s)?;
                    let (url, repo_name) = url_strip_repo_name(url)?;
                    let url = keys.deref_alias(url);

                    out = (Some(url), Some(repo_name));

                    final_remote_name = Some(name);
                }
            } else {
                eyre::ensure!(remote.is_none(), "remote specified but no git repo found");
            }
            out
        };

        let same_instance = |a: &Option<Url>, b: &Option<Url>| {
            let a = a.as_ref().map(crate::host_name);
            let b = b.as_ref().map(crate::host_name);
            a == b
        };

        let (url, name) = if repo_url.is_some() {
            (repo_url, repo_name)
        } else if repo_name.is_some() {
            (host_url.or(remote_url), repo_name)
        } else if remote.is_some() || host_url.is_none() || same_instance(&remote_url, &host_url) {
            (remote_url, remote_repo_name)
        } else {
            (host_url, None)
        };

        let url = url.or_else(fallback_host).map(|url| {
            let mut url = match url.scheme() {
                "http" | "https" => url,
                _ => {
                    let mut url =
                        url::Url::parse(&format!("https{}", &url[url::Position::AfterScheme..]))
                            .expect("should always be valid");
                    // remove the port if the remote url is not for http or https
                    url.set_port(None).expect("shouldn't fail");
                    url
                }
            };
            url.set_username("").expect("shouldn't fail");
            url
        });

        let info = match (url, name) {
            (Some(url), name) => RepoInfo {
                url,
                name,
                remote_name: final_remote_name,
            },
            (None, Some(_)) => ftl_bail!("msg-repo-no_host_given"),
            (None, None) => ftl_bail!("msg-repo-no_info_given"),
        };

        Ok(info)
    }

    pub fn name(&self) -> Option<&RepoName> {
        self.name.as_ref()
    }

    pub fn host_url(&self) -> &Url {
        &self.url
    }

    pub fn remote_name(&self) -> Option<&str> {
        self.remote_name.as_deref()
    }
}

fn fallback_host() -> Option<Url> {
    // FJ_FALLBACK_HOST is fj's name for it.
    let envvar = std::env::var_os("FORGE_HOST").or_else(|| std::env::var_os("FJ_FALLBACK_HOST"));
    if let Some(envvar) = envvar {
        let out = envvar.to_str().and_then(|x| x.parse::<Url>().ok());
        if out.is_none() {
            ftl_eprintln!("msg-repo-fallback_host-invalid_url");
        }
        out
    } else {
        None
    }
}

pub fn url_strip_repo_name(mut url: Url) -> eyre::Result<(Url, RepoName)> {
    let mut iter = url
        .path_segments()
        .ok_or_eyre("repo url cannot be a base")?
        .rev();

    let name = iter.next().ok_or_eyre("repo url too short")?;
    let name = name.strip_suffix(".git").unwrap_or(name).to_owned();

    let owner = iter.next().ok_or_eyre("repo url too short")?.to_owned();

    // Remove the username and repo name from the url
    url.path_segments_mut()
        .map_err(|_| eyre!("repo url cannot be a base"))?
        .pop()
        .pop();

    Ok((url, RepoName { owner, name }))
}

#[derive(Clone, Debug)]
pub struct RepoName {
    owner: String,
    name: String,
}

impl RepoName {
    pub fn new(owner: String, name: String) -> Self {
        Self { owner, name }
    }
    pub fn owner(&self) -> &str {
        &self.owner
    }

    pub fn name(&self) -> &str {
        &self.name
    }
}

#[derive(Debug, Clone)]
pub struct RepoArg {
    host: Option<String>,
    owner: String,
    name: String,
}

impl RepoArg {
    pub fn owner(&self) -> &str {
        &self.owner
    }

    pub fn name(&self) -> &str {
        &self.name
    }

    pub fn host(&self) -> Option<&str> {
        self.host.as_deref()
    }
}

impl std::fmt::Display for RepoArg {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match &self.host {
            Some(host) => write!(f, "{host}/{}/{}", self.owner, self.name),
            None => write!(f, "{}/{}", self.owner, self.name),
        }
    }
}

impl FromStr for RepoArg {
    type Err = RepoArgError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (head, name) = s.rsplit_once("/").ok_or(RepoArgError::NoOwner)?;
        let name = name.strip_suffix(".git").unwrap_or(name);
        let (host, owner) = match head.rsplit_once("/") {
            Some((host, owner)) => (Some(host), owner),
            None => (None, head),
        };
        Ok(Self {
            host: host.map(|s| s.to_owned()),
            owner: owner.to_owned(),
            name: name.to_owned(),
        })
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RepoArgError {
    NoOwner,
}

impl std::error::Error for RepoArgError {}

impl std::fmt::Display for RepoArgError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            RepoArgError::NoOwner => {
                ftl_write!(f, "msg-repo-arg_no_owner");
                Ok(())
            }
        }
    }
}

#[derive(clap::ValueEnum, Clone, Copy, Debug)]
pub enum ObjectFormat {
    Sha1,
    Sha256,
}

impl From<ObjectFormat> for forgejo_api::structs::ObjectFormatName {
    fn from(value: ObjectFormat) -> Self {
        match value {
            ObjectFormat::Sha1 => forgejo_api::structs::ObjectFormatName::Sha1,
            ObjectFormat::Sha256 => forgejo_api::structs::ObjectFormatName::Sha256,
        }
    }
}

#[derive(Args, Clone, Debug)]
pub struct RepoCreateArgs {
    pub repo: String,

    // flags
    #[clap(long, short)]
    pub description: Option<String>,

    #[clap(long, short = 'P')]
    pub private: bool,

    #[clap(help = h!("arg-repo-create-remote"))]
    #[clap(long, short)]
    pub remote: Option<String>,

    #[clap(help = h!("arg-repo-create-push"), long_help = lh!("arg-repo-create-push"))]
    #[clap(long, short)]
    pub push: bool,

    #[clap(help = h!("arg-repo-create-ssh"))]
    #[clap(long, short = 'S')]
    pub ssh: Option<Option<bool>>,

    #[clap(help = h!("arg-repo-create-format"))]
    #[clap(long)]
    #[cfg(feature = "unstable-sha256")]
    pub format: Option<ObjectFormat>,
}

#[derive(Subcommand, Clone, Debug)]
pub enum RepoCommand {
    #[clap(about = h!("cmd-repo-create"))]
    Create {
        #[clap(flatten)]
        args: RepoCreateArgs,
    },
    #[clap(about = h!("cmd-repo-fork"))]
    Fork {
        repo: RepoArg,
        #[clap(long)]
        name: Option<String>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
    },
    #[clap(about = h!("cmd-repo-migrate"))]
    Migrate {
        #[clap(help = h!("arg-repo-migrate-repo"))]
        repo: String,

        #[clap(help = h!("arg-repo-migrate-repo"))]
        #[clap(id = "[OWNER]/NAME")]
        name: String,

        #[clap(help = h!("arg-repo-migrate-mirror"))]
        #[clap(long, short)]
        mirror: bool,

        #[clap(help = h!("arg-repo-migrate-private"))]
        #[clap(long, short)]
        private: bool,

        #[clap(help = h!("arg-repo-migrate-include"), long_help = lh!("arg-repo-migrate-include"))]
        #[clap(long, short)]
        include: Option<MigrateInclude>,

        #[clap(help = h!("arg-repo-migrate-lfs_endpoint"))]
        #[clap(long, short = 'L')]
        lfs_endpoint: Option<url::Url>,

        #[clap(help = h!("arg-repo-migrate-service"))]
        #[clap(long, short)]
        service: Option<MigrateService>,

        #[clap(help = h!("arg-repo-migrate-token"), long_help = lh!("arg-repo-migrate-token"))]
        #[clap(long, short)]
        token: bool,

        #[clap(help = h!("arg-repo-migrate-login"), long_help = lh!("arg-repo-migrate-login"))]
        #[clap(long, short)]
        login: bool,
    },
    #[clap(about = h!("cmd-repo-view"))]
    View {
        name: Option<RepoArg>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
    },
    #[clap(about = h!("cmd-repo-readme"))]
    Readme {
        name: Option<RepoArg>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
    },
    #[clap(about = h!("cmd-repo-clone"))]
    Clone {
        repo: RepoArg,

        path: Option<PathBuf>,

        #[clap(help = h!("arg-repo-clone-ssh"))]
        #[clap(long, short = 'S')]
        ssh: Option<Option<bool>>,

        #[clap(help = h!("arg-repo-clone-identity_file"))]
        #[clap(long, short = 'I')]
        identity_file: Option<PathBuf>,
    },
    #[clap(about = h!("cmd-repo-star"))]
    Star {
        repo: Option<RepoArg>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
    },
    #[clap(about = h!("cmd-repo-unstar"))]
    Unstar {
        repo: Option<RepoArg>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
    },
    #[clap(about = h!("cmd-repo-star_status"))]
    StarStatus {
        repo: Option<RepoArg>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
        #[clap(help = h!("arg-repo-star_status-list"))]
        #[clap(long, conflicts_with("repo"))]
        list: bool,
    },
    #[clap(about = h!("cmd-repo-watch"))]
    Watch {
        repo: Option<RepoArg>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
    },
    #[clap(about = h!("cmd-repo-unwatch"))]
    Unwatch {
        repo: Option<RepoArg>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
    },
    #[clap(about = h!("cmd-repo-watch_status"))]
    WatchStatus {
        repo: Option<RepoArg>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
        #[clap(help = h!("arg-repo-watch_status-list"))]
        #[clap(long, conflicts_with("repo"))]
        list: bool,
    },
    #[clap(about = h!("cmd-repo-delete"), long_about = lh!("cmd-repo-delete"))]
    Delete { repo: RepoArg },
    #[clap(about = h!("cmd-repo-browse"))]
    Browse {
        name: Option<RepoArg>,
        #[clap(long, short = 'R')]
        remote: Option<String>,
    },

    #[clap(about = h!("cmd-repo-labels"))]
    #[clap(alias = "label")]
    Labels {
        repo: Option<RepoArg>,

        #[clap(subcommand)]
        cmd: LabelsSubcommand,
    },

    #[clap(about = h!("cmd-repo-edit"))]
    Edit {
        repo: Option<RepoArg>,

        #[clap(help = h!("arg-repo-edit-archived"))]
        #[clap(short, long)]
        archived: Option<bool>,

        #[clap(help = h!("arg-repo-edit-default_branch"))]
        #[clap(long)]
        default_branch: Option<String>,

        #[clap(help = h!("arg-repo-edit-description"))]
        #[clap(short, long)]
        description: Option<String>,

        #[clap(help = h!("arg-repo-edit-enable_prune"))]
        #[clap(long)]
        enable_prune: Option<bool>,

        #[clap(help = h!("arg-repo-edit-mirror_interval"))]
        #[clap(long)]
        mirror_interval: Option<String>,

        #[clap(help = h!("arg-repo-edit-name"))]
        #[clap(long)]
        name: Option<String>,

        #[clap(help = h!("arg-repo-edit-private"))]
        #[clap(short, long)]
        private: Option<bool>,

        #[clap(help = h!("arg-repo-edit-template"))]
        #[clap(short, long)]
        template: Option<bool>,

        #[clap(help = h!("arg-repo-edit-website"))]
        #[clap(short, long)]
        website: Option<String>,

        #[clap(help = h!("arg-repo-edit-avatar"))]
        #[clap(short = 'A', long)]
        avatar: Option<PathBuf>,

        #[clap(help = h!("arg-repo-edit-unset_avatar"))]
        #[clap(short, long, conflicts_with = "avatar")]
        unset_avatar: bool,
    },

    #[clap(about = h!("cmd-repo-units"))]
    #[clap(alias = "unit")]
    Units {
        repo: Option<RepoArg>,

        #[clap(subcommand)]
        cmd: UnitsSubcommand,
    },
}

// TODO: EditRepoOption should probably implement Default upstream.
const NOOP_EDIT_REPO_OPTION: forgejo_api::structs::EditRepoOption =
    forgejo_api::structs::EditRepoOption {
        allow_fast_forward_only_merge: None,
        allow_manual_merge: None,
        allow_merge_commits: None,
        allow_rebase: None,
        allow_rebase_explicit: None,
        allow_rebase_update: None,
        allow_squash_merge: None,
        archived: None,
        autodetect_manual_merge: None,
        default_allow_maintainer_edit: None,
        default_branch: None,
        default_delete_branch_after_merge: None,
        default_merge_style: None,
        default_update_style: None,
        description: None,
        enable_prune: None,
        external_tracker: None,
        external_wiki: None,
        globally_editable_wiki: None,
        has_actions: None,
        has_issues: None,
        has_packages: None,
        has_projects: None,
        has_pull_requests: None,
        has_releases: None,
        has_wiki: None,
        ignore_whitespace_conflicts: None,
        internal_tracker: None,
        mirror_interval: None,
        name: None,
        private: None,
        template: None,
        website: None,
        wiki_branch: None,
    };

impl RepoCommand {
    pub async fn run(self, keys: &mut crate::KeyInfo, host_name: Option<&str>) -> eyre::Result<()> {
        match self {
            RepoCommand::Create {
                args:
                    RepoCreateArgs {
                        repo,

                        description,
                        private,
                        remote,
                        push,
                        ssh,
                        #[cfg(feature = "unstable-sha256")]
                        format,
                    },
            } => {
                let host = RepoInfo::get_current(host_name, None, None, keys)?;
                let api = keys.get_api(host.host_url()).await?;
                let url_host = crate::host_name(host.host_url());
                let ssh = ssh
                    .unwrap_or_else(|| Some(keys.default_ssh.contains(url_host)))
                    .unwrap_or(true);
                create_repo(
                    &api,
                    None,
                    repo,
                    description,
                    private,
                    remote,
                    push,
                    ssh,
                    #[cfg(feature = "unstable-sha256")]
                    format,
                )
                .await?;
            }
            RepoCommand::Fork { repo, name, remote } => {
                fn strip(s: &str) -> &str {
                    let no_scheme = s
                        .strip_prefix("https://")
                        .or_else(|| s.strip_prefix("http://"))
                        .unwrap_or(s);

                    no_scheme.strip_suffix("/").unwrap_or(no_scheme)
                }
                if let (Some(a), Some(b)) = (repo.host.as_deref(), host_name)
                    && strip(a) != strip(b)
                {
                    ftl_bail!("msg-repo-fork-conflicting_hosts", host_a = a, host_b = b);
                }

                let repo_info =
                    RepoInfo::get_current(host_name, Some(&repo), remote.as_deref(), keys)?;
                let api = keys.get_api(repo_info.host_url()).await?;
                let repo = repo_info
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                fork_repo(&api, repo, name).await?
            }
            RepoCommand::Migrate {
                repo,
                name,
                mirror,
                private,
                include,
                lfs_endpoint,
                service,
                token,
                login,
            } => {
                let current_repo = RepoInfo::get_current(host_name, None, None, keys)?;
                let api = keys.get_api(current_repo.host_url()).await?;
                migrate_repo(
                    &api,
                    repo,
                    name,
                    mirror,
                    private,
                    include,
                    lfs_endpoint,
                    service,
                    token,
                    login,
                )
                .await?
            }
            RepoCommand::View { name, remote } => {
                let repo =
                    RepoInfo::get_current(host_name, name.as_ref(), remote.as_deref(), keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let repo = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                view_repo(&api, repo).await?
            }
            RepoCommand::Readme { name, remote } => {
                let repo =
                    RepoInfo::get_current(host_name, name.as_ref(), remote.as_deref(), keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let repo = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                view_repo_readme(&api, repo).await?
            }
            RepoCommand::Clone {
                repo,
                path,
                ssh,
                identity_file: identity,
            } => {
                let repo = RepoInfo::get_current(host_name, Some(&repo), None, keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let name = repo.name().unwrap();
                let url_host = crate::host_name(repo.host_url());
                let ssh = ssh
                    .unwrap_or_else(|| Some(keys.default_ssh.contains(url_host)))
                    .unwrap_or(true);
                cmd_clone_repo(&api, name, path, ssh, identity).await?;
            }
            RepoCommand::Star { repo, remote } => {
                let repo =
                    RepoInfo::get_current(host_name, repo.as_ref(), remote.as_deref(), keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let name = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                let starred = check_repo_star_status(&api, name.owner(), name.name()).await?;
                if starred {
                    ftl_println!("msg-repo-star-already_starred");
                    return Ok(());
                }
                api.user_current_put_star(name.owner(), name.name()).await?;
                ftl_println!(
                    "msg-repo-star-success",
                    owner = name.owner(),
                    repo = name.name(),
                );
            }
            RepoCommand::Unstar { repo, remote } => {
                let repo =
                    RepoInfo::get_current(host_name, repo.as_ref(), remote.as_deref(), keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let name = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                let starred = check_repo_star_status(&api, name.owner(), name.name()).await?;
                if !starred {
                    ftl_println!("msg-repo-unstar-already_unstarred");
                    return Ok(());
                }
                api.user_current_delete_star(name.owner(), name.name())
                    .await?;
                ftl_println!(
                    "msg-repo-unstar-success",
                    owner = name.owner(),
                    repo = name.name(),
                );
            }
            RepoCommand::StarStatus { repo, remote, list } => {
                let repo =
                    RepoInfo::get_current(host_name, repo.as_ref(), remote.as_deref(), keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                if list {
                    let (_, starred_repos) = api.user_current_list_starred().await?;
                    print_starred(starred_repos.as_slice());
                    return Ok(());
                }
                let name = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                let starred = check_repo_star_status(&api, name.owner(), name.name()).await?;
                if starred {
                    ftl_println!(
                        "msg-repo-star_status-starred",
                        owner = name.owner(),
                        repo = name.name()
                    );
                } else {
                    ftl_println!(
                        "msg-repo-star_status-unstarred",
                        owner = name.owner(),
                        repo = name.name()
                    );
                }
            }
            RepoCommand::Watch { repo, remote } => {
                let repo =
                    RepoInfo::get_current(host_name, repo.as_ref(), remote.as_deref(), keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let name = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                let subscribed = check_repo_watch_status(&api, name.owner(), name.name()).await?;
                if subscribed {
                    ftl_println!("msg-repo-watch-already_subscribed");
                    return Ok(());
                }
                api.user_current_put_subscription(name.owner(), name.name())
                    .await?;
                ftl_println!(
                    "msg-repo-watch-success",
                    owner = name.owner(),
                    repo = name.name()
                );
            }
            RepoCommand::Unwatch { repo, remote } => {
                let repo =
                    RepoInfo::get_current(host_name, repo.as_ref(), remote.as_deref(), keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let name = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                let subscribed = check_repo_watch_status(&api, name.owner(), name.name()).await?;
                if !subscribed {
                    ftl_println!("msg-repo-unwatch-already_unsubscribed");
                    return Ok(());
                }
                api.user_current_delete_subscription(name.owner(), name.name())
                    .await?;
                ftl_println!(
                    "msg-repo-unwatch-success",
                    owner = name.owner(),
                    repo = name.name()
                );
            }
            RepoCommand::WatchStatus { repo, remote, list } => {
                let repo =
                    RepoInfo::get_current(host_name, repo.as_ref(), remote.as_deref(), keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                if list {
                    let (_, subscribed_repos) = api.user_current_list_subscriptions().await?;
                    print_subscriptions(subscribed_repos.as_slice());
                    return Ok(());
                }
                let name = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                let subscribed = check_repo_watch_status(&api, name.owner(), name.name()).await?;
                if subscribed {
                    ftl_println!(
                        "msg-repo-watch_status-subscribed",
                        owner = name.owner(),
                        repo = name.name()
                    );
                } else {
                    ftl_println!(
                        "msg-repo-watch_status-unsubscribed",
                        owner = name.owner(),
                        repo = name.name()
                    );
                }
            }
            RepoCommand::Delete { repo } => {
                let repo = RepoInfo::get_current(host_name, Some(&repo), None, keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let name = repo.name().unwrap();
                delete_repo(&api, name).await?;
            }
            RepoCommand::Browse { name, remote } => {
                let repo =
                    RepoInfo::get_current(host_name, name.as_ref(), remote.as_deref(), keys)?;
                let mut url = repo.host_url().clone();
                let repo = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                url.path_segments_mut()
                    .map_err(|_| eyre!("url invalid"))?
                    .extend([repo.owner(), repo.name()]);

                open::that_detached(url.as_str()).wrap_err("Failed to open URL")?;
            }
            RepoCommand::Labels {
                repo,
                cmd: LabelsSubcommand::View { archived },
            } => {
                let repo = RepoInfo::get_current(host_name, repo.as_ref(), None, keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let repo = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                list_repo_labels(&api, repo, archived).await?;
            }
            RepoCommand::Labels {
                repo,
                cmd:
                    LabelsSubcommand::Create {
                        name,
                        color,
                        description,
                        exclusive,
                        archived,
                    },
            } => {
                let repo = RepoInfo::get_current(host_name, repo.as_ref(), None, keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let repo = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;
                create_repo_label(&api, repo, name, color, description, exclusive, archived)
                    .await?;
            }
            RepoCommand::Labels {
                repo,
                cmd: LabelsSubcommand::Delete { id },
            } => {
                let repo = RepoInfo::get_current(host_name, repo.as_ref(), None, keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let repo = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;

                delete_repo_label(&api, repo, id).await?;
            }
            RepoCommand::Labels {
                repo,
                cmd:
                    LabelsSubcommand::Edit {
                        id,
                        name,
                        color,
                        description,
                        exclusive,
                        archived,
                    },
            } => {
                let repo = RepoInfo::get_current(host_name, repo.as_ref(), None, keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let repo = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;

                edit_repo_label(
                    &api,
                    repo,
                    id,
                    name,
                    color,
                    description,
                    exclusive,
                    archived,
                )
                .await?;
            }
            RepoCommand::Edit {
                repo,
                archived,
                default_branch,
                description,
                enable_prune,
                mirror_interval,
                name,
                private,
                template,
                website,
                avatar,
                unset_avatar,
            } => {
                let repo = RepoInfo::get_current(host_name, repo.as_ref(), None, keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let repo = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;

                let edit_opt = forgejo_api::structs::EditRepoOption {
                    archived,
                    default_branch,
                    description,
                    enable_prune,
                    mirror_interval,
                    name,
                    private,
                    template,
                    website,
                    ..NOOP_EDIT_REPO_OPTION
                };
                if edit_opt != NOOP_EDIT_REPO_OPTION {
                    api.repo_edit(repo.owner(), repo.name(), edit_opt).await?;
                }

                if let Some(avatar_path) = avatar {
                    let image = match tokio::fs::read(avatar_path).await {
                        Ok(image) => image,
                        Err(e) if e.kind() == std::io::ErrorKind::NotFound => Err(e)
                            .wrap_err_with(|| ftl_eyre!("msg-repo-edit-avatar_file_not_found"))?,
                        Err(e) => Err(e)?,
                    };

                    let image_base64 = base64ct::Base64::encode_string(&image);
                    let opt = forgejo_api::structs::UpdateRepoAvatarOption {
                        image: Some(image_base64),
                    };
                    api.repo_update_avatar(repo.owner(), repo.name(), opt)
                        .await?;
                } else if unset_avatar {
                    api.repo_delete_avatar(repo.owner(), repo.name()).await?;
                }
            }
            RepoCommand::Units { repo, cmd } => {
                let repo = RepoInfo::get_current(host_name, repo.as_ref(), None, keys)?;
                let api = keys.get_api(repo.host_url()).await?;
                let repo = repo
                    .name()
                    .ok_or_else(|| ftl_eyre!("msg-repo-name_needed"))?;

                let edit_option = match cmd {
                    UnitsSubcommand::Issues { enable } => forgejo_api::structs::EditRepoOption {
                        has_issues: enable,
                        ..NOOP_EDIT_REPO_OPTION
                    },
                    UnitsSubcommand::Prs {
                        enable,
                        allow_fast_forward_only_merge,
                        allow_manual_merge,
                        allow_merge_commits,
                        allow_rebase,
                        allow_rebase_explicit,
                        allow_rebase_update,
                        allow_squash_merge,
                        autodetect_manual_merge,
                        default_allow_maintainer_edit,
                        default_delete_branch_after_merge,
                        default_merge_style,
                        default_update_style,
                        ignore_whitespace_conflicts,
                    } => forgejo_api::structs::EditRepoOption {
                        has_pull_requests: enable,
                        allow_fast_forward_only_merge,
                        allow_manual_merge,
                        allow_merge_commits,
                        allow_rebase,
                        allow_rebase_explicit,
                        allow_rebase_update,
                        allow_squash_merge,
                        autodetect_manual_merge,
                        default_allow_maintainer_edit,
                        default_delete_branch_after_merge,
                        default_merge_style: default_merge_style
                            .map(DefaultMergeStyle::to_forgejo_api),
                        default_update_style: default_update_style
                            .map(DefaultUpdateStyle::to_forgejo_api)
                            .map(String::from),
                        ignore_whitespace_conflicts,
                        ..NOOP_EDIT_REPO_OPTION
                    },
                    UnitsSubcommand::Actions { enable } => forgejo_api::structs::EditRepoOption {
                        has_actions: enable,
                        ..NOOP_EDIT_REPO_OPTION
                    },
                    UnitsSubcommand::Wiki {
                        enable,
                        branch,
                        external_url: external_wiki,
                        globally_editable,
                    } => forgejo_api::structs::EditRepoOption {
                        has_wiki: enable,
                        wiki_branch: branch,
                        external_wiki: external_wiki.map(|url| {
                            forgejo_api::structs::ExternalWiki {
                                // Setting this to None always results in a server-side
                                // error.
                                // See: https://codeberg.org/Cyborus/forgejo-api/issues/143
                                external_wiki_url: Some(url),
                            }
                        }),
                        globally_editable_wiki: globally_editable,
                        ..NOOP_EDIT_REPO_OPTION
                    },
                    UnitsSubcommand::Packages { enable } => forgejo_api::structs::EditRepoOption {
                        has_packages: enable,
                        ..NOOP_EDIT_REPO_OPTION
                    },
                    UnitsSubcommand::Projects { enable } => forgejo_api::structs::EditRepoOption {
                        has_projects: enable,
                        ..NOOP_EDIT_REPO_OPTION
                    },
                    UnitsSubcommand::Releases { enable } => forgejo_api::structs::EditRepoOption {
                        has_releases: enable,
                        ..NOOP_EDIT_REPO_OPTION
                    },
                };

                api.repo_edit(repo.owner(), repo.name(), edit_option)
                    .await?;
            }
        };
        Ok(())
    }
}

#[derive(Subcommand, Clone, Debug)]
pub enum LabelsSubcommand {
    #[clap(about = h!("cmd-repo-labels-view"))]
    View {
        #[clap(help = h!("arg-repo-labels-view-archived"))]
        #[clap(short, long)]
        archived: bool,
    },

    #[clap(about = h!("cmd-repo-labels-create"))]
    Create {
        #[clap(help = h!("arg-repo-labels-create-name"))]
        name: String,

        #[clap(help = h!("arg-repo-labels-create-color"))]
        color: String,

        #[clap(help = h!("arg-repo-labels-create-description"))]
        #[clap(long, short)]
        description: Option<Option<String>>,

        #[clap(help = h!("arg-repo-labels-create-exclusive"))]
        #[clap(long, short)]
        exclusive: bool,

        #[clap(help = h!("arg-repo-labels-create-archived"))]
        #[clap(long, short)]
        archived: bool,
    },

    #[clap(about = h!("cmd-repo-labels-delete"))]
    Delete {
        #[clap(help = h!("arg-repo-labels-delete-id"))]
        id: String,
    },

    #[clap(about = h!("cmd-repo-labels-edit"))]
    Edit {
        #[clap(help = h!("arg-repo-labels-edit-id"))]
        id: String,

        #[clap(help = h!("arg-repo-labels-edit-name"))]
        #[clap(short, long)]
        name: Option<String>,

        #[clap(help = h!("arg-repo-labels-edit-color"))]
        #[clap(short, long)]
        color: Option<String>,

        #[clap(help = h!("arg-repo-labels-edit-description"))]
        #[clap(short, long)]
        description: Option<Option<String>>,

        #[clap(help = h!("arg-repo-labels-edit-exclusive"))]
        #[clap(short, long)]
        exclusive: Option<bool>,

        #[clap(help = h!("arg-repo-labels-edit-archived"))]
        #[clap(short, long)]
        archived: Option<bool>,
    },
}

#[derive(Subcommand, Clone, Debug)]
pub enum UnitsSubcommand {
    #[clap(about = h!("cmd-repo-units-issues"))]
    #[clap(alias = "issue")]
    Issues {
        #[clap(help = h!("arg-repo-units-issues-enable"))]
        #[clap(short, long)]
        enable: Option<bool>,
        // TODO: external_tracker, internal_tracker
        // These accept quite sophisticated data structures, not sure how to model those.
    },

    #[clap(about = h!("cmd-repo-units-prs"))]
    #[clap(alias = "pr")]
    Prs {
        #[clap(help = h!("arg-repo-units-prs-enable"))]
        #[clap(short, long)]
        enable: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-allow_fast_forward_only_merge"))]
        #[clap(long)]
        allow_fast_forward_only_merge: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-allow_manual_merge"))]
        #[clap(long)]
        allow_manual_merge: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-allow_merge_commits"))]
        #[clap(long)]
        allow_merge_commits: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-allow_rebase"))]
        #[clap(long)]
        allow_rebase: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-allow_rebase_explicit"))]
        #[clap(long)]
        allow_rebase_explicit: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-allow-rebase_update"))]
        #[clap(long)]
        allow_rebase_update: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-allow_squash_merge"))]
        #[clap(long)]
        allow_squash_merge: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-autodetect_manual_merge"))]
        #[clap(long)]
        autodetect_manual_merge: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-default_allow_maintainer_edit"))]
        #[clap(long)]
        default_allow_maintainer_edit: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-default_delete_branch_after_merge"))]
        #[clap(long)]
        default_delete_branch_after_merge: Option<bool>,

        #[clap(help = h!("arg-repo-units-prs-default_merge_style"))]
        #[clap(long)]
        default_merge_style: Option<DefaultMergeStyle>,

        #[clap(help = h!("arg-repo-units-prs-default_update_style"))]
        #[clap(long)]
        default_update_style: Option<DefaultUpdateStyle>,

        #[clap(help = h!("arg-repo-units-prs-ignore_whitespace_conflicts"))]
        #[clap(long)]
        ignore_whitespace_conflicts: Option<bool>,
    },

    #[clap(about = h!("cmd-repo-units-actions"))]
    Actions {
        #[clap(help = h!("arg-repo-units-actions-enable"))]
        #[clap(short, long)]
        enable: Option<bool>,
    },

    #[clap(about = h!("cmd-repo-units-wiki"))]
    Wiki {
        #[clap(help = h!("arg-repo-units-wiki-enable"))]
        #[clap(short, long)]
        enable: Option<bool>,

        #[clap(help = h!("arg-repo-units-wiki-branch"))]
        #[clap(long)]
        branch: Option<String>,

        #[clap(help = h!("arg-repo-units-wiki-external_url"), long_help = lh!("arg-repo-units-wiki-external_url"))]
        #[clap(long)]
        external_url: Option<Url>,

        #[clap(help = h!("arg-repo-units-wiki-globally_editable"))]
        #[clap(long)]
        globally_editable: Option<bool>,
    },

    #[clap(about = h!("cmd-repo-units-packages"))]
    #[clap(alias = "package")]
    Packages {
        #[clap(help = h!("arg-repo-units-packages-enable"))]
        #[clap(short, long)]
        enable: Option<bool>,
    },

    #[clap(about = h!("cmd-repo-units-projects"))]
    #[clap(alias = "project")]
    Projects {
        #[clap(help = h!("arg-repo-units-projects-enable"))]
        #[clap(short, long)]
        enable: Option<bool>,
    },

    #[clap(about = h!("cmd-repo-units-releases"))]
    #[clap(alias = "release")]
    Releases {
        #[clap(help = h!("arg-repo-units-releases-enable"))]
        #[clap(short, long)]
        enable: Option<bool>,
    },
}

#[derive(clap::ValueEnum, Copy, Clone, Debug)]
pub enum DefaultMergeStyle {
    Merge,
    Rebase,
    RebaseMerge,
    Squash,
    FastForwardOnly,
}

impl DefaultMergeStyle {
    fn to_forgejo_api(self) -> forgejo_api::structs::DefaultMergeStyle {
        match self {
            DefaultMergeStyle::Merge => forgejo_api::structs::DefaultMergeStyle::Merge,
            DefaultMergeStyle::Rebase => forgejo_api::structs::DefaultMergeStyle::Rebase,
            DefaultMergeStyle::RebaseMerge => forgejo_api::structs::DefaultMergeStyle::RebaseMerge,
            DefaultMergeStyle::Squash => forgejo_api::structs::DefaultMergeStyle::Squash,
            DefaultMergeStyle::FastForwardOnly => {
                forgejo_api::structs::DefaultMergeStyle::FastForwardOnly
            }
        }
    }
}

#[derive(clap::ValueEnum, Copy, Clone, Debug)]
pub enum DefaultUpdateStyle {
    Rebase,
    Merge,
}

impl DefaultUpdateStyle {
    fn to_forgejo_api(self) -> &'static str {
        match self {
            DefaultUpdateStyle::Rebase => "rebase",
            DefaultUpdateStyle::Merge => "merge",
        }
    }
}

async fn check_repo_watch_status(api: &Forgejo, owner: &str, repo: &str) -> eyre::Result<bool> {
    let response = api.user_current_check_subscription(owner, repo).await;
    match response {
        Ok(_) => Ok(true),
        Err(ForgejoError::ApiError(ApiError {
            message: _,
            kind: ApiErrorKind::NotFound { errors: _ },
        })) => Ok(false),
        Err(e) => Err(e.into()),
    }
}

async fn check_repo_star_status(api: &Forgejo, owner: &str, repo: &str) -> eyre::Result<bool> {
    let response = api.user_current_check_starring(owner, repo).await;
    match response {
        Ok(_) => Ok(true),
        Err(ForgejoError::ApiError(ApiError {
            message: _,
            kind: ApiErrorKind::NotFound { errors: _ },
        })) => match api.repo_get(owner, repo).await {
            Ok(_) => Ok(false),
            Err(ForgejoError::ApiError(ApiError {
                message: _,
                kind: ApiErrorKind::NotFound { errors: _ },
            })) => Err(ftl_eyre!("msg-repo_not_found")),
            Err(e) => Err(e.into()),
        },
        Err(e) => Err(e.into()),
    }
}

fn print_subscriptions(repos: &[Repository]) {
    ftl_println!("msg-repo-watch_status-list-header", count = repos.len());
    for repo in repos {
        let owner = repo
            .owner
            .as_ref()
            .and_then(|owner| owner.login.as_deref())
            .unwrap_or("<>");
        let name = repo.name.as_deref().unwrap_or("<>");
        ftl_println!(
            "msg-repo-watch_status-list-repo",
            owner = owner,
            repo = name
        );
    }
}

fn print_starred(repos: &[Repository]) {
    ftl_println!("msg-repo-star_status-list-header", count = repos.len());
    for repo in repos {
        let owner = repo
            .owner
            .as_ref()
            .and_then(|owner| owner.login.as_deref())
            .unwrap_or("<>");
        let name = repo.name.as_deref().unwrap_or("<>");
        ftl_println!("msg-repo-star_status-list-repo", owner, repo = name);
    }
}

#[allow(clippy::too_many_arguments)]
pub async fn create_repo(
    api: &Forgejo,
    org: Option<String>,
    repo: String,
    description: Option<String>,
    private: bool,
    remote: Option<String>,
    push: bool,
    ssh: bool,
    #[cfg(feature = "unstable-sha256")] format: Option<ObjectFormat>,
) -> eyre::Result<()> {
    if remote.is_some() || push {
        let repo = git2::Repository::discover(".")?;

        let upstream = remote.as_deref().unwrap_or("origin");
        if repo.find_remote(upstream).is_ok() {
            ftl_bail!("msg-repo-create-remote_exists", remote_name = upstream);
        }
    }
    let repo_spec = CreateRepoOption {
        auto_init: Some(false),
        default_branch: Some("main".into()),
        description,
        gitignores: None,
        issue_labels: None,
        license: None,
        name: repo,
        #[cfg(feature = "unstable-sha256")]
        object_format_name: format.map(|s| s.into()),
        #[cfg(not(feature = "unstable-sha256"))]
        object_format_name: None,
        private: Some(private),
        readme: Some(String::new()),
        template: Some(false),
        trust_model: Some(forgejo_api::structs::CreateRepoOptionTrustModel::Default),
    };
    let new_repo = if let Some(org) = org {
        api.create_org_repo(&org, repo_spec).await?
    } else {
        api.create_current_user_repo(repo_spec).await?
    };
    let html_url = new_repo
        .html_url
        .as_ref()
        .ok_or_else(|| eyre::eyre!("new_repo does not have html_url"))?;
    ftl_println!("msg-repo-create-success", url = html_url.as_str());

    if remote.is_some() || push {
        let repo = git2::Repository::discover(".")?;

        let upstream = remote.as_deref().unwrap_or("origin");
        let remote_url = git_url(&new_repo, ssh)?;
        let mut remote = repo.remote(upstream, remote_url.as_str())?;

        if push {
            let head = repo.head()?;
            if !head.is_branch() {
                ftl_bail!("msg-repo-create-detached_head");
            }
            let branch_shorthand = head
                .shorthand()
                .wrap_err_with(|| ftl_eyre!("msg-repo-create-branch_invalid_utf8"))?
                .to_owned();
            let branch_name = std::str::from_utf8(head.name_bytes())?.to_owned();

            let auth = auth_git2::GitAuthenticator::new();
            auth.push(&repo, &mut remote, &[&branch_name])?;
            auth.fetch(&repo, &mut remote, &[&branch_shorthand], None)?;

            let mut current_branch = git2::Branch::wrap(head);
            current_branch.set_upstream(Some(&format!("{upstream}/{branch_shorthand}")))?;
        }
    }

    Ok(())
}

async fn fork_repo(api: &Forgejo, repo: &RepoName, name: Option<String>) -> eyre::Result<()> {
    let opt = forgejo_api::structs::CreateForkOption {
        name,
        organization: None,
    };
    let new_fork = api.create_fork(repo.owner(), repo.name(), opt).await?;
    let fork_name = new_fork
        .full_name
        .as_deref()
        .ok_or_eyre("fork does not have name")?;
    ftl_println!(
        "msg-repo-fork-success",
        parent_owner = repo.owner(),
        parent_name = repo.name(),
        fork_name,
    );

    Ok(())
}

#[derive(Copy, Clone, Debug, PartialEq, Eq, clap::ValueEnum, Default)]
pub enum MigrateService {
    #[default]
    Git,
    Github,
    Gitlab,
    Forgejo,
    Gitea,
    Gogs,
    Onedev,
    Gitbucket,
    Codebase,
    Pagure,
    BitbucketDc,
}

impl FromStr for MigrateService {
    type Err = MigrateServiceParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "git" => Ok(Self::Git),
            "github" => Ok(Self::Github),
            "gitlab" => Ok(Self::Gitlab),
            "forgejo" => Ok(Self::Forgejo),
            "gitea" => Ok(Self::Gitea),
            "gogs" => Ok(Self::Gogs),
            "onedev" | "one-dev" => Ok(Self::Onedev),
            "gitbucket" | "git-bucket" => Ok(Self::Gitbucket),
            "codebase" => Ok(Self::Codebase),
            "pagure" => Ok(Self::Pagure),
            "bitbucket-dc" => Ok(Self::BitbucketDc),
            _ => Err(MigrateServiceParseError),
        }
    }
}

impl MigrateService {
    fn to_api_type(self) -> forgejo_api::structs::MigrateRepoOptionsService {
        use MigrateService as Cli;
        use forgejo_api::structs::MigrateRepoOptionsService as Api;
        match self {
            Cli::Git => Api::Git,
            Cli::Github => Api::Github,
            Cli::Gitlab => Api::Gitlab,
            Cli::Forgejo => Api::Forgejo,
            Cli::Gitea => Api::Gitea,
            Cli::Gogs => Api::Gogs,
            Cli::Onedev => Api::Onedev,
            Cli::Gitbucket => Api::Gitbucket,
            Cli::Codebase => Api::Codebase,
            Cli::Pagure => Api::Pagure,
            Cli::BitbucketDc => Api::Bitbucketdc,
        }
    }
}

#[derive(Clone, Debug)]
pub struct MigrateServiceParseError;

impl std::error::Error for MigrateServiceParseError {}

impl std::fmt::Display for MigrateServiceParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("unknown service")
    }
}

#[derive(Copy, Clone, Debug, PartialEq, Eq, Default)]
pub struct MigrateInclude {
    lfs: bool,
    wiki: bool,
    issues: bool,
    prs: bool,
    milestones: bool,
    labels: bool,
    releases: bool,
}

impl MigrateInclude {
    /// if the selection includes anything other than LFS (which is supported by base git)
    fn non_base_git(self) -> bool {
        self.wiki | self.issues | self.prs | self.milestones | self.labels | self.releases
    }
}

impl FromStr for MigrateInclude {
    type Err = MigrateIncludeParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if s == "all" {
            Ok(Self {
                lfs: true,
                wiki: true,
                issues: true,
                prs: true,
                milestones: true,
                labels: true,
                releases: true,
            })
        } else {
            let mut out = Self::default();
            for opt in s.split(",") {
                match opt {
                    "lfs" => out.lfs = true,
                    "wiki" => out.wiki = true,
                    "issues" => out.issues = true,
                    "prs" => out.prs = true,
                    "milestones" => out.milestones = true,
                    "labels" => out.labels = true,
                    "releases" => out.releases = true,
                    _ => return Err(MigrateIncludeParseError),
                }
            }
            Ok(out)
        }
    }
}

#[derive(Clone, Debug)]
pub struct MigrateIncludeParseError;

impl std::error::Error for MigrateIncludeParseError {}

impl std::fmt::Display for MigrateIncludeParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("unknown include option")
    }
}

#[allow(clippy::too_many_arguments)]
async fn migrate_repo(
    api: &Forgejo,
    mut repo: String,
    name: String,
    mirror: bool,
    private: bool,
    include: Option<MigrateInclude>,
    lfs_endpoint: Option<url::Url>,
    service: Option<MigrateService>,
    token: bool,
    login: bool,
) -> eyre::Result<()> {
    let include = include.unwrap_or_default();
    let service = service.unwrap_or_default();

    if service == MigrateService::Git && include.non_base_git() {
        ftl_bail!("msg-repo-migrate-git_only");
    }

    if repo.ends_with("/") {
        let _ = repo.pop();
    }
    if !repo.ends_with(".git") {
        repo.push_str(".git");
    }
    let clone_url =
        url::Url::parse(&repo).or_else(|_| url::Url::parse(&format!("https://{repo}")))?;

    let (username, password) = if login {
        let username = crate::ftl_readline!("msg-repo-migrate-username_prompt")
            .await?
            .trim()
            .to_owned();
        let password = crate::ftl_readline!("msg-repo-migrate-password_prompt")
            .await?
            .trim()
            .to_owned();
        (Some(username), Some(password))
    } else {
        (None, None)
    };

    let auth_token = if token {
        let auth_token = crate::ftl_readline!("msg-repo-migrate-token_prompt")
            .await?
            .trim()
            .to_owned();
        Some(auth_token.trim().to_owned())
    } else {
        None
    };

    let (owner, name) = name
        .rsplit_once("/")
        .map(|(o, n)| (Some(o.to_owned()), n.to_owned()))
        .unwrap_or((None, name));

    let migrate_options = forgejo_api::structs::MigrateRepoOptions {
        auth_password: password,
        auth_username: username,
        auth_token,
        clone_addr: clone_url.as_str().to_owned(),
        description: None,
        issues: Some(include.issues),
        labels: Some(include.labels),
        lfs: Some(include.lfs),
        lfs_endpoint: lfs_endpoint.map(|url| url.to_string()),
        milestones: Some(include.milestones),
        mirror: Some(mirror),
        mirror_interval: None,
        private: Some(private),
        pull_requests: Some(include.prs),
        releases: Some(include.releases),
        repo_name: name,
        repo_owner: owner,
        service: Some(service.to_api_type()),
        #[allow(deprecated)]
        uid: None,
        wiki: Some(include.wiki),
    };

    ftl_println!("msg-repo-migrate-migrating");
    let new_repo = api.repo_migrate(migrate_options).await?;
    let new_repo_url = new_repo
        .html_url
        .as_ref()
        .ok_or_eyre("new repo doesn't have url")?;
    ftl_println!("msg-repo-migrate-success", url = new_repo_url.as_str());

    Ok(())
}

async fn view_repo(api: &Forgejo, repo: &RepoName) -> eyre::Result<()> {
    let repo = api.repo_get(repo.owner(), repo.name()).await?;

    let SpecialRender {
        dash,
        body_prefix,
        dark_grey,
        reset,
        ..
    } = crate::special_render();
    ftl_println!(
        "msg-repo-view-name",
        repo_name = repo.full_name.as_deref().ok_or_eyre("no full name")?,
    );
    if let Some(parent) = repo.parent.as_ref() {
        ftl_println!(
            "msg-repo-view-is_fork",
            parent = parent.full_name.as_deref(),
        );
    }
    if repo.mirror == Some(true) {
        ftl_println!(
            "msg-repo-view-is_mirror",
            mirror_of = repo.original_url.as_ref().map(|url| url.as_str()),
        );
    };
    let desc = repo.description.as_deref().unwrap_or_default();
    // Don't use body::markdown, this is plain text.
    if !desc.is_empty() {
        if desc.lines().count() > 1 {
            println!();
        }
        for line in desc.lines() {
            println!("{dark_grey}{body_prefix}{reset} {line}");
        }
    }
    println!();

    archived_warning(&repo)?;

    let language = repo.language.as_deref().unwrap_or_default();
    if !language.is_empty() {
        ftl_println!("msg-repo-view-primary_language", language);
    }

    ftl_print!(
        "msg-repo-view-stars",
        stars = repo.stars_count.unwrap_or_default(),
    );
    print!(" {dash} ");
    ftl_print!(
        "msg-repo-view-watching",
        watching = repo.watchers_count.unwrap_or_default(),
    );
    print!(" {dash} ");
    ftl_print!(
        "msg-repo-view-forks",
        forks = repo.forks_count.unwrap_or_default(),
    );
    println!();

    let mut first = true;
    if repo.has_issues.unwrap_or_default() && repo.external_tracker.is_none() {
        ftl_print!(
            "msg-repo-view-issues",
            issues = repo.open_issues_count.unwrap_or_default(),
        );
        first = false;
    }
    if repo.has_pull_requests.unwrap_or_default() {
        if !first {
            print!(" {dash} ");
        }
        ftl_print!(
            "msg-repo-view-prs",
            pull_requests = repo.open_pr_counter.unwrap_or_default(),
        );
        first = false;
    }
    if repo.has_releases.unwrap_or_default() {
        if !first {
            print!(" {dash} ");
        }
        ftl_print!(
            "msg-repo-view-releases",
            releases = repo.release_counter.unwrap_or_default(),
        );
        first = false;
    }
    if !first {
        println!();
    }
    if let Some(external_tracker) = &repo.external_tracker
        && let Some(url) = &external_tracker.external_tracker_url
    {
        ftl_println!("msg-repo-view-external_tracker", url = url.as_str());
    }

    if let Some(url) = &repo.html_url {
        println!();
        ftl_println!("msg-repo-view-url", url = url.as_str());
    }

    Ok(())
}

pub fn archived_warning(repo: &forgejo_api::structs::Repository) -> eyre::Result<()> {
    let SpecialRender {
        bright_yellow,
        reset,
        ..
    } = crate::special_render();
    if repo.archived.unwrap_or_default() {
        let date_format = time::macros::format_description!("[month repr:long] [day], [year]");
        let archived_at = repo
            .archived_at
            .as_ref()
            .ok_or_eyre("archived_on not present")?;
        println!(
            "{bright_yellow}Repo archived since {}",
            archived_at.format(&date_format)?
        );
        println!("You may view this repo, but interactions are disabled{reset}");
        println!();
    }
    Ok(())
}

async fn view_repo_readme(api: &Forgejo, repo: &RepoName) -> eyre::Result<()> {
    let query = forgejo_api::structs::RepoGetContentsListQuery::default();
    let files = api
        .repo_get_contents_list(repo.owner(), repo.name(), query)
        .await?;

    let readme = files
        .iter()
        .filter(|file| file.r#type.as_deref().is_some_and(|t| t == "file"))
        .filter_map(|file| {
            file.name.as_deref().filter(|name| {
                name.split_once(".")
                    .map(|(s, _)| s)
                    .unwrap_or(name)
                    .eq_ignore_ascii_case("readme")
            })
        })
        .next()
        .ok_or_else(|| ftl_eyre!("msg-repo-readme-none"))?;
    let is_md = readme
        .rsplit_once(".")
        .is_some_and(|(_, s)| s.eq_ignore_ascii_case("md"));

    let query = forgejo_api::structs::RepoGetRawFileQuery::default();
    let body = api
        .repo_get_raw_file(repo.owner(), repo.name(), readme, query)
        .await?;
    let body = String::from_utf8_lossy(body.as_ref());

    if is_md {
        println!("{}", crate::markdown(&body));
    } else {
        println!("{}", crate::render_text(&body));
    }
    Ok(())
}

async fn cmd_clone_repo(
    api: &Forgejo,
    name: &RepoName,
    path: Option<std::path::PathBuf>,
    ssh: bool,
    identity_file: Option<std::path::PathBuf>,
) -> eyre::Result<()> {
    let repo_data = api.repo_get(name.owner(), name.name()).await?;
    let clone_url = git_url(&repo_data, ssh)?;

    let repo_name = repo_data
        .name
        .as_deref()
        .ok_or_eyre("repo does not have name")?;
    let repo_full_name = repo_data
        .full_name
        .as_deref()
        .ok_or_eyre("repo does not have full name")?;

    let path = path.unwrap_or_else(|| PathBuf::from(format!("./{repo_name}")));

    let local_repo = clone_repo(clone_url, &path, identity_file.as_deref())?;

    if let Some(parent) = repo_data.parent.as_deref() {
        local_repo.remote("upstream", git_url(parent, ssh)?.as_str())?;
    }

    ftl_println!(
        "msg-repo-clone-success",
        repo = repo_full_name,
        path = path.to_string_lossy(),
    );
    Ok(())
}

pub fn git_url(repo: &forgejo_api::structs::Repository, ssh: bool) -> eyre::Result<&Url> {
    if ssh {
        repo.ssh_url
            .as_ref()
            .ok_or_eyre("repo does not have ssh url")
    } else {
        repo.clone_url
            .as_ref()
            .ok_or_eyre("repo does not have clone url")
    }
}

pub fn clone_repo(
    url: &url::Url,
    path: &std::path::Path,
    identity_file: Option<&std::path::Path>,
) -> eyre::Result<git2::Repository> {
    let SpecialRender {
        fancy,
        hide_cursor,
        show_cursor,
        clear_line,
        ..
    } = *crate::special_render();

    let mut auth = auth_git2::GitAuthenticator::new();
    if let Some(id) = identity_file {
        auth = auth.add_ssh_key_from_file(id, None);
    } else if url.scheme() == "ssh" {
        // I find it surprising that auth_git2 just hardcodes what key files to look for instead of
        // looking in .ssh/config
        auth = load_ssh_keys(auth, url.host_str().ok_or_eyre("url does not have host")?);
    }

    let git_config = git2::Config::open_default()?;

    let mut options = git2::FetchOptions::new();
    let mut callbacks = git2::RemoteCallbacks::new();
    callbacks.credentials(auth.credentials(&git_config));

    if fancy {
        print!("{hide_cursor}");
        ftl_print!("msg-repo-clone-preparing");
        let _ = std::io::stdout().flush();

        callbacks.transfer_progress(|progress| {
            print!("{clear_line}\r");
            if progress.received_objects() == progress.total_objects() {
                if progress.indexed_deltas() == progress.total_deltas() {
                    ftl_print!("msg-repo-clone-finishing_up");
                } else {
                    let percent = 100.0 * (progress.indexed_deltas() as f64)
                        / (progress.total_deltas() as f64);
                    let percent = (percent * 100.0).floor() / 100.0;
                    ftl_print!("msg-repo-clone-resolving", percent);
                }
            } else {
                let bytes = progress.received_bytes();
                let percent = 100.0 * (progress.received_objects() as f64)
                    / (progress.total_objects() as f64);
                let (size, units) = match bytes {
                    0..=1023 => (bytes as f64, "b"),
                    1024..=1048575 => ((bytes as f64) / 1024.0, "kb"),
                    1048576..=1073741823 => ((bytes as f64) / 1048576.0, "mb"),
                    1073741824.. => ((bytes as f64) / 1073741824.0, "gb"),
                };
                let percent = (percent * 100.0).floor() / 100.0;
                let size = (size * 100.0).floor() / 100.0;
                ftl_print!("msg-repo-clone-downloading", percent, size, units);
            }
            let _ = std::io::stdout().flush();
            true
        });
    }
    options.remote_callbacks(callbacks);

    let local_repo = git2::build::RepoBuilder::new()
        .fetch_options(options)
        .clone(url.as_str(), path)?;
    if fancy {
        print!("{clear_line}{show_cursor}\r");
    }
    Ok(local_repo)
}

pub fn load_ssh_keys(
    mut auth: auth_git2::GitAuthenticator,
    host: &str,
) -> auth_git2::GitAuthenticator {
    if let Some(ssh_config) = crate::get_ssh_config() {
        let params = ssh_config.query(host);
        if let Some(identity_file) = params.identity_file.as_deref() {
            for path in identity_file {
                auth = auth.add_ssh_key_from_file(path, None);
            }
        }
    }

    auth
}

async fn delete_repo(api: &Forgejo, name: &RepoName) -> eyre::Result<()> {
    let confirmation = crate::ftl_prompt_bool!(
        default false; "msg-repo-delete-confirmation_prompt",
        owner = name.owner(),
        name = name.name(),
    )?;
    if confirmation {
        api.repo_delete(name.owner(), name.name()).await?;
        ftl_println!(
            "msg-repo-delete-success",
            owner = name.owner(),
            repo = name.name(),
        );
    } else {
        ftl_println!("msg-repo-delete-cancelled");
    }
    Ok(())
}

async fn list_repo_labels(api: &Forgejo, repo: &RepoName, archived: bool) -> eyre::Result<()> {
    let (_headers, labels) = api
        .issue_list_labels(repo.owner(), repo.name(), Default::default())
        .await?;

    for label in labels {
        if label.is_archived.unwrap_or_default() && !archived {
            continue;
        }

        let label_str = crate::render_label(&label)?;
        println!(
            "{label_str} {}{}\n  {}\n",
            DisplayOptional(label.id, "?"),
            if label.is_archived.unwrap_or_default() {
                ftl_format!("msg-repo-label-view-archived")
            } else {
                "".into()
            },
            match label.description.as_deref() {
                None | Some("") => ftl_format!("msg-repo-label-view-no_description"),
                Some(x) => x.into(),
            },
        );
    }

    Ok(())
}

async fn create_repo_label(
    api: &Forgejo,
    repo: &RepoName,
    name: String,
    color: String,
    description: Option<Option<String>>,
    exclusive: bool,
    archived: bool,
) -> eyre::Result<()> {
    let description = get_user_description(description).await?;

    let label = api
        .issue_create_label(
            repo.owner(),
            repo.name(),
            forgejo_api::structs::CreateLabelOption {
                color,
                description,
                exclusive: Some(exclusive),
                is_archived: Some(archived),
                name,
            },
        )
        .await?;

    ftl_println!(
        "msg-repo-label-create-success",
        label = crate::render_label(&label)?,
    );
    Ok(())
}

async fn delete_repo_label(api: &Forgejo, repo: &RepoName, name: String) -> eyre::Result<()> {
    let id = find_user_label(api, repo, &name).await?;

    api.issue_delete_label(repo.owner(), repo.name(), id)
        .await?;

    ftl_println!("msg-repo-label-delete-success", label = &name);
    Ok(())
}

#[allow(clippy::too_many_arguments)]
async fn edit_repo_label(
    api: &Forgejo,
    repo: &RepoName,
    id: String,
    name: Option<String>,
    color: Option<String>,
    description: Option<Option<String>>,
    exclusive: Option<bool>,
    is_archived: Option<bool>,
) -> eyre::Result<()> {
    let id = find_user_label(api, repo, &id).await?;
    let description = get_user_description(description).await?;
    let label = api
        .issue_edit_label(
            repo.owner(),
            repo.name(),
            id,
            forgejo_api::structs::EditLabelOption {
                color,
                description,
                exclusive,
                is_archived,
                name,
            },
        )
        .await?;

    ftl_println!(
        "msg-repo-label-edit-success",
        label = crate::render_label(&label)?,
    );

    Ok(())
}

/// Takes an argument of either a description or instruction to open the editor as passed from the
/// user, potentially opens the editor and returns the final description, if any.
async fn get_user_description(desc: Option<Option<String>>) -> eyre::Result<Option<String>> {
    match desc {
        None => Ok(None),
        Some(Some(desc)) => Ok(Some(desc)),
        Some(None) => {
            let mut desc = String::new();
            crate::editor(&mut desc, Some("txt")).await?;
            Ok(Some(desc))
        }
    }
}

/// Takes a name or ID for label as passed from the user and resolves it to a label ID.
async fn find_user_label(api: &Forgejo, repo: &RepoName, id: &str) -> eyre::Result<i64> {
    if let Ok(id) = i64::from_str(id) {
        return Ok(id);
    }
    let (_headers, labels) = api
        .issue_list_labels(repo.owner(), repo.name(), Default::default())
        .await?;

    labels
        .iter()
        .find(|l| l.name.as_ref().map(|n| n == id).unwrap_or_default())
        .and_then(|l| l.id)
        .ok_or_eyre("No label found with the given name.")
}

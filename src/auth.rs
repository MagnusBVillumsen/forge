use clap::Subcommand;
use eyre::Context;
use sha2::Digest;

use std::collections::BTreeMap;
#[cfg(unix)]
use std::path::PathBuf;

use crate::{ftl_eprintln, ftl_eyre, ftl_format, ftl_println, ftl_readline, h, lh};

#[derive(Subcommand, Clone, Debug)]
pub enum AuthCommand {
    #[clap(about = h!("cmd-auth-login"), long_about = lh!("cmd-auth-login"))]
    Login,
    #[clap(about = h!("cmd-auth-logout"))]
    Logout { host: String },
    #[clap(about = h!("cmd-auth-add_token"), long_about = lh!("cmd-auth-add_token"), alias = "add-key")]
    AddToken {
        #[clap(help = h!("arg-auth-add_token-token"))]
        token: Option<String>,
    },
    #[clap(about = h!("cmd-auth-use_ssh"))]
    UseSsh { use_ssh: Option<bool> },
    #[clap(about = h!("cmd-auth-list"))]
    List,
}

impl AuthCommand {
    pub async fn run(self, keys: &mut crate::KeyInfo, host_name: Option<&str>) -> eyre::Result<()> {
        match self {
            AuthCommand::Login => {
                let repo_info = crate::repo::RepoInfo::get_current(host_name, None, None, keys)?;
                let host_url = repo_info.host_url();
                let client_info = get_client_info_for(host_url).await?;
                if let Some(client_id) = &client_info {
                    oauth_login(keys, host_url, client_id).await?;
                    keys.save().await?;
                } else {
                    let host_domain = crate::host_name(host_url);
                    let applications_url =
                        format!("https://{host_domain}/user/settings/applications");

                    ftl_eprintln!(
                        "msg-auth-login-oauth_unsupported",
                        host_domain,
                        applications_url,
                    );
                }
            }
            AuthCommand::Logout { host } => {
                let info_opt = keys.hosts.remove(&host);
                if info_opt.is_some() {
                    ftl_println!("msg-auth_logout-success", host);
                    keys.save().await?;
                } else {
                    ftl_println!("msg-auth_logout-already_signed_out", host = host);
                }
            }
            AuthCommand::AddToken { token } => {
                let repo_info = crate::repo::RepoInfo::get_current(host_name, None, None, keys)?;
                let host_url = repo_info.host_url();
                let token = match token {
                    Some(token) => token,
                    None => ftl_readline!("msg-auth-add_token-prompt")
                        .await?
                        .trim()
                        .to_string(),
                };
                let host = crate::host_name(host_url);
                if !keys.hosts.contains_key(host) {
                    let mut login = crate::keys::LoginInfo::Application { token };
                    add_ssh_alias(&mut login, host_url, keys).await;
                    keys.hosts.insert(host.to_owned(), login);
                    keys.save().await?;
                } else {
                    ftl_eprintln!("msg-auth-add_token-already_exists", host);
                }
            }
            AuthCommand::UseSsh { use_ssh } => {
                let repo_info = crate::repo::RepoInfo::get_current(host_name, None, None, keys)?;
                let host = crate::host_name(repo_info.host_url());
                if !keys.hosts.contains_key(host) {
                    ftl_eprintln!("msg-auth-use_ssh-not_logged_in", host);
                } else if use_ssh.unwrap_or(true) {
                    let already_present = keys.default_ssh.insert(host.to_string());
                    if already_present {
                        ftl_println!("msg-auth-use_ssh-enabled", host);
                        keys.save().await?;
                    } else {
                        ftl_println!("msg-auth-use_ssh-already_enabled", host);
                    }
                } else {
                    let was_present = keys.default_ssh.remove(host);
                    if was_present {
                        ftl_println!("msg-auth-use_ssh-disabled", host);
                        keys.save().await?;
                    } else {
                        ftl_println!("msg-auth-use_ssh-already_disabled", host);
                    }
                }
            }
            AuthCommand::List => {
                if keys.hosts.is_empty() {
                    ftl_eprintln!("msg-auth-list-none");
                }
                for host_url in keys.hosts.keys() {
                    println!("{}", host_url);
                }
            }
        }
        Ok(())
    }
}

pub async fn get_client_info_for(url: &url::Url) -> eyre::Result<Option<String>> {
    let host = crate::host_name(url);
    let host = host.strip_suffix("/").unwrap_or(host);
    let mut possible_paths = Vec::with_capacity(3);

    // On MacOS, `directories::ProjectDirs` doesn't include the `.config` path
    // like it does on Linux.
    #[cfg(target_os = "macos")]
    if let Some(user_dirs) = directories::UserDirs::new() {
        possible_paths.push(user_dirs.home_dir().join(".config/forgejo-cli/client_ids"));
    }

    if let Some(dirs) = directories::ProjectDirs::from("", "Cyborus", "forgejo-cli") {
        possible_paths.push(dirs.config_dir().join("client_ids"));
    }

    #[cfg(unix)]
    possible_paths.push(PathBuf::from("/etc/fj/client_ids"));

    for possible_path in possible_paths {
        if let Ok(file) = tokio::fs::read_to_string(possible_path).await {
            let ids = parse_client_info_file(&file)?;
            if let Some(id) = ids.get(host) {
                return Ok(Some(id.to_string()));
            }
        }
    }

    let builtin = match host {
        "codeberg.org" => "19ac3dd0-e101-445d-aa60-d8ea3876bc5d",
        "code.forgejo.org" => "ab67d8a2-72bd-42e8-ae05-937eaba31e24",
        "v11.next.forgejo.org" => "0df6d672-fe05-4c9a-a5a9-e111e4905e14",
        "v13.next.forgejo.org" => "ef27a227-65f4-4bcb-be56-f8c9b44457b0",
        "v14.next.forgejo.org" => "2dc5d6d7-01b0-47b4-814e-b4b60aea2376",
        "v15.next.forgejo.org" => "344998d8-4139-4a51-8ef9-a5fa40673ea5",
        "v16.next.forgejo.org" => "0b561d01-fd05-4321-9d46-9cb8c776fc80",
        "v17.next.forgejo.org" => "e1a0797a-77af-41a5-b086-9efa6062298b",
        "git.disroot.org" => "c6051ae0-6d21-4c17-92e6-41b957376d09",
        "git.pub.solar" => "6c7fad2f-41c4-4c2d-90b2-5f7fd19c9be2",
        "git.kaki87.net" => "951299e6-cf99-4a9e-8aaf-4b4b4ac36f04",
        "git.gay" => "15233962-8f9d-4192-a7d7-129fb8c6bbff",
        "git.auxolotl.org" => "09fb4377-1e98-4c94-a43f-2c9843388e11",
        "git.lix.systems" => "71ec029f-b5a1-4079-8e06-5b957288b063",
        "code.ffmpeg.org" => "75d19c4d-01d0-4825-8953-76ad66543f2c",
        "forge.fedoraproject.org" => "b15a2f44-75b0-4d2f-a740-50e45cc161a3",
        "codefloe.com" => "d8f0480c-cc0a-4cfc-8a16-4b88230d61d4",
        "openlat.dev" => "4a69c5bc-64a0-482d-bd2f-7c1b1b3e0b6e",
        _ => return Ok(None),
    };

    Ok(Some(builtin.to_string()))
}

fn parse_client_info_file(file: &str) -> eyre::Result<BTreeMap<&str, &str>> {
    file.lines()
        .map(|s| s.split_once("#").map(|s| s.0).unwrap_or(s).trim())
        .enumerate()
        .filter(|(_, s)| !s.is_empty())
        .map(|(line_num, s)| {
            let mut iter = s.split_whitespace();
            let host = iter.next().expect("can't fail, empty lines filtered");
            let client_id = iter
                .next()
                .ok_or_else(|| eyre::eyre!("missing client id on line {}", line_num + 1))?;
            Ok::<_, eyre::Error>((host, client_id))
        })
        .collect::<Result<BTreeMap<&str, &str>, _>>()
}

//pub fn get_client_info_for(url: &url::Url) -> Option<&'static str> {
//    let host = crate::host_with_port_and_path(url);
//    let host = host.strip_suffix("/").unwrap_or(host);
//    include!(concat!(env!("OUT_DIR"), "/oauth_client_info.rs"))
//}

async fn oauth_login(
    keys: &mut crate::KeyInfo,
    host: &url::Url,
    client_id: &str,
) -> eyre::Result<()> {
    use base64ct::Encoding;
    use rand::{distr::Alphanumeric, prelude::*};

    let mut rng = rand::rng();

    let state = (0..32)
        .map(|_| rng.sample(Alphanumeric) as char)
        .collect::<String>();
    let code_verifier = (0..43)
        .map(|_| rng.sample(Alphanumeric) as char)
        .collect::<String>();
    let code_challenge =
        base64ct::Base64UrlUnpadded::encode_string(sha2::Sha256::digest(&code_verifier).as_slice());

    let mut auth_url = host.clone();
    auth_url
        .path_segments_mut()
        .map_err(|_| eyre::eyre!("invalid url"))?
        .extend(["login", "oauth", "authorize"]);
    auth_url.query_pairs_mut().extend_pairs([
        ("client_id", client_id),
        ("redirect_uri", "http://127.0.0.1:26218/"),
        ("response_type", "code"),
        ("code_challenge_method", "S256"),
        ("code_challenge", &code_challenge),
        ("state", &state),
    ]);
    open::that_detached(auth_url.as_str())
        .wrap_err_with(|| ftl_eyre!("msg-auth-login-oauth-login-open-fail"))?;

    let (handle, mut rx) = auth_server();
    let res = rx.recv().await.unwrap();
    handle.abort();
    let code = match res {
        Ok(Some(response)) => {
            if response.state == state {
                response.code
            } else {
                eyre::bail!("returned with invalid state");
            }
        }
        Ok(None) => {
            ftl_eprintln!("msg-auth-login-canceled");
            return Ok(());
        }
        Err(e) => {
            eyre::bail!("Failed to authenticate: {e}");
        }
    };

    let api = forgejo_api::Forgejo::with_user_agent(
        forgejo_api::Auth::None,
        host.clone(),
        crate::USER_AGENT,
    )?;
    let request = forgejo_api::structs::OAuthTokenRequest::Public {
        client_id,
        code_verifier: &code_verifier,
        code: &code,
        redirect_uri: url::Url::parse("http://127.0.0.1:26218/").unwrap(),
    };
    let response = api.oauth_get_access_token(request).await?;

    // A minute less, in case any weirdness happens at the exact moment it
    // expires. Better to refresh slightly too soon than slightly too late.
    let expires_in = std::time::Duration::from_secs(response.expires_in.saturating_sub(60) as u64);
    let expires_at = time::OffsetDateTime::now_utc() + expires_in;
    let mut login_info = crate::keys::LoginInfo::OAuth {
        token: response.access_token,
        refresh_token: response.refresh_token,
        expires_at,
    };
    add_ssh_alias(&mut login_info, host, keys).await;
    let domain = crate::host_name(host);
    keys.hosts.insert(domain.to_owned(), login_info);

    Ok(())
}

use tokio::{sync::mpsc::Receiver, task::JoinHandle};

struct AuthResponse {
    code: String,
    state: String,
}

type AuthServerReceiver = Receiver<Result<Option<AuthResponse>, String>>;

fn auth_server() -> (JoinHandle<eyre::Result<()>>, AuthServerReceiver) {
    let addr: std::net::SocketAddr = ([127, 0, 0, 1], 26218).into();
    let (tx, rx) = tokio::sync::mpsc::channel(1);
    let tx = std::sync::Arc::new(tx);
    let handle = tokio::spawn(async move {
        let listener = tokio::net::TcpListener::bind(addr).await?;
        let server =
            hyper_util::server::conn::auto::Builder::new(hyper_util::rt::TokioExecutor::new());
        let svc = hyper::service::service_fn(|req: hyper::Request<hyper::body::Incoming>| {
            let tx = std::sync::Arc::clone(&tx);
            async move {
                let mut code = None;
                let mut state = None;
                let mut error_description = None;
                if let Some(query) = req.uri().query() {
                    for item in query.split("&") {
                        let (key, value) = item.split_once("=").unwrap_or((item, ""));
                        match key {
                            "code" => code = Some(value),
                            "state" => state = Some(value),
                            "error_description" => error_description = Some(value),
                            _ => eprintln!("unknown key {key} {value}"),
                        }
                    }
                }
                let (response, message) = match (code, state, error_description) {
                    (_, _, Some(error)) => (
                        Err(error.to_owned()),
                        ftl_format!("msg-auth-login-browser_failure").into_owned(),
                    ),
                    (Some(code), Some(state), None) => (
                        Ok(Some(AuthResponse {
                            code: code.to_owned(),
                            state: state.to_owned(),
                        })),
                        ftl_format!("msg-auth-login-browser_success").into_owned(),
                    ),
                    _ => (Ok(None), String::new()),
                };
                tx.send(response).await.unwrap();
                Ok::<_, hyper::Error>(hyper::Response::new(message.to_owned()))
            }
        });
        loop {
            let (connection, _addr) = listener.accept().await.unwrap();
            server
                .serve_connection(hyper_util::rt::TokioIo::new(connection), svc)
                .await
                .unwrap();
        }
    });
    (handle, rx)
}

async fn add_ssh_alias(
    login: &mut crate::keys::LoginInfo,
    host_url: &url::Url,
    keys: &mut crate::keys::KeyInfo,
) {
    let api = match login.api_for(host_url).await {
        Ok(x) => x,
        Err(_) => return,
    };
    if let Some(ssh_url) = get_instance_ssh_url(api).await {
        let http_host = crate::host_name(host_url);
        let ssh_host = crate::host_name(&ssh_url);
        if http_host != ssh_host {
            let target = match host_url.scheme() {
                "https" => http_host.to_string(),
                scheme => format!("{scheme}://{http_host}"),
            };
            keys.aliases.insert(ssh_host.to_string(), target);
        }
    }
}

async fn get_instance_ssh_url(api: forgejo_api::Forgejo) -> Option<url::Url> {
    let query = forgejo_api::structs::RepoSearchQuery::default();
    let results = api.repo_search(query).page_size(1).await.ok()?;
    let ssh_url = results.data?.pop()?.ssh_url?;
    let (instance_ssh_url, _) = crate::repo::url_strip_repo_name(ssh_url).ok()?;
    Some(instance_ssh_url)
}

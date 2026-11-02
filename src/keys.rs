use forgejo_api::{Auth, Forgejo};
use std::{
    collections::{BTreeMap, BTreeSet},
    io::ErrorKind,
    path::Path,
};
use tokio::io::AsyncWriteExt;
use url::Url;

use crate::{ftl_eprintln, ftl_eyre};

#[derive(serde::Serialize, serde::Deserialize, Clone, Default)]
pub struct KeyInfo {
    pub hosts: BTreeMap<String, LoginInfo>,
    #[serde(default)]
    pub aliases: BTreeMap<String, String>,
    #[serde(default)]
    pub default_ssh: BTreeSet<String>,
}

impl KeyInfo {
    // Try the old path for backwards compatibility
    // Give this a release or two for users to migrate and then remove this codepath
    async fn load_fallback(new_path: &Path) -> eyre::Result<Self> {
        let fallback = directories::ProjectDirs::from("", "Cyborus", "forgejo-cli")
            .ok_or_else(|| ftl_eyre!("msg-project-dir-not-found"))?
            .data_dir()
            .join("keys.json");
        let json = tokio::fs::read(fallback).await;
        let this = match json {
            Ok(x) => {
                ftl_eprintln!("msg-old-key-file-read");
                serde_json::from_slice::<Self>(&x)?
            }
            Err(e) if e.kind() == ErrorKind::NotFound => {
                return Ok(Self::default());
            }
            Err(e) => return Err(e.into()),
        };
        if this.save().await.is_err() {
            ftl_eprintln!(
                "msg-save-migrated-key-file-fail",
                path = new_path.to_string_lossy()
            );
        }
        Ok(this)
    }

    pub async fn load() -> eyre::Result<Self> {
        let path = directories::ProjectDirs::from("", "", "forge")
            .ok_or_else(|| ftl_eyre!("msg-project-dir-not-found"))?
            .data_dir()
            .join("keys.json");
        let json = tokio::fs::read(path.as_path()).await;
        let this = match json {
            Ok(x) => serde_json::from_slice::<Self>(&x)?,
            Err(e) if e.kind() == ErrorKind::NotFound => {
                KeyInfo::load_fallback(path.as_path()).await?
            }
            Err(e) => return Err(e.into()),
        };
        Ok(this)
    }

    pub async fn save(&self) -> eyre::Result<()> {
        let json = serde_json::to_vec_pretty(self)?;
        let dirs = directories::ProjectDirs::from("", "", "forge")
            .ok_or_else(|| ftl_eyre!("msg-project-dir-not-found"))?;
        let path = dirs.data_dir();

        tokio::fs::create_dir_all(path).await?;

        let mut options = std::fs::OpenOptions::new();
        options.create(true).write(true).truncate(true);

        #[cfg(unix)]
        {
            use std::os::unix::fs::OpenOptionsExt;
            options.mode(0o600);
        }

        let mut file = tokio::fs::OpenOptions::from(options)
            .open(path.join("keys.json"))
            .await?;
        file.write_all(&json).await?;

        Ok(())
    }

    pub fn get_login(&mut self, url: &Url) -> Option<&mut LoginInfo> {
        let host = crate::host_name(url);
        let login_info = self.hosts.get_mut(host)?;
        Some(login_info)
    }

    pub async fn get_api(&mut self, url: &Url) -> eyre::Result<Forgejo> {
        if let Some(token) = env_token() {
            return Forgejo::with_user_agent(Auth::Token(&token), url.clone(), crate::USER_AGENT)
                .map_err(Into::into);
        }
        match self.get_login(url) {
            Some(login) => {
                let was_refreshed = login.refresh(url).await?;
                let api = login.api_for(url).await?;
                if was_refreshed {
                    self.save().await?;
                }
                Ok(api)
            }
            None => Forgejo::with_user_agent(Auth::None, url.clone(), crate::USER_AGENT)
                .map_err(Into::into),
        }
    }

    /// The token `forge` would authenticate with, refreshed first if it is an
    /// expired OAuth token.
    pub async fn get_token(&mut self, url: &Url) -> eyre::Result<Option<String>> {
        if let Some(token) = env_token() {
            return Ok(Some(token));
        }
        let Some(login) = self.get_login(url) else {
            return Ok(None);
        };
        let was_refreshed = login.refresh(url).await?;
        let token = login.token().to_owned();
        if was_refreshed {
            self.save().await?;
        }
        Ok(Some(token))
    }

    pub fn deref_alias(&self, url: url::Url) -> url::Url {
        match self.aliases.get(crate::host_name(&url)) {
            Some(replacement) => {
                let s = format!(
                    "{}{}{}",
                    &url[..url::Position::BeforeHost],
                    replacement,
                    &url[url::Position::AfterPort..]
                );
                url::Url::parse(&s).unwrap()
            }
            None => url,
        }
    }
}

#[derive(serde::Serialize, serde::Deserialize, Clone)]
#[serde(tag = "type")]
pub enum LoginInfo {
    Application {
        token: String,
    },
    OAuth {
        token: String,
        refresh_token: String,
        expires_at: time::OffsetDateTime,
    },
}

/// `FORGE_TOKEN` overrides the stored login on every host, like `GH_TOKEN`
/// does for `gh`, so each agent or CI job can act as its own user.
fn env_token() -> Option<String> {
    std::env::var("FORGE_TOKEN").ok().filter(|x| !x.is_empty())
}

impl LoginInfo {
    fn token(&self) -> &str {
        match self {
            LoginInfo::Application { token } => token,
            LoginInfo::OAuth { token, .. } => token,
        }
    }

    async fn refresh(&mut self, url: &Url) -> eyre::Result<bool> {
        if let LoginInfo::OAuth {
            token,
            refresh_token,
            expires_at,
            ..
        } = self
            && time::OffsetDateTime::now_utc() >= *expires_at
        {
            let api = Forgejo::with_user_agent(Auth::None, url.clone(), crate::USER_AGENT)?;
            let client_id = crate::auth::get_client_info_for(url)
                .await?
                .ok_or_else(|| eyre::eyre!("Can't refresh token: no client info for {url}."))?;
            let response = api
                .oauth_get_access_token(forgejo_api::structs::OAuthTokenRequest::Refresh {
                    refresh_token,
                    client_id: &client_id,
                    client_secret: "",
                })
                .await?;
            *token = response.access_token;
            *refresh_token = response.refresh_token;
            // A minute less, in case any weirdness happens at the exact moment it
            // expires. Better to refresh slightly too soon than slightly too late.
            let expires_in =
                std::time::Duration::from_secs(response.expires_in.saturating_sub(60) as u64);
            *expires_at = time::OffsetDateTime::now_utc() + expires_in;
            return Ok(true);
        }
        Ok(false)
    }

    pub async fn api_for(&self, url: &Url) -> eyre::Result<Forgejo> {
        match self {
            LoginInfo::Application { token, .. } => {
                let api =
                    Forgejo::with_user_agent(Auth::Token(token), url.clone(), crate::USER_AGENT)?;
                Ok(api)
            }
            LoginInfo::OAuth { token, .. } => {
                let api =
                    Forgejo::with_user_agent(Auth::Token(token), url.clone(), crate::USER_AGENT)?;
                Ok(api)
            }
        }
    }
}

use std::io::{IsTerminal, Read, Write};
use std::path::PathBuf;

use clap::Args;
use eyre::Context;
use reqwest::{Method, header};
use serde_json::{Map, Value};
use url::Url;

use crate::{
    KeyInfo, ftl_bail, ftl_eyre, h,
    repo::{RepoArg, RepoInfo, RepoName},
};

#[derive(Args, Clone, Debug)]
pub struct ApiCommand {
    #[clap(help = h!("arg-api-endpoint"))]
    endpoint: String,

    #[clap(help = h!("arg-api-method"))]
    #[clap(long, short = 'X')]
    method: Option<String>,

    #[clap(help = h!("arg-api-field"))]
    #[clap(long = "field", short = 'F', value_name = "KEY=VALUE")]
    fields: Vec<String>,

    #[clap(help = h!("arg-api-raw-field"))]
    #[clap(long = "raw-field", short = 'f', value_name = "KEY=VALUE")]
    raw_fields: Vec<String>,

    #[clap(help = h!("arg-api-header"))]
    #[clap(long = "header", value_name = "KEY:VALUE")]
    headers: Vec<String>,

    #[clap(help = h!("arg-api-input"))]
    #[clap(long, value_name = "FILE")]
    input: Option<PathBuf>,

    #[clap(help = h!("arg-api-paginate"))]
    #[clap(long)]
    paginate: bool,

    #[clap(help = h!("arg-api-include"))]
    #[clap(long, short)]
    include: bool,

    #[clap(help = h!("arg-api-silent"))]
    #[clap(long)]
    silent: bool,

    #[clap(help = h!("arg-remote"))]
    #[clap(long, short = 'R')]
    remote: Option<String>,

    #[clap(help = h!("arg-repo"))]
    #[clap(long, short)]
    repo: Option<RepoArg>,
}

impl ApiCommand {
    pub async fn run(self, keys: &mut KeyInfo, host_name: Option<&str>) -> eyre::Result<()> {
        let info =
            RepoInfo::get_current(host_name, self.repo.as_ref(), self.remote.as_deref(), keys)
                .wrap_err("could not find host, try specifying with --host")?;
        let endpoint = fill_placeholders(&self.endpoint, info.name())?;
        let mut url = endpoint_url(info.host_url(), &endpoint)?;
        let token = keys.get_token(info.host_url()).await?;

        let mut fields = Value::Object(Map::new());
        for field in &self.raw_fields {
            let (key, value) = split_field(field)?;
            insert_field(&mut fields, key, Value::String(value.to_owned()))?;
        }
        for field in &self.fields {
            let (key, value) = split_field(field)?;
            insert_field(&mut fields, key, typed_value(value)?)?;
        }
        let has_fields = fields.as_object().is_some_and(|x| !x.is_empty());

        let input = match &self.input {
            Some(path) if path.as_os_str() == "-" => {
                let mut buf = Vec::new();
                std::io::stdin().read_to_end(&mut buf)?;
                Some(buf)
            }
            Some(path) => Some(std::fs::read(path)?),
            None => None,
        };

        let method = match &self.method {
            Some(method) => Method::from_bytes(method.to_uppercase().as_bytes())
                .map_err(|_| ftl_eyre!("msg-api-invalid-method", method))?,
            None if has_fields || input.is_some() => Method::POST,
            None => Method::GET,
        };

        // Like `gh api`: fields become the query string when the body is taken,
        // either by `--input` or because the method has none.
        let body = if input.is_some() {
            input
        } else if has_fields && method != Method::GET {
            Some(serde_json::to_vec(&fields)?)
        } else {
            None
        };
        if has_fields && (method == Method::GET || self.input.is_some()) {
            append_query(&mut url, &fields)?;
        }

        let mut extra = header::HeaderMap::new();
        for line in &self.headers {
            let (name, value) = line
                .split_once(':')
                .ok_or_else(|| ftl_eyre!("msg-api-invalid-header", header = line.as_str()))?;
            extra.insert(
                header::HeaderName::from_bytes(name.trim().as_bytes())?,
                header::HeaderValue::from_str(value.trim())?,
            );
        }

        let client = reqwest::Client::builder()
            .user_agent(crate::USER_AGENT)
            .build()?;
        let mut pages = Vec::new();
        let mut next = Some(url);
        while let Some(url) = next.take() {
            let mut request = client.request(method.clone(), url).headers(extra.clone());
            if let Some(token) = &token {
                request = request.header(header::AUTHORIZATION, format!("token {token}"));
            }
            if let Some(body) = &body {
                if !extra.contains_key(header::CONTENT_TYPE) {
                    request = request.header(header::CONTENT_TYPE, "application/json");
                }
                request = request.body(body.clone());
            }
            let response = request.send().await?;
            let status = response.status();
            if self.include {
                print_head(&response);
            }
            if self.paginate && status.is_success() {
                next = next_link(response.headers());
            }
            let bytes = response.bytes().await?;
            if !status.is_success() {
                write_body(&bytes)?;
                ftl_bail!("msg-api-status", status = status.to_string());
            }
            pages.push(bytes);
        }

        if self.silent {
            return Ok(());
        }
        if pages.len() > 1 {
            // A paginated list comes back as one array, so it can be piped to jq.
            let arrays = pages
                .iter()
                .map(|page| serde_json::from_slice::<Vec<Value>>(page))
                .collect::<Result<Vec<_>, _>>();
            if let Ok(arrays) = arrays {
                let all = arrays.into_iter().flatten().collect::<Vec<_>>();
                return write_body(&serde_json::to_vec(&all)?);
            }
        }
        for page in &pages {
            write_body(page)?;
        }
        Ok(())
    }
}

fn fill_placeholders(endpoint: &str, name: Option<&RepoName>) -> eyre::Result<String> {
    if !endpoint.contains("{owner}") && !endpoint.contains("{repo}") {
        return Ok(endpoint.to_owned());
    }
    let name = name.ok_or_else(|| ftl_eyre!("msg-api-no-repo"))?;
    Ok(endpoint
        .replace("{owner}", name.owner())
        .replace("{repo}", name.name()))
}

fn endpoint_url(host: &Url, endpoint: &str) -> eyre::Result<Url> {
    if endpoint.starts_with("http://") || endpoint.starts_with("https://") {
        let url = Url::parse(endpoint)?;
        // The token is only ever sent to the host it belongs to.
        if url.origin() != host.origin() {
            ftl_bail!("msg-api-other-host", host = host.as_str());
        }
        return Ok(url);
    }
    let mut base = host.clone();
    if !base.path().ends_with('/') {
        base.set_path(&format!("{}/", base.path()));
    }
    let path = endpoint.trim_start_matches('/');
    let path = if path.starts_with("api/") {
        path.to_owned()
    } else {
        format!("api/v1/{path}")
    };
    Ok(base.join(&path)?)
}

fn split_field(field: &str) -> eyre::Result<(&str, &str)> {
    field
        .split_once('=')
        .ok_or_else(|| ftl_eyre!("msg-api-invalid-field", field))
}

/// `-F` values: true, false, null and integers become JSON, `@file` reads a
/// file (`@-` reads stdin), anything else stays a string.
fn typed_value(value: &str) -> eyre::Result<Value> {
    Ok(match value {
        "true" => Value::Bool(true),
        "false" => Value::Bool(false),
        "null" => Value::Null,
        "@-" => {
            let mut buf = String::new();
            std::io::stdin().read_to_string(&mut buf)?;
            Value::String(buf)
        }
        _ if value.starts_with('@') => Value::String(
            std::fs::read_to_string(&value[1..]).wrap_err_with(|| value[1..].to_owned())?,
        ),
        _ => match value.parse::<i64>() {
            Ok(n) => Value::Number(n.into()),
            Err(_) => Value::String(value.to_owned()),
        },
    })
}

enum Segment {
    Key(String),
    Push,
}

fn parse_key(key: &str) -> eyre::Result<Vec<Segment>> {
    let (head, mut rest) = key.split_at(key.find('[').unwrap_or(key.len()));
    if head.is_empty() {
        ftl_bail!("msg-api-invalid-field", field = key);
    }
    let mut segments = vec![Segment::Key(head.to_owned())];
    while !rest.is_empty() {
        let end = rest
            .strip_prefix('[')
            .and_then(|x| x.find(']'))
            .ok_or_else(|| ftl_eyre!("msg-api-invalid-field", field = key))?;
        let inner = &rest[1..=end];
        segments.push(if inner.is_empty() {
            Segment::Push
        } else {
            Segment::Key(inner.to_owned())
        });
        rest = &rest[end + 2..];
    }
    Ok(segments)
}

/// Places a value at `key`, where `a[b]` nests an object and `a[]` appends to
/// an array. As in `gh api`, `a[][x]` fills the last element until it already
/// has `x`, so `-f c[][path]=… -f c[][body]=…` builds one object.
fn insert_field(root: &mut Value, key: &str, value: Value) -> eyre::Result<()> {
    let segments = parse_key(key)?;
    place(root, &segments, value).ok_or_else(|| ftl_eyre!("msg-api-field-conflict", field = key))
}

fn place(target: &mut Value, segments: &[Segment], value: Value) -> Option<()> {
    let Some((first, rest)) = segments.split_first() else {
        *target = value;
        return Some(());
    };
    match first {
        Segment::Key(key) => {
            if target.is_null() {
                *target = Value::Object(Map::new());
            }
            let entry = target
                .as_object_mut()?
                .entry(key.clone())
                .or_insert(Value::Null);
            place(entry, rest, value)
        }
        Segment::Push => {
            if target.is_null() {
                *target = Value::Array(Vec::new());
            }
            let array = target.as_array_mut()?;
            let reuse = match (rest.first(), array.last()) {
                (Some(Segment::Key(key)), Some(Value::Object(last))) => !last.contains_key(key),
                _ => false,
            };
            if !reuse {
                array.push(Value::Null);
            }
            place(array.last_mut()?, rest, value)
        }
    }
}

fn append_query(url: &mut Url, fields: &Value) -> eyre::Result<()> {
    let mut query = url.query_pairs_mut();
    for (key, value) in fields.as_object().into_iter().flatten() {
        let values = match value {
            Value::Array(items) => items.iter().collect::<Vec<_>>(),
            other => vec![other],
        };
        for value in values {
            let text = match value {
                Value::String(s) => s.clone(),
                Value::Object(_) | Value::Array(_) => {
                    ftl_bail!("msg-api-nested-query", field = key.as_str())
                }
                other => other.to_string(),
            };
            query.append_pair(key, &text);
        }
    }
    Ok(())
}

fn next_link(headers: &header::HeaderMap) -> Option<Url> {
    let link = headers.get(header::LINK)?.to_str().ok()?;
    link.split(',').find_map(|part| {
        let (target, params) = part.split_once(';')?;
        params
            .split(';')
            .any(|p| p.trim() == r#"rel="next""#)
            .then(|| target.trim().trim_start_matches('<').trim_end_matches('>'))
            .and_then(|x| Url::parse(x).ok())
    })
}

fn print_head(response: &reqwest::Response) {
    println!("{:?} {}", response.version(), response.status());
    for (name, value) in response.headers() {
        println!("{name}: {}", value.to_str().unwrap_or("<binary>"));
    }
    println!();
}

fn write_body(bytes: &[u8]) -> eyre::Result<()> {
    let mut stdout = std::io::stdout().lock();
    if stdout.is_terminal()
        && let Ok(json) = serde_json::from_slice::<Value>(bytes)
    {
        writeln!(stdout, "{}", serde_json::to_string_pretty(&json)?)?;
        return Ok(());
    }
    stdout.write_all(bytes)?;
    if !bytes.is_empty() && !bytes.ends_with(b"\n") {
        writeln!(stdout)?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn build(fields: &[(&str, Value)]) -> Value {
        let mut root = Value::Object(Map::new());
        for (key, value) in fields {
            insert_field(&mut root, key, value.clone()).unwrap();
        }
        root
    }

    #[test]
    fn nested_fields_group_like_gh() {
        let root = build(&[
            ("event", "COMMENT".into()),
            ("comments[][path]", "a.rs".into()),
            ("comments[][body]", "x".into()),
            ("comments[][path]", "b.rs".into()),
            ("labels[]", 1.into()),
            ("labels[]", 2.into()),
            ("options[merge]", true.into()),
        ]);
        assert_eq!(
            root,
            serde_json::json!({
                "event": "COMMENT",
                "comments": [{"path": "a.rs", "body": "x"}, {"path": "b.rs"}],
                "labels": [1, 2],
                "options": {"merge": true},
            })
        );
    }

    #[test]
    fn conflicting_field_types_are_rejected() {
        let mut root = Value::Object(Map::new());
        insert_field(&mut root, "a", "x".into()).unwrap();
        assert!(insert_field(&mut root, "a[b]", "y".into()).is_err());
        assert!(insert_field(&mut root, "a[", "y".into()).is_err());
    }

    #[test]
    fn typed_values() {
        assert_eq!(typed_value("true").unwrap(), Value::Bool(true));
        assert_eq!(typed_value("42").unwrap(), Value::from(42));
        assert_eq!(typed_value("4.2").unwrap(), Value::from("4.2"));
        assert_eq!(typed_value("null").unwrap(), Value::Null);
    }

    #[test]
    fn endpoints_resolve_under_api_v1() {
        let host = Url::parse("http://heimdall:3000/").unwrap();
        let sub = Url::parse("https://example.org/forgejo").unwrap();
        assert_eq!(
            endpoint_url(&host, "repos/a/b/pulls").unwrap().as_str(),
            "http://heimdall:3000/api/v1/repos/a/b/pulls"
        );
        assert_eq!(
            endpoint_url(&host, "/api/v1/version").unwrap().as_str(),
            "http://heimdall:3000/api/v1/version"
        );
        assert_eq!(
            endpoint_url(&sub, "version").unwrap().as_str(),
            "https://example.org/forgejo/api/v1/version"
        );
        assert!(endpoint_url(&host, "https://evil.example/api/v1/user").is_err());
    }

    #[test]
    fn query_from_fields() {
        let mut url = Url::parse("http://h/api/v1/x").unwrap();
        let fields = build(&[("state", "open".into()), ("labels[]", 3.into())]);
        append_query(&mut url, &fields).unwrap();
        assert_eq!(url.query(), Some("labels=3&state=open"));
    }

    #[test]
    fn link_header_next() {
        let mut headers = header::HeaderMap::new();
        headers.insert(
            header::LINK,
            r#"<http://h/api/v1/x?page=2>; rel="next",<http://h/api/v1/x?page=5>; rel="last""#
                .parse()
                .unwrap(),
        );
        assert_eq!(
            next_link(&headers).unwrap().as_str(),
            "http://h/api/v1/x?page=2"
        );
    }
}

use std::io::{IsTerminal, Write};

use clap::Args;
use serde::Serialize;
use serde_json::{Map, Value};

use crate::{ftl_bail, h};

#[derive(Args, Clone, Debug, Default)]
pub struct JsonArgs {
    #[clap(help = h!("arg-json"))]
    #[clap(long, global = true, value_name = "FIELDS")]
    #[clap(num_args = 0..=1, default_missing_value = "")]
    json: Option<String>,
}

impl JsonArgs {
    pub fn enabled(&self) -> bool {
        self.json.is_some()
    }

    /// Prints `value` as JSON, keeping only the requested top-level fields of
    /// each object when a field list was given.
    pub fn print<T: Serialize>(&self, value: &T) -> eyre::Result<()> {
        let mut value = serde_json::to_value(value)?;
        let fields = self
            .json
            .as_deref()
            .unwrap_or_default()
            .split(',')
            .map(str::trim)
            .filter(|x| !x.is_empty())
            .collect::<Vec<_>>();
        if !fields.is_empty() {
            value = match value {
                Value::Array(items) => Value::Array(
                    items
                        .into_iter()
                        .map(|x| select(x, &fields))
                        .collect::<eyre::Result<_>>()?,
                ),
                other => select(other, &fields)?,
            };
        }
        let mut stdout = std::io::stdout().lock();
        if stdout.is_terminal() {
            serde_json::to_writer_pretty(&mut stdout, &value)?;
        } else {
            serde_json::to_writer(&mut stdout, &value)?;
        }
        writeln!(stdout)?;
        Ok(())
    }
}

fn select(value: Value, fields: &[&str]) -> eyre::Result<Value> {
    let Value::Object(mut object) = value else {
        return Ok(value);
    };
    let mut out = Map::new();
    for field in fields {
        match object.remove(*field) {
            Some(x) => {
                out.insert((*field).to_owned(), x);
            }
            None if out.contains_key(*field) => {}
            None => {
                let mut available = object.keys().chain(out.keys()).cloned().collect::<Vec<_>>();
                available.sort();
                ftl_bail!(
                    "msg-json-unknown-field",
                    field = *field,
                    available = available.join(", "),
                );
            }
        }
    }
    Ok(Value::Object(out))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn selects_fields_of_each_element() {
        let value = serde_json::json!([{"a": 1, "b": 2, "c": 3}, {"a": 4, "b": 5}]);
        let out = select(value[0].clone(), &["a", "c"]).unwrap();
        assert_eq!(out, serde_json::json!({"a": 1, "c": 3}));
        assert!(select(value[1].clone(), &["nope"]).is_err());
    }
}

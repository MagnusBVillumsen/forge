use std::io::Write;

use clap::{ArgAction, Args, CommandFactory, ValueEnum};
use eyre::OptionExt;

#[derive(Args, Clone, Debug)]
pub struct CompletionCommand {
    shell: Shell,
    #[clap(long)]
    bin_name: Option<String>,
}

#[derive(ValueEnum, Clone, Debug)]
#[allow(clippy::enum_variant_names)]
pub enum Shell {
    Bash,
    Elvish,
    Fish,
    PowerShell,
    Zsh,
    Nushell,
}

impl CompletionCommand {
    pub fn run(self) {
        use Shell::*;
        use clap_complete::Shell as CCShell;
        let mut cmd = crate::App::command();
        let app_name = self.bin_name.as_deref().unwrap_or("forge");
        let mut writer = std::io::stdout();
        match self.shell {
            Bash => clap_complete::generate(CCShell::Bash, &mut cmd, app_name, &mut writer),
            Elvish => clap_complete::generate(CCShell::Elvish, &mut cmd, app_name, &mut writer),
            Fish => clap_complete::generate(CCShell::Fish, &mut cmd, app_name, &mut writer),
            PowerShell => {
                clap_complete::generate(CCShell::PowerShell, &mut cmd, app_name, &mut writer)
            }
            Zsh => clap_complete::generate(CCShell::Zsh, &mut cmd, app_name, &mut writer),
            Nushell => clap_complete::generate(NushellCompletion, &mut cmd, app_name, &mut writer),
        }
    }
}

// Heavily inspired by clap_complete_nushell
// but rewritten/modified since I'm not a fan of its completions

struct NushellCompletion;

impl clap_complete::Generator for NushellCompletion {
    fn file_name(&self, name: &str) -> String {
        format!("{name}.nu")
    }

    fn generate(&self, cmd: &clap::Command, buf: &mut dyn Write) {
        generate_command(cmd, buf).expect("failed to generate nushell completions");
    }
}

fn generate_command(cmd: &clap::Command, buf: &mut dyn Write) -> eyre::Result<()> {
    writeln!(buf, "module completions {{")?;
    generate_subcommand(cmd, buf)?;
    writeln!(buf, "}}")?;
    writeln!(buf, "export use completions *")?;
    Ok(())
}

fn generate_subcommand(cmd: &clap::Command, buf: &mut dyn Write) -> eyre::Result<()> {
    let name = cmd.get_bin_name().ok_or_eyre("no bin name")?;
    writeln!(buf, "  export extern \"{name}\" [")?;
    let mut args = cmd.get_arguments().collect::<Vec<_>>();
    args.sort_by_key(|arg| arg.is_positional());

    // positional arguments
    for arg in cmd.get_arguments() {
        if !arg.is_positional() {
            continue;
        }

        write!(buf, "    ")?;
        let id = arg.get_id().as_str();

        if matches!(arg.get_action(), ArgAction::Append) {
            write!(buf, "...{id}")?;
        } else {
            write!(buf, "{id}")?;
            if !arg.is_required_set() {
                write!(buf, "?")?;
            }
        }

        arg_type(name, arg, buf)?;
        writeln!(buf)?;
    }

    // subcommand completion
    if cmd.get_subcommands().next().is_some() {
        // basically `!is_empty`
        writeln!(buf, "    rest?: string@\"complete-subcommand {name}\",")?;
    }

    // flag arguments
    for arg in cmd.get_arguments() {
        match (arg.get_long(), arg.get_short()) {
            (Some(long), Some(short)) => write!(buf, "    --{long}(-{short})")?,
            (Some(long), None) => write!(buf, "    --{long}")?,
            (None, Some(short)) => write!(buf, "    -{short}")?,
            (None, None) => continue,
        }
        arg_type(name, arg, buf)?;
        writeln!(buf)?;
    }
    writeln!(buf, "  ]")?;
    writeln!(buf)?;

    // argument completions
    for arg in cmd.get_arguments() {
        let possible_values = arg.get_possible_values();
        if possible_values.is_empty() {
            continue;
        }
        writeln!(
            buf,
            "  def \"complete-value {name} {}\" [] {{",
            arg.get_id().as_str()
        )?;
        writeln!(buf, "    [")?;
        for possible_value in &possible_values {
            write!(buf, "      {{ value: \"{}\"", possible_value.get_name())?;
            if let Some(help) = possible_value.get_help() {
                write!(buf, ", description: \"{help}\"")?;
            }
            writeln!(buf, " }},")?;
        }
        writeln!(buf, "    ]")?;
        writeln!(buf, "  }}")?;
        writeln!(buf)?;
    }

    // subcommand completion
    if cmd.get_subcommands().count() != 0 {
        writeln!(buf, "  def \"complete-subcommand {name}\" [] {{")?;
        writeln!(buf, "    [")?;
        for subcommand in cmd.get_subcommands() {
            write!(buf, "      {{ value: \"{}\"", subcommand.get_name())?;
            if let Some(about) = subcommand.get_about() {
                write!(buf, ", description: \"{about}\"")?;
            }
            writeln!(buf, " }},")?;
        }
        writeln!(buf, "    ]")?;
        writeln!(buf, "  }}")?;
        writeln!(buf)?;
    }

    for subcommand in cmd.get_subcommands() {
        generate_subcommand(subcommand, buf)?;
    }
    Ok(())
}

fn arg_type(cmd_name: &str, arg: &clap::Arg, buf: &mut dyn Write) -> eyre::Result<()> {
    use clap::ValueHint;
    let takes_values = arg
        .get_num_args()
        .map(|r| r.takes_values())
        .unwrap_or_default();
    if takes_values {
        let type_name = match arg.get_value_hint() {
            ValueHint::Unknown => "string",
            ValueHint::Other => "string",
            ValueHint::AnyPath => "path",
            ValueHint::FilePath => "path",
            ValueHint::DirPath => "path",
            ValueHint::ExecutablePath => "path",
            ValueHint::CommandName => "string",
            ValueHint::CommandString => "path",
            ValueHint::CommandWithArguments => "string",
            ValueHint::Username => "string",
            ValueHint::Hostname => "string",
            ValueHint::Url => "string",
            ValueHint::EmailAddress => "string",
            _ => "string",
        };

        write!(buf, ": {type_name}")?;
    }

    let possible_values = arg.get_possible_values();
    if !possible_values.is_empty() {
        write!(
            buf,
            "@\"complete-value {cmd_name} {}\"",
            arg.get_id().as_str()
        )?;
    }

    Ok(())
}

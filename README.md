## `forge`, a Forgejo CLI for scripts and agents

`forge` is a fork of [forgejo-cli (`fj`)](https://codeberg.org/forgejo-contrib/forgejo-cli)
that aims to cover what people reach for `gh` to do: machine-readable output,
reviews with inline comments, CI logs and raw API calls. It is not affiliated
with the forgejo-cli project or with Forgejo; please report problems with
`forge` here, not upstream.

Everything `fj` does still works:

- Open, edit, comment on, close issues
- Create and merge pull requests
  - Easily create AGit pull requests, no need to fork!
- Create, star, watch, and edit repositories
- Manage organizations and teams
- Publish new releases

`forge` doesn't try to replace your usage of `git`, it's meant to work alongside it.
It handles all the Forgejo-specific things that `git` doesn't.

What `forge` adds:

- `forge api ENDPOINT` makes an authenticated API request, with `gh api`'s
  flags: `{owner}`/`{repo}` placeholders, `-X`, `-f`/`-F` fields (nested with
  `key[sub]` and `key[]`), `--input`, `--header`, `--paginate`, `-i`.
- `--json [FIELDS]` on `pr`/`issue` `view` (and its `comments`, `files`,
  `commits` subcommands), `list`, `pr status` and `pr review list`.
- `forge pr review N submit --approve | --request-changes | --comment`, with
  inline comments: `--line src/main.rs:42=Text`, `--line src/main.rs:40-44=Text`,
  `--old-line` for removed lines, or a JSON file with `--comments-file`.
- `forge run list | view | watch | rerun | cancel` for Actions runs. A run is
  the number shown in the web UI, or a run or job URL as found in a PR's
  checks. `forge run view N --log-failed` prints only the failed steps' logs
  (Forgejo 16 or newer).
- `FORGE_TOKEN` overrides the stored login, like `GH_TOKEN`, so each agent or
  CI job can act as its own user.

Logins are stored separately from `fj`'s, in `forge`'s own data directory, so
the two can be installed side by side.

### Installation

With Nix:

```sh
nix run github:MagnusBVillumsen/forge
```

From source:

```sh
cargo install --git https://github.com/MagnusBVillumsen/forge
```

### Licensing

This project is licensed under either
[Apache License Version 2.0](LICENSE-APACHE) or [MIT License](LICENSE-MIT)
at your option, like forgejo-cli, which it is derived from. Copyright in the
original code remains with the forgejo-cli developers.

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.

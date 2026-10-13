# Agent instructions

This repo bootstraps the owner's macOS machines for terminal-first, agent-assisted development.
It is **public**. `CLAUDE.md` imports this file.

## Hard rules

- **No personal data.** Never commit names, email addresses, hostnames, machine names, IPs,
  usernames, employer or client names, internal URLs, tokens, keys, `authorized_keys` entries,
  or paths that reveal any of them. Personal values are chezmoi prompts
  (`home/.chezmoi.toml.tmpl`, answers stored only in `~/.config/chezmoi/chezmoi.toml`) or
  untracked local files (`~/.zshrc.local`, `~/.config/git/local`, `~/.ssh/config.d/`).
  CI fails on anything email-like and runs gitleaks.
- **No AI attribution.** No `Co-Authored-By` trailers or "Generated with" lines in commits or
  PRs. A global commit-msg hook strips them anyway.
- **No sudo.** Steps that need sudo go in `macos/system.sh`, which a human runs with
  `make system`. Steps that need an Apple ID or a GUI are documented in the README.
- **Idempotent and non-interactive.** Every script must be safe to re-run and must not prompt,
  except chezmoi's first-run questions and the sudo password in `macos/system.sh`.
- **Don't weaken the security policy** in `home/dot_claude/modify_settings.json` (sandbox,
  credential denies, ask rules) without the owner asking. Adding a package registry to
  `allowedDomains` is fine; removing a credential path or an ask rule is not.

## Where things go

| To add or change… | Edit |
|---|---|
| A CLI tool, app, font or Mac App Store app | `Brewfile` (keep its sections and comments) |
| A language runtime or global tool version | `home/dot_config/mise/config.toml`. Python is `uv`, Rust is `rustup`, Flutter is `fvm`, Terraform is `tenv`, never Homebrew |
| A dotfile in `$HOME` | `home/` (chezmoi source, see below) |
| Claude Code settings (sandbox, permissions, attribution) | `home/dot_claude/modify_settings.json`. It merges keys into `~/.claude/settings.json`; never replace that file wholesale |
| A Claude Code plugin | `claude/plugins.txt`. Add one only if it earns its context cost; avoid plugins whose hooks call a model on every turn |
| A sudo or one-time system step | `macos/system.sh` |
| A macOS preference | `macos/defaults.sh` |
| A new entry point | `Makefile` (with a `##` help comment) and the README |

### chezmoi naming

`home/` is the source root (`.chezmoiroot`). `dot_x` → `.x`, `private_` → mode 0600/0700,
`executable_` → mode 0755, `x.tmpl` → rendered with the chezmoi data, `modify_x` → a script
that receives the current file on stdin and prints the new one. Use templates for anything
personal; never hard-code it.

## Verify before committing

```sh
make check                 # shellcheck, shfmt, actionlint, Ghostty config validation
chezmoi diff               # what would change in $HOME
chezmoi apply <target>     # apply only what you changed
brew bundle check --file=Brewfile
```

- After editing `home/dot_claude/modify_settings.json`, run
  `sh home/dot_claude/modify_settings.json < ~/.claude/settings.json | jq .` and check that the
  other keys (plugins, hooks) survive, and that `chezmoi status` is clean after applying.
- After editing zsh files, `zsh -i -c exit` must print nothing and start in well under a second.
- Search the diff for personal data before every commit.

## Working inside the Claude Code sandbox

This machine runs Claude Code with the sandbox from this repo, so:

- `chezmoi diff/apply` and anything touching `~/.ssh` fail with "Operation not permitted";
  they need an unsandboxed run.
- `gh`, `git push/fetch/pull`, `gcloud` and `terraform` run unsandboxed only as **plain**
  commands. Inside a pipe, loop, `cd …&&` or `git -C`, they stay sandboxed and lose their
  credentials, so run them on their own.
- `open` and `osascript` are blocked; ask the owner to run GUI or browser steps.

## Commits

Conventional Commits (`feat:`, `fix:`, `ci:`, `docs:`…), one logical change each, on a branch
with a PR. Never force-push `main`.

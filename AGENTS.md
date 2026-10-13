# Agent instructions

This repo bootstraps the owner's macOS machines. It is **public**.

## Hard rules

- Never commit personal data: no names, email addresses, hostnames, IPs, usernames, employer
  or client names, tokens, keys, or paths that reveal them. Personal values are chezmoi
  prompts (`home/.chezmoi.toml.tmpl`) or untracked local files (`~/.zshrc.local`,
  `~/.config/git/local`, `~/.ssh/config.d/`). CI fails on anything email-like.
- Keep every script idempotent and non-interactive except for chezmoi's first-run prompts.
- Steps that need an Apple ID or a GUI are documented in the README, not scripted. Steps that
  only need sudo go in `macos/system.sh` (run by a human with `make system`); keep them
  idempotent. Never run sudo yourself.

## How things fit

- `Brewfile` installs tools and apps. Language runtimes are not in it: mise (node, pnpm, bun,
  go, java), uv (python), rustup (rust), fvm (flutter), tenv (terraform).
- `home/` is the chezmoi source (`.chezmoiroot`). `dot_` → `.`, `private_` → mode 0600/0700,
  `.tmpl` → rendered with the chezmoi data.
- Claude Code plugins live in `claude/plugins.txt`. Add one only if it earns its context cost;
  avoid plugins whose hooks call a model on every turn.
- After changing anything under `home/`, run `chezmoi diff` and then `chezmoi apply`.
- Run `make check` before committing. Commits follow Conventional Commits.

# Agent instructions

This repo bootstraps the owner's macOS machines. It is **public**.

## Hard rules

- Never commit personal data: no names, email addresses, hostnames, IPs, usernames, employer
  or client names, tokens, keys, or paths that reveal them. Personal values are chezmoi
  prompts (`home/.chezmoi.toml.tmpl`) or untracked local files (`~/.zshrc.local`,
  `~/.config/git/local`, `~/.ssh/config.d/`). CI fails on anything email-like.
- Keep every script idempotent and non-interactive except for chezmoi's first-run prompts.
- Steps that need sudo, an Apple ID or a GUI are documented in the README, not scripted.

## How things fit

- `Brewfile` installs tools and apps. Language runtimes are not in it: mise (node, pnpm, bun,
  go, java), uv (python), rustup (rust), fvm (flutter), tenv (terraform).
- `home/` is the chezmoi source (`.chezmoiroot`). `dot_` → `.`, `private_` → mode 0600/0700,
  `.tmpl` → rendered with the chezmoi data.
- After changing anything under `home/`, run `chezmoi diff` and then `chezmoi apply`.
- Run `make check` before committing. Commits follow Conventional Commits.

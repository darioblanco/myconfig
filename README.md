# myconfig

Reproducible macOS setup for terminal-first, agent-assisted development: iOS, Android and
Flutter, Python, Go, Rust, Node, Kubernetes and Terraform, with coding agents (Claude Code,
Codex, pi) running safely in parallel and reachable from anywhere over Tailscale.

Everything is idempotent: re-run it whenever you like. **No personal data lives in this
repository**; it is asked for once and kept on the machine.

## Bootstrap a new Mac

```sh
xcode-select --install          # Command Line Tools
git clone https://github.com/darioblanco/myconfig ~/Code/darioblanco/myconfig
cd ~/Code/darioblanco/myconfig
make install                    # Homebrew, Brewfile, dotfiles, toolchains, Claude Code + plugins
                                # (asks for your password once, to install Homebrew)
```

On first run, chezmoi asks for your name, personal and work emails and the directory that holds
work repositories, and stores the answers in `~/.config/chezmoi/chezmoi.toml`.

Then, in order (these need an Apple ID, sudo or a GUI):

1. **Password-protected installs.** `make brew` in a terminal, for casks shipped as `.pkg`, and
   `mas install 937984704` (Amphetamine) if it failed.
2. **Xcode.** `xcodes install <version> --experimental-unxip` (Apple ID + 2FA). Name the
   version; `--latest` can pick a release candidate.
3. **System setup.** `make system` (sudo): selects the newest Xcode, accepts its license,
   downloads the iOS platform, creates the `test` DNS domain for containers, and limits Remote
   Login to public keys. Add `MACHINE_NAME=<name>` to rename the Mac (also rename it in the
   Tailscale admin console).
4. **Android.** Open Android Studio once and finish the setup wizard, then
   `flutter doctor --android-licenses`.
5. **SSH keys.** Open Secretive and create this Mac's keys in the Secure Enclave. Add the public
   keys to GitHub and your servers. One key set per device; keys are never copied.
6. **Remote access.** System Settings → General → Sharing → Remote Login. Put each device's
   public key in `~/.ssh/authorized_keys` (one per line, `chmod 600`).
7. **macOS preferences.** `make defaults`: Finder, Dock, keyboard and trackpad (tap to click,
   drag lock, press-and-hold accents kept).

## What you get

| Area | Tools |
|---|---|
| Terminal | Ghostty, zsh + zinit, Starship, Atuin, zoxide, fzf, eza, bat, ripgrep, lazygit, yazi |
| Agent sessions | herdr (agent-aware multiplexer inside Ghostty), pulpo (background agents), mosh |
| Coding agents | Claude Code (native installer), Codex, pi; Claude plugins in `claude/plugins.txt` |
| Node, Go, Java | `mise` (honors `.nvmrc`, `.go-version`, `mise.toml`) |
| Python | `uv` |
| Rust | `rustup` |
| Flutter | `fvm` (per-project `.fvmrc`, global stable), Xcode, Android Studio, CocoaPods |
| Containers | Apple `container` + `container-compose`, defaults in `~/.config/container/config.toml` |
| Kubernetes | kubectl + kubecolor, k9s, kubectx/kubens, stern, krew, helm |
| Infrastructure | `tenv` (Terraform/OpenTofu per `.terraform-version`), gcloud |
| Security | Secretive, Bitwarden, Little Snitch, Tailscale |

## Agentic development

- **Shared rules and skills.** `~/.agents/AGENTS.md` holds personal engineering rules (design
  first, TDD with 100% coverage, dependency checks, safety, git) and `~/.agents/skills` holds
  personal skills (`tdd`, `plan-architecture`, `dependency-check`, `systematic-debugging`).
  Codex and pi read both natively; Claude Code reads them through `~/.claude/CLAUDE.md` and
  `~/.claude/skills` symlinks. Review uses the native `/code-review` and `codex review`.
- **One agent per worktree.** `cw <name>` runs `claude --worktree <name>`.
- **herdr inside Ghostty.** Run `herdr` and start agents in its panes. Each pane shows whether
  its agent is working, blocked or idle (`herdr integration install claude`, also `codex` and
  `pi`). `ctrl+b q` detaches; the agents keep running.
- **Ghostty.** Splits with `cmd+d` / `cmd+shift+d`, move with `cmd+alt+h/j/k/l`, zoom with
  `cmd+shift+enter`. Long commands that finish in an unfocused pane send a notification.
  `` cmd+` `` toggles a system-wide quick terminal.
- **From your phone.** Termius with Mosh enabled → `mosh <mac>` over Tailscale → `herdr`.
- **Background agents.** [pulpo](https://github.com/darioblanco/pulpo) runs agents as durable
  tmux sessions with budgets and schedules: `pulpo spawn <name> --workdir . -- claude -p "…"`.
- **Usage.** `ccusage` (or `pulpo usage --scan`) reports token use and cost per agent and repo.

### Keeping the Mac awake

Use **Amphetamine** so you decide each time: turn off "Allow system sleep when display is
closed", keep "Lock screen after inactivity" on, and start a session before closing the lid.
`make awake` / `make sleep` toggle sleep system-wide instead. Don't leave it awake in a closed
bag.

## Security

Coding agents run as you, read untrusted content (READMEs, issues, web pages, dependencies) and
can reach the network. The setup removes what they could leak and limits where data can go.

- **No keys on disk.** SSH keys live in the Secure Enclave (Secretive), one set per device.
  Remote Login accepts public keys only.
- **No long-lived cloud keys.** Prefer `gcloud auth login` and service-account impersonation
  over downloaded key files. Kubernetes uses the GKE auth plugin (short-lived tokens).
- **Claude Code sandbox** (`home/dot_claude/modify_settings.json`, merged into
  `~/.claude/settings.json` without touching other keys):
  - shell commands can't read credential paths (`~/.ssh`, `~/.config/gcloud`, `~/.kube`, `gh`,
    shell history, keychains); Claude's file tools are also denied those paths and `.env` files;
  - outbound traffic is limited to package registries and GitHub; in auto mode any other host
    needs the classifier's approval per command;
  - destructive infrastructure commands (`terraform apply`, `kubectl delete`, `helm upgrade`,
    force pushes…) always ask, even in auto mode;
  - tools that can't run sandboxed (`gh`, `gcloud`, `terraform`, git network commands, Apple
    `container`) are excluded and go through the normal permission flow.
- **No AI attribution.** Claude Code's attribution is off, and a global git commit-msg hook
  strips AI co-author trailers in every repository.
- **Codex** keeps its own default sandbox. **pi** has none: use it for trusted work only.
- **Little Snitch** alerts on new outbound connections from any process.

Use `/sandbox` inside Claude Code to inspect or adjust the policy for a session.

## Layout

| Path | What |
|---|---|
| `Brewfile` | CLI tools, apps, fonts, Mac App Store apps |
| `bootstrap.sh` | Homebrew, Brewfile, dotfiles, toolchains, Claude Code and plugins |
| `home/` | chezmoi source for `$HOME`: zsh, git, ssh, Ghostty, Starship, mise, Atuin, container, Claude Code |
| `home/dot_agents/` | Personal agent rules and skills, shared by Claude Code, Codex and pi |
| `claude/plugins.txt` | Claude Code plugins (kept small: each one costs context) |
| `macos/system.sh` | One-time sudo setup: Xcode, container DNS, SSH server, machine name |
| `macos/defaults.sh` | Finder, Dock, keyboard and trackpad |
| `AGENTS.md` | How coding agents should change this repo |

## Maintenance

```sh
make update     # upgrade Homebrew packages, mise tools, Rust and Python
make diff       # preview dotfile changes
make apply      # apply dotfiles
make check      # lint scripts and configs
make help       # every target
```

Edit dotfiles here, not in `$HOME`. If you changed one in place, `chezmoi re-add <file>` copies it
back.

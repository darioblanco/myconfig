# myconfig

Reproducible macOS setup for terminal-first, agent-assisted development
(iOS/Android/Flutter, Python, Go, Rust, Node, Kubernetes, Terraform).
Everything is idempotent: re-run it whenever you like.

## Bootstrap a new Mac

```sh
xcode-select --install          # Command Line Tools
git clone https://github.com/darioblanco/myconfig ~/Code/darioblanco/myconfig
cd ~/Code/darioblanco/myconfig
make install                    # or: ./bootstrap.sh --defaults
```

`chezmoi` asks for your name, emails and work directory the first time and stores the
answers in `~/.config/chezmoi/chezmoi.toml`. **No personal data lives in this repository.**

Manual steps that need an Apple ID, sudo or a GUI:

- Xcode: `xcodes install <version> --experimental-unxip`, then
  `sudo xcodebuild -license accept && xcodebuild -runFirstLaunch && xcodebuild -downloadPlatform iOS`
- Android Studio: open it once to install the SDK, emulator and command-line tools, then `flutter doctor --android-licenses`
- Casks shipped as `.pkg` (they prompt for your password): `make brew`

## Layout

| Path | What |
|---|---|
| `Brewfile` | CLI tools, apps, fonts, Mac App Store apps |
| `bootstrap.sh` | Installs Homebrew, the Brewfile, dotfiles and toolchains |
| `home/` | chezmoi source for `$HOME` (zsh, git, ssh, Ghostty, Starship, mise, Atuin) |
| `macos/defaults.sh` | Finder, Dock, keyboard and trackpad defaults |

## Toolchain choices

| Need | Tool |
|---|---|
| Shell | zsh + zinit (a few oh-my-zsh snippets), Starship, Atuin, zoxide, fzf |
| Node, Go, Java | `mise` (honors `.nvmrc`, `.go-version`, `mise.toml`) |
| Python | `uv` |
| Rust | `rustup` |
| Flutter | `fvm` (per-project `.fvmrc`) |
| Terraform / OpenTofu | `tenv` (per-project `.terraform-version`) |
| Containers | Apple `container` + `container-compose` |
| Kubernetes | kubectl + kubecolor, k9s, kubectx/kubens, stern, krew, Freelens |

## Agentic development with Ghostty

- One agent per git worktree: `cw <name>` runs `claude --worktree <name>`.
- One Ghostty tab per task; split it (`cmd+d` / `cmd+shift+d`) into agent, `lazygit` and a
  dev-server or test pane. Move between panes with `cmd+alt+h/j/k/l`, zoom with `cmd+shift+enter`.
- Ghostty notifies when a long command finishes in an unfocused pane, so you know when an
  agent is waiting.
- `` cmd+` `` toggles a system-wide quick terminal.
- For durable, budgeted background agents use [pulpo](https://github.com/darioblanco/pulpo):
  `pulpo spawn <name> --workdir . -- claude -p "..."`, then `pulpo ui` or `pulpo usage --scan`.

## Maintenance

```sh
make update   # brew, mise, rustup, uv
make diff     # preview dotfile changes
make apply    # apply dotfiles
make check    # lint
```

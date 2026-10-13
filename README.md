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

Steps that need an Apple ID, sudo or a GUI, in order:

1. `make brew` in a terminal, for casks shipped as `.pkg` (they prompt for your password), and
   `sudo mas install 937984704` (Amphetamine) if the App Store install failed.
2. Xcode: `xcodes install <version> --experimental-unxip` (Apple ID + 2FA). Name the version;
   `--latest` can pick a release candidate.
3. `make system` (sudo): selects the newest Xcode, accepts its license, downloads the iOS
   platform and creates the `test` DNS domain so containers resolve each other by name.
   Add `MACHINE_NAME=<name>` to rename the Mac; also rename it in the Tailscale admin console.
4. Android Studio: open it once and finish the setup wizard (installs the SDK and emulator and
   accepts the licenses), then `flutter doctor --android-licenses`.
5. System Settings → General → Sharing → Remote Login, to reach the Mac over Tailscale with SSH.
6. `make defaults` for Finder, Dock, keyboard and trackpad (three-finger drag). Log out and back in.

## Layout

| Path | What |
|---|---|
| `Brewfile` | CLI tools, apps, fonts, Mac App Store apps |
| `bootstrap.sh` | Installs Homebrew, the Brewfile, dotfiles and toolchains |
| `home/` | chezmoi source for `$HOME` (zsh, git, ssh, Ghostty, Starship, mise, Atuin) |
| `macos/defaults.sh` | Finder, Dock, keyboard and trackpad defaults |
| `macos/system.sh` | One-time sudo setup: Xcode selection, container DNS, machine name |

## Toolchain choices

| Need | Tool |
|---|---|
| Shell | zsh + zinit (a few oh-my-zsh snippets), Starship, Atuin, zoxide, fzf |
| Node, Go, Java | `mise` (honors `.nvmrc`, `.go-version`, `mise.toml`) |
| Python | `uv` |
| Rust | `rustup` |
| Flutter | `fvm` (per-project `.fvmrc`) |
| Terraform / OpenTofu | `tenv` (per-project `.terraform-version`) |
| Containers | Apple `container` + `container-compose`; defaults in `~/.config/container/config.toml` |
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

## Keeping the Mac awake for remote agents

`make awake` disables sleep entirely, even with the lid closed and on battery, so agent sessions
keep running and stay reachable over Tailscale. `make sleep` restores normal behaviour. Don't
leave it awake in a closed bag: it keeps running hot until the battery dies.

## Maintenance

```sh
make update   # brew, mise, rustup, uv
make diff     # preview dotfile changes
make apply    # apply dotfiles
make check    # lint
```

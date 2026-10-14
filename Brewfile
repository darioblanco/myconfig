# Brewfile — `brew bundle --file=Brewfile`
# Language runtimes are NOT installed here: they are managed by mise (see mise config),
# uv (Python), rustup (Rust) and fvm (Flutter) so every project can pin its own versions.

tap "darioblanco/tap"

# ── Shell & terminal ────────────────────────────────────────────────────────────
brew "zsh"
brew "zinit"
brew "starship"          # prompt
brew "atuin"             # shell history (SQLite, fuzzy search)
brew "zoxide"            # smarter cd
brew "fzf"
brew "eza"               # ls
brew "bat"               # cat
brew "ripgrep"
brew "fd"
brew "git-delta"         # git diffs
brew "lazygit"
brew "yazi"              # file manager
brew "herdr"             # agent-aware terminal multiplexer (runs inside Ghostty)
brew "mosh"              # roaming SSH for phone access (Termius)
brew "neovim"
brew "tlrc"              # tldr pages
brew "jq"
brew "yq"
brew "wget"
brew "watch"
cask "ghostty"

# ── Dev tooling ────────────────────────────────────────────────────────────────
brew "git"
brew "git-lfs"
brew "gh"
brew "chezmoi"           # dotfiles
brew "mise"              # node, go, java, ruby... per-project versions + env
brew "uv"                # python
brew "rustup"
brew "shellcheck"
brew "shfmt"
brew "actionlint"
brew "darioblanco/tap/pulpo"   # durable, metered coding-agent sessions
brew "ccusage"            # Claude / Codex usage and cost reports

# ── Containers ─────────────────────────────────────────────────────────────────
brew "container"         # Apple's native Linux containers
brew "container-compose" # docker-compose.yml on top of `container`

# ── Infrastructure & Kubernetes ────────────────────────────────────────────────
brew "tenv"              # terraform / opentofu version manager (.terraform-version)
brew "kubernetes-cli"
brew "kubecolor"
brew "kubectx"           # kubectx + kubens
brew "k9s"               # cluster TUI
brew "stern"             # multi-pod logs
brew "helm"
brew "kubeconform"
cask "gcloud-cli"

# ── Mobile ─────────────────────────────────────────────────────────────────────
brew "mas"
brew "xcodes"
brew "aria2"             # faster xcodes downloads
brew "fvm"               # flutter versions
brew "cocoapods"
cask "android-studio"

# ── Coding agents ─────────────────────────────────────────────────────────────
# Claude Code itself uses Anthropic's native installer (auto-updates); see bootstrap.sh.
cask "codex"
brew "pi-coding-agent"
cask "claude"
# Language servers for the Claude Code LSP plugins (rust-analyzer comes from rustup).
brew "pyright"
brew "typescript-language-server"
brew "gopls"

# ── Apps ──────────────────────────────────────────────────────────────────────
cask "bitwarden"
cask "secretive"        # SSH keys in the Secure Enclave
cask "raycast"
cask "tailscale-app"
cask "logi-options+"
cask "little-snitch"
cask "keka"
cask "iina"
cask "firefox"
cask "google-drive"
cask "figma"
cask "miro"
cask "linear"
cask "notion"
cask "slack"
cask "zoom"
cask "discord"
cask "signal"
cask "telegram"
cask "whatsapp"
cask "spotify"
cask "plex"              # client only
cask "steam"
cask "battle-net"

# ── Fonts ─────────────────────────────────────────────────────────────────────
cask "font-jetbrains-mono-nerd-font"

# ── Mac App Store ─────────────────────────────────────────────────────────────
mas "Amphetamine", id: 937984704

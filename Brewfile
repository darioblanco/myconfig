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
brew "tmux"              # durable sessions (used by pulpo)
brew "neovim"
brew "tlrc"              # tldr pages
brew "jq"
brew "yq"
brew "wget"
brew "watch"
brew "tree"
cask "ghostty"

# ── Dev tooling ────────────────────────────────────────────────────────────────
brew "git"
brew "git-lfs"
brew "gh"
brew "chezmoi"           # dotfiles
brew "mise"              # node, go, java, ruby... per-project versions + env
brew "uv"                # python
brew "rustup"
brew "gnupg"
brew "age"
brew "sops"
brew "shellcheck"
brew "shfmt"
brew "actionlint"
brew "yamllint"
brew "graphviz"
brew "nmap"
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
brew "krew"              # kubectl plugins
brew "helm"
brew "kustomize"
brew "kubeconform"
brew "flux"
brew "argocd"
brew "kind"
brew "hcloud"
cask "gcloud-cli"
cask "freelens"          # Kubernetes GUI (successor of Lens)

# ── Mobile ─────────────────────────────────────────────────────────────────────
brew "mas"
brew "xcodes"
brew "aria2"             # faster xcodes downloads
brew "fvm"               # flutter versions
brew "cocoapods"
brew "fastlane"
cask "android-studio"

# ── Editors & AI ──────────────────────────────────────────────────────────────
cask "visual-studio-code"
cask "zed"
cask "claude"

# ── Apps ──────────────────────────────────────────────────────────────────────
cask "bitwarden"
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
cask "notion"
cask "slack"
cask "zoom"
cask "discord"
cask "signal"
cask "telegram"
cask "whatsapp"
cask "spotify"
cask "plex"
cask "steam"
cask "battle-net"

# ── Fonts ─────────────────────────────────────────────────────────────────────
cask "font-jetbrains-mono-nerd-font"
cask "font-fira-code-nerd-font"

# ── Mac App Store ─────────────────────────────────────────────────────────────
mas "Amphetamine", id: 937984704
mas "Xcode", id: 497799835

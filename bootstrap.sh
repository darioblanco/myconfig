#!/usr/bin/env bash
# Bootstrap a macOS machine from this repo. Idempotent: re-run it any time.
#   ./bootstrap.sh            install everything and apply dotfiles
#   ./bootstrap.sh --defaults also apply macOS defaults (macos/defaults.sh)
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

step "Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
	xcode-select --install
	echo "Finish the Command Line Tools installer, then re-run this script."
	exit 1
fi

step "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

step "Brewfile"
brew tap darioblanco/tap && brew trust darioblanco/tap
# Casks shipped as .pkg ask for sudo; a failure here should not stop the rest.
brew bundle --file="$repo/Brewfile" || echo "Some Brewfile entries failed; re-run 'make brew' in a terminal."

step "Dotfiles (chezmoi)"
chezmoi init --apply --source="$repo"

step "Rust"
rustup toolchain install stable --profile default
rustup component add clippy rustfmt rust-analyzer

step "mise tools (node, pnpm, bun, go, java)"
mise install --yes

step "gcloud components"
gcloud components install gke-gcloud-auth-plugin -q

step "Python (uv)"
uv python install

if [[ "${1:-}" == "--defaults" ]]; then
	step "macOS defaults"
	"$repo/macos/defaults.sh"
fi

step "Done. Open a new terminal (or run 'exec zsh')."

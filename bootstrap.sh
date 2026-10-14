#!/usr/bin/env bash
# Bootstrap a macOS machine from this repo. Idempotent: re-run it any time.
#   ./bootstrap.sh            install everything and apply dotfiles
#   ./bootstrap.sh --defaults also apply macOS defaults (macos/defaults.sh)
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
# Run a step only if its tool exists, so one failed Brewfile entry doesn't stop the rest.
have() {
	command -v "$1" >/dev/null 2>&1 && return 0
	echo "  skipped: $1 is not installed"
	return 1
}

step "Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
	xcode-select --install
	echo "Finish the Command Line Tools installer, then re-run this script."
	exit 1
fi

step "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
	# The installer needs sudo but can't prompt in NONINTERACTIVE mode: ask once up front.
	sudo -v
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
# rustup is keg-only, and Claude Code installs to ~/.local/bin.
export PATH="/opt/homebrew/opt/rustup/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

step "Brewfile"
# Homebrew refuses formulae from taps it doesn't trust; trust the ones the Brewfile declares.
awk -F'"' '/^tap /{print $2}' "$repo/Brewfile" | while read -r tap; do
	brew tap "$tap" && brew trust "$tap"
done
# Upgrades belong to `make update`. Casks shipped as .pkg ask for sudo, so a failure here
# should not stop the rest.
brew bundle --no-upgrade --file="$repo/Brewfile" ||
	echo "Some Brewfile entries failed; re-run 'make brew' in a terminal."

step "Dotfiles (chezmoi)"
chezmoi init --apply --source="$repo"
# Clone the zsh plugins now instead of on the first interactive shell.
zsh -ic exit >/dev/null 2>&1 || true

step "Rust"
if have rustup; then
	rustup toolchain install stable --profile default
	rustup component add clippy rustfmt rust-analyzer
fi

step "mise tools (node, pnpm, go, java)"
if have mise; then mise install --yes; fi

step "Flutter (fvm)"
if have fvm; then
	fvm install stable --setup
	fvm global stable
fi

step "Android SDK"
# Needs the licenses accepted once by a human (see README); after that this is idempotent.
android_sdk="$HOME/Library/Android/sdk"
if [[ -f "$android_sdk/licenses/android-sdk-license" ]] && have sdkmanager && have mise; then
	JAVA_HOME="$(mise where java@temurin-17)" sdkmanager --sdk_root="$android_sdk" \
		"cmdline-tools;latest" "platform-tools" "emulator" "platforms;android-36" \
		"build-tools;36.1.0" "system-images;android-36;google_apis;arm64-v8a" >/dev/null
	avdmanager="$android_sdk/cmdline-tools/latest/bin/avdmanager"
	if ! JAVA_HOME="$(mise where java@temurin-17)" "$avdmanager" list avd -c | grep -qx pixel_api36; then
		echo no | JAVA_HOME="$(mise where java@temurin-17)" "$avdmanager" create avd -n pixel_api36 \
			-k "system-images;android-36;google_apis;arm64-v8a" -d pixel_8 >/dev/null
	fi
	echo "  SDK and emulator pixel_api36 ready"
else
	echo "  skipped: accept the Android SDK licenses first (see README)"
fi

step "Python (uv)"
if have uv; then uv python install; fi

step "gcloud components"
if have gcloud; then gcloud components install gke-gcloud-auth-plugin -q; fi

step "Claude Code"
if ! command -v claude >/dev/null 2>&1; then
	curl -fsSL https://claude.ai/install.sh | bash
fi

step "Claude Code plugins"
grep -vE '^\s*(#|$)' "$repo/claude/plugins.txt" | while read -r plugin marketplace; do
	claude plugin marketplace add "$marketplace" >/dev/null 2>&1 || true
	if claude plugin install "$plugin" >/dev/null 2>&1; then
		echo "  $plugin"
	else
		echo "  FAILED: $plugin"
	fi
done

step "herdr agent status"
if have herdr; then
	for agent in claude codex pi; do
		if herdr integration install "$agent" >/dev/null 2>&1; then
			echo "  $agent"
		else
			echo "  FAILED: $agent"
		fi
	done
fi

if [[ "${1:-}" == "--defaults" ]]; then
	step "macOS defaults"
	"$repo/macos/defaults.sh"
fi

step "Done. Open a new terminal (or run 'exec zsh')."

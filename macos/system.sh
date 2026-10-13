#!/usr/bin/env bash
# One-time system setup that needs sudo. Safe to re-run.
#   ./macos/system.sh            Xcode + container DNS
#   MACHINE_NAME=Name ./macos/system.sh   also renames the Mac
set -euo pipefail

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

if [[ -n "${MACHINE_NAME:-}" ]]; then
	step "Machine name: $MACHINE_NAME"
	sudo scutil --set ComputerName "$MACHINE_NAME"
	sudo scutil --set LocalHostName "$MACHINE_NAME"
	sudo scutil --set HostName "$MACHINE_NAME"
fi

# Newest installed Xcode (xcodes installs them as /Applications/Xcode-<version>.app).
xcode="$(find /Applications -maxdepth 1 -name 'Xcode*.app' | sort -V | tail -1)"
if [[ -n "$xcode" ]]; then
	step "Xcode: $xcode"
	if [[ "$(xcode-select -p)" != "$xcode/Contents/Developer" ]]; then
		sudo xcode-select -s "$xcode"
	fi
	sudo xcodebuild -license accept
	sudo xcodebuild -runFirstLaunch
	if ! xcrun simctl list runtimes | grep -q '^iOS'; then
		xcodebuild -downloadPlatform iOS
	fi
else
	echo "No Xcode found. Install one with: xcodes install <version> --experimental-unxip"
fi

if command -v container >/dev/null 2>&1; then
	step "container DNS domain"
	if ! container system dns ls -q | grep -qx test; then
		sudo container system dns create test
	fi
	container system stop >/dev/null 2>&1 || true
	container system start --enable-kernel-install
fi

# Remote Login: public keys only (sshd uses the first value it reads, and 000- sorts first).
sshd_conf=/etc/ssh/sshd_config.d/000-keys-only.conf
if [[ ! -f "$sshd_conf" ]]; then
	step "SSH server: keys only"
	printf '%s\n' 'PasswordAuthentication no' 'KbdInteractiveAuthentication no' 'PermitRootLogin no' |
		sudo tee "$sshd_conf" >/dev/null
	sudo sshd -t
fi

step "Done."

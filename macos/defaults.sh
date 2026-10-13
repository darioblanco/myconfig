#!/usr/bin/env bash
# Opinionated macOS defaults. Safe to re-run. Some changes need a logout.
set -euo pipefail

# Finder: show hidden files, all extensions, path bar; no extension-change warning.
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
# No .DS_Store on network and USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock: only running apps, auto-hide, no recents.
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false

# Keyboard: fast key repeat; keep press-and-hold accents (hold e → é); no auto-substitutions.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Trackpad: tap to click, and drag with drag lock: double-tap and hold to grab, lift the finger
# and keep moving, tap again to drop (Accessibility > Pointer Control > Trackpad Options >
# Dragging style > With Drag Lock). Dragging styles are exclusive, so three-finger drag is off.
for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
	defaults write "$domain" Clicking -bool true
	defaults write "$domain" Dragging -bool true
	defaults write "$domain" DragLock -bool true
	defaults write "$domain" TrackpadThreeFingerDrag -bool false
done
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Screenshots in ~/Pictures/Screenshots.
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

killall Finder Dock SystemUIServer 2>/dev/null || true
echo "macOS defaults applied (some need a logout)."

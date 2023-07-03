#!/usr/bin/env bash
# Configure installed applications
# Author: Dario Blanco (dblancoit@gmail.com)

set -o errexit
set -o nounset
set -o pipefail

# shellcheck source=utils.sh
source utils.sh
cwd=$(pwd)

trap exit_gracefully INT

function install_xcode_clt() {
	if xcode-select -p > /dev/null; then
		print_yellow "XCode Command Line Tools already installed"
	else
		print_blue "Installing XCode Command Line Tools..."
		xcode-select --install
		print_green "XCode installed successfully"
	fi
}

function install_homebrew() {
	export HOMEBREW_CASK_OPTS="--appdir=/Applications"
	if hash brew &>/dev/null; then
		print_yellow "Homebrew already installed. Getting updates and package upgrades..."
		brew update
		brew upgrade
	else
		print_blue "Installing homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		(echo; echo "eval \"$(/opt/homebrew/bin/brew shellenv)\"") >> ~/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
		brew update
		print_green "Homebrew installed successfully"
	fi
	brew bundle install --no-lock --file="${cwd}/Brewfile"
	print_green "Homebrew apps installed successfully"
}

function install_python_packages() {
	print_blue "Installing Python packages..."
	pip3 install -r "${cwd}/requirements.txt" --quiet
	print_green "Essential Python packages installed successfully"
}

function install_node() {
	if hash node &>/dev/null; then
		print_yellow "Node already installed"
	else
		print_blue "Installing latest node version (requires admin password)..."
		sudo n latest
		print_green "Latest node version installed successfully"
	fi
}

function install_rust() {
	export PATH="$HOME/.cargo/bin:$PATH"
	if hash rustup &>/dev/null; then
		print_yellow "Rust already installed"
	else
		print_blue "Installing Rust..."
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
		print_green "Rust installed successfully"
	fi
	print_blue "Checking for Rust updates..."
	rustup -q update
	print_blue "Installing essential Rust components..."
	rustup component add clippy rustfmt
	print_green "Rust components installed successfully"
}

function configure_zsh() {
	if [[ ! -f ~/.zshrc ]]; then
		print_blue "Configuring zsh + and configure oh-my-zsh and its bundles via antigen..."
		cp files/.zshrc ~/.zshrc
		cp files/.antigenrc ~/.antigenrc
		chsh -s /bin/zsh
	else
		print_yellow "zsh + antigen + oh my zsh already installed"
	fi
}

function configure_iterm() {
	read -r -p "👉 Do you want to configure iTerm? [y/n]: " configure_iterm
	if [[ $configure_iterm =~ ^[yY] ]]; then
		if [[ ! -f ~/Library/Application\ Support/iTerm2/DynamicProfiles/iTermProfiles.json ]]; then
			print_blue "Copying iTerm2 profiles..."
			mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles/
			cp files/iTermProfiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/
		else
			print_yellow "iTerm2 custom profile is already installed"
		fi
	else
		print_yellow "iTerm configuration skipped"
	fi
}

function configure_vscode() {
	read -r -p "👉 Do you want to configure VSCode? [y/n]: " configure_vscode
	if [[ $configure_vscode =~ ^[yY] ]]; then
		if hash code &>/dev/null; then
			print_blue "Installing Visual Studio Code extensions..."
			while IFS="" read -r i || [ -n "$i" ]
			do
				if code --list-extensions | grep "$i" > /dev/null; then
					print_yellow "Extension $i is already installed"
				else
					code --install-extension "$i"
				fi
			done < "${cwd}/vscode-extensions.txt"
		fi
		if [[ ! -f ~/Library/Application\ Support/Code/User/settings.json ]]; then
			print_blue "Creating Visual Studio Code user settings..."
			cp files/CodeSettings.json ~/Library/Application\ Support/Code/User/settings.json
		else
			print_yellow "Visual Studio Code user settings are already defined"
		fi
	else
		print_yellow "VSCode configuration skipped"
	fi
}

function configure_macos_defaults() {
	read -r -p "👉 Do you want to configure MacOS defaults? [y/n]:  " configure_macos
	if [[ $configure_macos =~ ^[yY] ]]; then
		print_blue "Configuring MacOS settings (requires a logout/restart to be reflected)..."
		# Show hidden files inside the finder
		defaults write com.apple.Finder "AppleShowAllFiles" -bool true
		# Show all file extensions inside the finder
		defaults write NSGlobalDomain "AppleShowAllExtensions" -bool true
		# Do not show warning when changing the file extension
		defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
		# Show path bar
		defaults write com.apple.finder ShowPathbar -bool true
		# Have the Dock show only active apps
		defaults write com.apple.dock static-only -bool true
		# Tap to click
		defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
		defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
		# Drag without drag lock (tap and a half to drag)
		defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -int 1
		defaults write com.apple.AppleMultitouchTrackpad Dragging -int 1
		# Three finger drag
		defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
		defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
		# Secondary click in external mouse
		defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string "TwoButton"
		print_green "MacOS settings configured successfully"
	else
		print_yellow "MacOS settings configuration skipped"
	fi
}

function configure_ssh() {
	if [[ ! -d ~/.ssh ]]; then
		print_blue "Defining SSH folder structure..."
		mkdir ~/.ssh
		cp files/sshconfig ~/.ssh/config
		chmod 700 ~/.ssh
		chmod 644 ~/.ssh/config
		touch ~/.ssh/known_hosts
		chmod 644 ~/.ssh/known_hosts
		ssh-keygen -t ed25519 -f ~/.ssh/id_rsa -C "$(whoami)@$(hostname)"
		ssh-add --apple-use-keychain ~/.ssh/id_rsa
		eval "$(ssh-agent -s)"
	else
		print_yellow "SSH folder structure already defined"
	fi
}

function configure_vim() {
	if [[ ! -f ~/.vimrc ]]; then
		print_blue "Applying vimrc configuration..."
		cp files/.vimrc ~/.vimrc
	else
		print_yellow "Vimrc configuration already applied"
	fi
}

function configure_git() {
	if [[ ! -f ~/.gitconfig ]]; then
		print_blue "Applying Git configuration..."
		cp files/.gitconfig ~/.gitconfig
	else
		print_yellow "Git configuration already applied"
	fi
}

function main() {
	echo ""
	echo "🚀 MacOS Config - Darío Blanco Iturriaga"
	echo ""
	echo "   To stop the script at any time press Ctrl+C"
	echo "   👉 Press Enter to start!"
	echo ""

	read -r _

	install_xcode_clt
	install_homebrew
	install_python_packages
	install_node
	install_rust

	configure_zsh
	configure_ssh
	configure_vim
	configure_git
	configure_iterm
	configure_vscode
	configure_macos_defaults

	echo ""
	echo "Success! 🥳🥳🥳🥳🥳"
	echo "🏁 Restart your terminal to reload your updated shell profile (or just type 'zsh')"
}

main

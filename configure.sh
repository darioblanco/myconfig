#!/usr/bin/env bash
# Configure installed applications
# Author: Dario Blanco (dblancoit@gmail.com)

set -o errexit
set -o nounset
set -o pipefail

# shellcheck source=utils.sh
. utils.sh
# shellcheck source=install.sh
. install.sh

trap exit_gracefully INT

vscode_extensions=(
  4ops.terraform
  alefragnani.project-manager
  arcanis.vscode-zipfs
  DavidAnson.vscode-markdownlint
  dbaeumer.vscode-eslint
  eamodio.gitlens
  esbenp.prettier-vscode
  hashicorp.terraform
  humao.rest-client
  mikestead.dotenv
  ms-azuretools.vscode-docker
  ms-kubernetes-tools.vscode-kubernetes-tools
  ms-python.python
  ms-vscode-remote.remote-containers
  ms-vscode.sublime-keybindings
  redhat.vscode-yaml
  shd101wyy.markdown-preview-enhanced
  streetsidesoftware.code-spell-checker
  timonwong.shellcheck
  yzhang.markdown-all-in-one
  ZainChen.json
  zxh404.vscode-proto3
)

function configure_macos_defaults() {
  print_blue "Configuring MacOS settings (requires a logout/restart to be reflected)..."
  # Show hidden files inside the finder
  defaults write com.apple.Finder "AppleShowAllFiles" -bool true
  # Show all file extensios inside the finder
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
}

function configure_zsh() {
  if [[ ! -f ~/.zshrc ]]; then
    print_blue "Installing oh my zsh..."
    ZSH=~/.oh-my-zsh ZSH_DISABLE_COMPFIX=true sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chmod 744 ~/.oh-my-zsh/oh-my-zsh.sh
    print_blue "Installing oh my zsh extra plugins..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    print_blue "Creating .zshrc file..."
    cp files/.zshrc ~/.zshrc
    chsh -s /bin/zsh
  else
    print_yellow "OhMyZsh already installed"
  fi

  if [[ ! -f ~/.p10k.zsh ]]; then
    print_blue "Installing powerlevel10k theme for OhMyZsh"
    echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
    # shellcheck source=/dev/null
    /bin/zsh -i -c "p10k configure"
  else
    print_yellow "Powerlevel10k theme for OhMyZsh already installed"
  fi
}

function configure_iterm() {
  if [[ ! -f ~/Library/Application\ Support/iTerm2/DynamicProfiles/iTermProfiles.json ]]; then
    print_blue "Copying iTerm2 profiles..."
    cp files/iTermProfiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/
  else
    print_yellow "iTerm2 custom profile is already installed"
  fi
}

function configure_vscode() {
  if hash code &>/dev/null; then
    print_blue "Installing Visual Studio Code extensions..."
    for i in "${vscode_extensions[@]}"; do
      if code --list-extensions | grep "$i" > /dev/null; then
        print_yellow "Extension $i is already installed"
      else
        code --install-extension "$i"
      fi
    done
  fi
  if [[ ! -f ~/Library/Application\ Support/Code/User/settings.json ]]; then
    print_blue "Creating Visual Studio Code user settings..."
    cp files/CodeSettings.json ~/Library/Application\ Support/Code/User/settings.json
  else
    print_yellow "Visual Studio Code user settings are already defined"
  fi
}

function configure_ssh() {
  if [[ ! -d ~/.ssh ]]; then
    print_blue "Defining SSH folder structure..."
    mkdir ~/.ssh
    cp files/sshconfig ~/.ssh/config
    chmod 700 ~/.ssh
    chmod 644 ~/.ssh/config
    touch ~/.ssh/authorized_keys
    chmod 644 ~/.ssh/authorized_keys
    touch ~/.ssh/known_hosts
    chmod 644 ~/.ssh/known_hosts
    ssh-keygen -t rsa -f ~/.ssh/id_rsa
  else
    print_yellow "SSH folder structury already defined"
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

function configure_git () {
  if [[ ! -f ~/.gitconfig ]]; then
    print_blue "Applying Git configuration..."
    cp files/.gitconfig ~/.gitconfig
  else
    print_yellow "Git configuration already applied"
  fi
}

function main() {
  print_green "Configuring development environment..."
  install_xcode_clt
  install_homebrew
  install_packages
  install_fonts
  configure_macos_defaults
  configure_zsh
  configure_iterm
  configure_vscode
  configure_ssh
  configure_vim
  configure_git
  print_green "Development environment configured"
}

main

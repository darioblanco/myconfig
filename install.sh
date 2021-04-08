#!/usr/bin/env bash
# Install essential packages, fonts, programming language dependencies and MacOS applications
# Author: Dario Blanco (dblancoit@gmail.com)

set -o errexit
set -o nounset
set -o pipefail

# shellcheck source=utils.sh
. utils.sh

trap exit_gracefully INT

function install_xcode_clt() {
  if xcode-select -p > /dev/null; then
    print_yellow "XCode Command Line Tools already installed"
  else
    print_blue "Installing XCode Command Line Tools..."
    xcode-select --install
  fi
}

function install_homebrew() {
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
  if hash brew &>/dev/null; then
    print_yellow "Homebrew already installed. Getting updates..."
    brew update
    brew doctor
  else
    print_blue "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew update
  fi
}

function install_packages() {
  PACKAGES=(
    bash-completion
    bash-git-prompt
    curl
    exa
    gettext
    graphviz
    gh
    git
    google-cloud-sdk
    helm
    jq
    kubectx
    kubernetes-cli
    markdown
    nmap
    openjdk
    openssl
    pipenv
    pulumi
    python3
    romkatv/powerlevel10k/powerlevel10k
    ruby
    shellcheck
    thefuck
    tmux
    tree
    vim
    wget
    yamllint
    yarn
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
  )
  print_blue "Installing MacOS and Linux packages..."
  brew install "${PACKAGES[@]}"
  brew cleanup
}

function install_fonts() {
  print_blue "Installing fonts..."
  brew tap homebrew/cask-fonts
  FONTS=(
    font-consolas-for-powerline
    font-fira-code-nerd-font
    font-fira-code
    font-inconsolata-for-powerline
    font-inconsolata-nerd-font
    font-inconsolata
    font-menlo-for-powerline
    font-meslo-lg-dz
    font-meslo-lg-nerd-font
    font-meslo-lg
  )
  brew install "${FONTS[@]}"
}

function install_quicklook_plugins() {
  print_blue "Installing QuickLook Plugins..."
  QUICKLOOK_PLUGINS=(
    qlmarkdown
    qlprettypatch
    qlstephen
    qlimagesize
    quicklook-csv
    quicklook-json
  )
  brew install --cask "${QUICKLOOK_PLUGINS[@]}"
}

function install_macos_apps() {
  print_blue "Installing MacOS apps..."
  APPS=(
    alfred
    bitwarden
    caffeine
    calibre
    discord
    docker
    figma
    firefox
    github
    grammarly
    google-chrome
    iterm2
    keka
    kindle
    little-snitch
    miro
    postman
    slack
    signal
    spotify
    steam
    telegram
    visual-studio-code
    vlc
    whatsapp
    zoom
  )
  brew tap homebrew/cask
  brew install --cask "${APPS[@]}"
}

function install_python_packages() {
  if pip3 freeze | grep virtualenv > /dev/null; then
    print_yellow "Essential python packages are already installed"
  else
    print_blue "Installing Python packages (requires admin password)..."
    PYTHON_PACKAGES=(
      virtualenv
      virtualenvwrapper
    )
    sudo pip3 install "${PYTHON_PACKAGES[@]}"
  fi
}

function install_ruby_gems() {
  if [[ $(gem list | grep -e bundler -e rake -c) -ge 2 ]]; then
    print_yellow "Essential ruby packages are already installed"
  else
    print_blue "Installing Ruby gems (requires admin password)..."
    RUBY_GEMS=(
      bundler
      rake
    )
    sudo gem install "${RUBY_GEMS[@]}"
  fi
}

function main() {
  print_green "Installing essential packages, fonts, programming language dependencies and MacOS applications..."
  install_xcode_clt
  install_homebrew
  install_packages
  install_fonts
  install_quicklook_plugins
  install_macos_apps
  install_python_packages
  install_ruby_gems
  print_green "Installation successful"
}

main

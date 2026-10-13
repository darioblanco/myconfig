.DEFAULT_GOAL := help
SHELL := /usr/bin/env bash
SCRIPTS := bootstrap.sh macos/*.sh home/dot_local/bin/executable_* home/dot_claude/modify_* home/dot_codex/modify_*

.PHONY: help install system brew apply diff update defaults awake sleep check

help: ## list available commands
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## bootstrap the machine (idempotent)
	./bootstrap.sh

brew: ## install everything in the Brewfile
	brew bundle --file=Brewfile

apply: ## apply dotfiles to $HOME
	chezmoi apply --verbose

diff: ## show what `apply` would change in $HOME
	chezmoi diff

update: ## upgrade packages and toolchains
	brew update && brew bundle --file=Brewfile --upgrade
	mise upgrade --yes
	rustup update
	uv python upgrade

system: ## one-time sudo setup: Xcode, container DNS (MACHINE_NAME=Name to rename the Mac)
	./macos/system.sh

defaults: ## apply macOS defaults (Finder, Dock, keyboard, trackpad)
	./macos/defaults.sh

awake: ## never sleep, even with the lid closed (for remote agent sessions)
	sudo pmset -a disablesleep 1
	@pmset -g | grep -i sleepdisabled

sleep: ## restore normal sleep
	sudo pmset -a disablesleep 0
	@pmset -g | grep -i sleepdisabled

check: ## lint scripts and configs
	shellcheck $(SCRIPTS)
	shfmt -d $(SCRIPTS)
	actionlint
	ghostty +validate-config --config-file=home/dot_config/ghostty/config
	claude plugin validate home/dot_agents/skills

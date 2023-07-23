# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Antigen
source $(brew --prefix)/share/antigen/antigen.zsh

# Load Antigen configurations
antigen init ~/.antigenrc

# Load autocompletions
source <(kubectl completion zsh)
source <(k3d completion zsh)

# Load google cloud client requirements
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# iTerm bindings
# changes hex 0x15 to delete everything to the left of the cursor, rather than the whole line
bindkey "^U" backward-kill-line
# binds hex 0x18 0x7f with deleting everything to the left of the cursor
bindkey "^X\\x7f" backward-kill-line
# adds redo
bindkey "^X^_" redo

# Git Conventional Commits
#   Examples:
#     `git style "remove trailing whitespace"` -> `git commit -m "style: remove trailing whitespace"`
#     `git fix -s "router" "correct redirect link"` -> `git commit -m "fix(router): correct redirect link"`
_register() {
  if ! git config --global --get-all alias.$1 &>/dev/null; then
    git config --global alias.$1 '!a() { if [[ "$1" == "-s" || "$1" == "--scope" ]]; then git commit -m "'$1'(${2}): ${@:3}"; else git commit -m "'$1': ${@}"; fi }; a'
  fi
}
git_aliases=(
  'build'
  'chore'
  'ci'
  'docs'
  'feat'
  'fix'
  'perf'
  'refactor'
  'revert'
  'style'
  'test'
)
for git_alias in "${git_aliases[@]}"; do
  _register $git_alias
done

# Docker to podman
alias docker=podman

# Locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Path modification
export PATH="/opt/homebrew/bin:$PATH"
export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# Hook direnv
eval "$(direnv hook zsh)"

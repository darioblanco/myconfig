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

# Load Kubectl autocompletion
source <(kubectl completion zsh)

# iTerm bindings
# changes hex 0x15 to delete everything to the left of the cursor, rather than the whole line
bindkey "^U" backward-kill-line
# binds hex 0x18 0x7f with deleting everything to the left of the cursor
bindkey "^X\\x7f" backward-kill-line
# adds redo
bindkey "^X^_" redo

# Git Conventional Commits
function gc() {
if [ -z "$3" ]
  then
    git commit -m "$1: $2"
  else
    git commit -m "$1($2): $3"
  fi
}
alias gitrefactor="gc refactor"
alias gittest="gc test"
alias gitfix="gc fix"
alias gitfeat="gc feat"
alias gitci="gc ci"
alias gitchore="gc chore"
alias gitbuild="gc build"
if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias la="exa --long --all --group"
fi

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

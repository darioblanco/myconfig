# Load Antigen
source $(brew --prefix)/share/antigen/antigen.zsh

# Load Antigen configurations
antigen init ~/.antigenrc

# iTerm bindings
# changes hex 0x15 to delete everything to the left of the cursor, rather than the whole line
bindkey "^U" backward-kill-line
# binds hex 0x18 0x7f with deleting everything to the left of the cursor
bindkey "^X\\x7f" backward-kill-line
# adds redo
bindkey "^X^_" redo

# Aliases
function gc-s() {
if [ -z "$3" ]
  then
    git commit -m "$1: $2"
  else
    git commit -m "$1($2): $3"
  fi
}
alias gitrefactor="gc-s refactor"
alias gittest="gc-s test"
alias gitfix="gc-s fix"
alias gitfeat="gc-s feat"
alias gitci="gc-s ci"
alias gitchore="gc-s chore"
alias gitbuild="gc-s build"
if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias la="exa --long --all --group"
fi

# Locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Path modification
export PATH="/opt/homebrew/bin:$PATH"

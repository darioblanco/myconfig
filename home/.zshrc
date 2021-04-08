# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(alias-finder brew cp docker-compose docker git gcloud github history kubectl npm node osx redis-cli sudo terraform tmux zsh-completions virtualenv yarn zsh-interactive-cd zsh-navigation-tools)

source $ZSH/oh-my-zsh.sh

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

# Set locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# VIRTUALENV
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
export PROJECT_HOME=$HOME/Programming
source /usr/local/bin/virtualenvwrapper.sh

# PATH additions
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$(which python3):$PATH"

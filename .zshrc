##########################################################################
# ZSHRC
##########################################################################

##########################################################################
# ZGEN
##########################################################################

source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then

  zgen load mafredri/zsh-async
  zgen load sindresorhus/pure

# generate the init script from plugins above
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-completions src
  zgen load /usr/local/share/zsh/site-functions

  zgen load mollifier/anyframe
  zgen load unixorn/warhol.plugin.zsh
  zgen oh-my-zsh plugins/thefuck

  zgen oh-my-zsh plugins/pip
  zgen oh-my-zsh plugins/python
  zgen oh-my-zsh plugins/pyenv

  zgen oh-my-zsh plugins/rbenv

  zgen oh-my-zsh plugins/sudo
  zgen save
fi

##########################################################################
# EXPORT
##########################################################################

typeset -U path

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Don't send analytics
export HOMEBREW_NO_ANALYTICS=1

export EDITOR="/usr/bin/vim"

##########################################################################
# SETOPT
##########################################################################

setopt auto_cd
setopt auto_menu
setopt auto_pushd
setopt list_packed
setopt list_types

setopt nobeep

REPORTTIME=3

##########################################################################
# BINDKEY
##########################################################################

bindkey -e

bindkey '^x^r'  anyframe-widget-put-history
bindkey '^x^gc' anyframe-widget-checkout-git-branch
bindkey '^x^gi' anyframe-widget-insert-git-branch
bindkey '^x^f'  anyframe-widget-insert-filename
bindkey '^x^ta' anyframe-widget-tmux-attach

##########################################################################
# HISTORY
##########################################################################

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_nodups

##########################################################################
# 
##########################################################################


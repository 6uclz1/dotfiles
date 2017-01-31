##########################################################################
# ZSHRC
##########################################################################

##########################################################################
# LS_COLOR
##########################################################################
export CLICOLOR=true
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin
Defaults    env_keep += "PATH"
Defaults    env_keep += "PYENV_ROOT"

##########################################################################
# ZGEN
##########################################################################

source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then

  zgen load sindresorhus/pure

  # generate the init script from plugins above
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-completions src
  zgen load /usr/local/share/zsh/site-functions

  zgen load mollifier/anyframe

  zgen oh-my-zsh plugins/brew
  zgen oh-my-zsh plugins/thefuck

  zgen oh-my-zsh plugins/pip
  zgen oh-my-zsh plugins/python
  zgen oh-my-zsh plugins/pyenv

  zgen oh-my-zsh plugins/rbenv

  zgen oh-my-zsh plugins/sudo
  zgen save
fi

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

bindkey '^r' anyframe-widget-put-history

bindkey '^xgc' anyframe-widget-checkout-git-branch
bindkey '^xgi' anyframe-widget-insert-git-branch

bindkey '^xf' anyframe-widget-insert-filename

bindkey '^xta' anyframe-widget-tmux-attach

##########################################################################
# HISTORY
##########################################################################

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_nodups

localip(){
  ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
}
##########################################################################
# TMUX
##########################################################################

# if type zprof > /dev/null 2>&1; then
#   zprof | less
# fi

##########################################################################
# ZSHRC
##########################################################################

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
  zgen load chrissicool/zsh-256color

  zgen oh-my-zsh plugins/brew
  zgen oh-my-zsh plugins/thefuck

  zgen oh-my-zsh plugins/pip
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

bindkey -v

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

##########################################################################
# TMUX
##########################################################################

# if type zprof > /dev/null 2>&1; then
#   zprof | less
# fi
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:$PATH"
eval "$(pyenv init -)"

##########################################################################
# ZSHENV
##########################################################################

# Ensure paths are unique
typeset -U path

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Don't send analytics or hints (for Homebrew)
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

# User PATH settings
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "/usr/local/bin"
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  "$(command -v brew >/dev/null && brew --prefix)/bin"
  "$path[@]"
)

##########################################################################
# HISTORY
##########################################################################

export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
export HISTSIZE=1000000
export SAVEHIST=1000000

setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt EXTENDED_HISTORY

##########################################################################
# SETOPT
##########################################################################

setopt auto_cd
setopt auto_menu
setopt auto_pushd
setopt hist_verify
setopt list_packed
setopt list_types
setopt nobeep

export REPORTTIME=3

##########################################################################
# LS_COLOR
##########################################################################

export CLICOLOR=1
export LSCOLORS="exfxcxdxbxGxDxabagacad"
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01"

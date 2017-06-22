##########################################################################
# ZSHENV

# zmodload zsh/zprof && zprof

##########################################################################
# EXPORT
typeset -U path

# language environment
export LANG=en_US.UTF-8

# Don't send analytics
export HOMEBREW_NO_ANALYTICS=1

# zplug
export ZPLUG_HOME=$HOME/.cache/zplug

# neovim
export XDG_CONFIG_HOME=$HOME/.config

#Sheet EDITOR
if (which nvim > /dev/null 2>&1) ;then
  export EDITOR=vim
  export VISUAL=vim
  alias v='vim'
else
  export EDITOR=nvim
  export VISUAL=nvim
  alias v='nvim'
  alias vim='nvim'
fi

# Latex
export PATH="/Library/TeX/texbin:$PATH"

# User configuration
#PATH
path=(/usr/local/bin \
      /usr/bin \
      /bin \
      /usr/sbin \
      /sbin \
      /usr/bin \
      "$path[@]" \
      )

##########################################################################
# HISTORY
##########################################################################

HISTFILE="${HOME}/.cache/zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

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

REPORTTIME=3

##########################################################################
# LS_COLOR
##########################################################################

export CLICOLOR=true
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

##################################################
# BINDKEY

bindkey '^r' anyframe-widget-put-history
zstyle ":anyframe:selector:fzf:" command 'fzf --ansi --height 20%'

##########################################################################
# ALIAS
##########################################################################
# Open Atom
alias atom="open -a /Applications/Atom.app"

# back directory
alias ..="cd .."
alias ...="cd ../.."

# Nyan Cat :)
alias nyan='nc -v nyancat.dakko.us 23'

alias :q='exit'

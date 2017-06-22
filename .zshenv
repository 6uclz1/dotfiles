##########################################################################
# ZSHENV

zmodload zsh/zprof && zprof

##########################################################################
# EXPORT
typeset -U path PATH cdpath fpath manpath

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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

# color test
color () {
    # echo ""
    #black
    echo -e "\e[0;30m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 01 0;30m"
    #red
    echo -e "\e[0;31m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 02 0;31m"
    #green
    echo -e "\e[0;32m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 03 0;32m"
    #yellow
    echo -e "\e[0;33m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 04 0;33m"
    #blue
    echo -e "\e[0;34m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 05 0;34m"
    #purple
    echo -e "\e[0;35m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 06 0;35m"
    #cyan
    echo -e "\e[0;36m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 07 0;36m"
    #white
    echo -e "\e[0;37m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 08 0;37m"
    echo ""
    #black
    echo -e "\e[1;30m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 09 1;30m"
    #red
    echo -e "\e[1;31m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 10 1;31m"
    #green
    echo -e "\e[1;32m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 11 1;32m"
    #yellow
    echo -e "\e[1;33m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 12 1;33m"
    #blue
    echo -e "\e[1;34m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 13 1;34m"
    #purple
    echo -e "\e[1;35m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 14 1;35m"
    #cyan
    echo -e "\e[1;36m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 15 1;36m"
    #white
    echo -e "\e[1;37m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 16 1;37m"
    echo ""
    echo -e "\e[0;30m█████\\e[0m\e[0;31m█████\\e[0m\e[0;32m█████\\e[0m\e[0;33m█████\\e[0m\e[0;34m█████\\e[0m\e[0;35m█████\\e[0m\e[0;36m█████\\e[0m\e[0;37m█████\\e[0m"
    echo -e "\e[0m\e[1;30m█████\\e[0m\e[1;31m█████\\e[0m\e[1;32m█████\\e[0m\e[1;33m█████\\e[0m\e[1;34m█████\\e[0m\e[1;35m█████\\e[0m\e[1;36m█████\\e[0m\e[1;37m█████\\e[0m"
}

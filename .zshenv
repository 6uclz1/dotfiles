######################################################################
# ZSHENV
######################################################################

# zmodload zsh/zprof

######################################################################
# EXPORT
######################################################################

typeset -U path

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Don't send analytics
export HOMEBREW_NO_ANALYTICS=1

# User configuration
#PATH
path=(/usr/local/bin /usr/bin /bin /usr/sbin /sbin /usr/bin $path[@])

export EDITOR="/usr/local/bin/vim"


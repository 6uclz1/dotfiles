##########################################################################
# ZSHRC
##########################################################################

##########################################################################
# SOURCE
##########################################################################
# export MANPATH="/usr/local/man:$MANPATH"
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##########################################################################
# SETOPT
##########################################################################
setopt AUTO_CD
cdpath=(.. ~ ~/src)
setopt auto_menu
setopt auto_pushd
setopt list_packed
setopt list_types

setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_nodups

setopt nobeep

setopt prompt_subst

REPORTTIME=3

##########################################################################
# HISTORY
##########################################################################
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt share_history

##########################################################################
# PLUGIN
##########################################################################

plugins=\
(\
autojump \
zsh-dircolors-solarized \
zsh-syntax-highlighting \
)

fpath=(/usr/local/share/zsh-completions $fpath)

autoload -Uz compinit && compinit -u

# 'zstyle' (Defines the given style for the pattern)
# Normally, the completion code will not produce the directory names
# '.' and '..' as possible completions. If this style is set to
# 'true', it will add both '.' and '..' as possible completions; if it
# is set to '..', only '..' will be added.
# zstyle ':completion:*' special-dirs .. # Fnord
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

# Cache stuff
# zsh cache directory
function zrc_info {
	print -P "%F{red}>>%F{default} $*"
}

#--------------------------------------------------
# if [[ -d ~/var/cache/zsh ]] {
# 	ZCACHEDIR=~/var/cache/zsh
# } else {
# 	zrc_info "~/var/cache/zsh does not exist, using ~/.zsh-cache instead"
# 	mkdir -p ~/.zsh-cache
# 	ZCACHEDIR=~/.zsh-cache
# }
# zstyle ':completion:*' cache-path $ZCACHEDIR
#--------------------------------------------------
zstyle ':completion:*' use-cache true
#--------------------------------------------------
# zstyle ':completion::complete:*' use-cache 1
# compinit -C -d $ZCACHEDIR/compdump
#--------------------------------------------------

# This way you tell zsh comp to take the first part of the path to be
# exact, and to avoid partial globs. Now path completions became nearly
# immediate.
zstyle ':completion:*' accept-exact '*(N)'

# highlight matching part of available completions
autoload -U colors ; colors
zstyle ':completion:*' list-colors  'reply=( "=(#b)(*$PREFIX)(?)*=00=$color[green]=$color[bg-green]" )'

# $ man write<TAB>
# manual page, section 1:
# write
# manual page, section 1p:
# write
# ...
# Its evil. Isn't it?!
zstyle ':completion:*:manuals' separate-sections true

# remove slash if argument is a directory
zstyle ':completion:*' squeeze-slashes true

# history
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes


# add colors to completions
# general completion
#--------------------------------------------------
 zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
#--------------------------------------------------
#--------------------------------------------------
# zstyle ':completion:*:corrections' format $'%{\e[0;32m%}%d (errors: %e)%}'
#--------------------------------------------------
zstyle ':completion:*:messages' format '%d'
#--------------------------------------------------
 zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
#--------------------------------------------------
#--------------------------------------------------
# zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# zstyle ':completion:*' format 'completing %d'
#--------------------------------------------------
#--------------------------------------------------
zstyle ':completion:*' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
#--------------------------------------------------
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# cd directory stack menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# approximation
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# array completion element sorting
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# ?
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

# ignore completion functions for commands you don't have
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'


zstyle ':completion:*' select-prompt %SScrolling active: current selection at %P Lines: %m
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# hosts (background = red, foreground = black)
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=30;41'
# usernames (background = white, foreground = blue)
zstyle ':completion:*:*:*:*:users' list-colors '=*=34;47'
# If the zsh/complist module is loaded, this style can be used to set
# color specifications. This mechanism replaces the use of the
# ZLS_COLORS and ZLS_COLOURS parameters.
# PIDs (bold red)
zstyle ':completion:*:processes' command ps --forest -A -o pid,cmd
zstyle ':completion:*:processes' list-colors '=(#b)( #[0-9]#)[^[/0-9a-zA-Z]#(*)=34=37;1=30;1'
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:(killall|pkill|kill):*' menu yes select
zstyle ':completion:*:(killall|pkill|kill):*' force-list always

# I'm bonelazy ;) Complete the hosts and - last but not least - the remote
# directories. Try it:
#  $ scp file username@<TAB><TAB>:/<TAB>
zstyle ':completion:*:(ssh|scp|ftp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|ftp):*' users $users

# Not realy needed.
#  $ cd <TAB>
#  Komplettiere local directory
#  <list existing directorys>
# zstyle ':completion:*' format 'Komplettiere %d'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# determine in which order the names (files) should be
# listed and completed when using menu completion.
# `size' to sort them by the size of the file
# `links' to sort them by the number of links to the file
# `modification' or `time' or `date' to sort them by the last modification time
# `access' to sort them by the last access time
# `inode' or `change' to sort them by the last inode change time
# `reverse' to sort in decreasing order
# If the style is set to any other value, or is unset, files will be
# sorted alphabetically by name.
zstyle ':completion:*' file-sort name

# how many completions switch on menu selection
# use 'long' to start menu compl. if list is bigger than screen
# or some number to start menu compl. if list has that number
# of completions (or more).
zstyle ':completion:*' menu select=long

# If there are more than 5 options, allow selecting from a menu with
# arrows (case insensitive completion!).
zstyle ':completion:*-case' menu select=5

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# filename suffixes to ignore during completion (except after rm
# command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns  '*?.(o|c~|old|pro|zwc)' '*~'

# Messages/warnings format
zstyle ':completion:*:messages' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for: %d%{\e[0m%}'
#--------------------------------------------------
# zstyle ':completion:*:corrections' format $'%{[0;31m%}%d (errors: %e)%{[0m%}'
#--------------------------------------------------
zstyle ':completion:*' group-name ''

# completions for some progs. not in default completion system
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG):ogg\ files *(-/):directories'

# Prevent CVS files/directories from being completed
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# Ignore completion functions for commands you don't have:
zstyle ':completion:*:functions' ignored-patterns '_*'

# allow one error for every three characters typed in approximate
# completer
zstyle ':completion:::::' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 2
#--------------------------------------------------
 zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
#--------------------------------------------------

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

##########################################################################
# TMUX
##########################################################################


##########################################################################
# AUTOLOAD
##########################################################################

##########################################################################
# ALIAS
##########################################################################
# Open Atom
alias atom="open -a /Applications/Atom.app"
# back directory
alias ..="cd .."
# shortcut
alias ls="ls -ll -GF"
# Reload zshrc
alias zshrc="source ~/.zshrc"
# Nyan Cat :)
alias nyan='nc -v nyancat.dakko.us 23'
# Homebrew warning avoid pyenv path.
alias brew="env PATH=${PATH/\/Users\/${USER}\/\.pyenv\/shims:?/} brew"

alias installsh="brew file -f ~/dotfiles/osx/install.sh -F cmd init"

alias openzshrc="atom ~/.zshrc"

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

alias localip="ipconfig getifaddr en0"

# Aliases
if [[ -n $TMUX ]]; then
  alias ta='tmux switch-client -t'
else
  alias ta='tmux attach-session -t'
fi
alias ts='tmux-new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

compdef sshrc=ssh

eval "$(thefuck --alias)"
alias f='fuck'

##########################################################################
# PROGRAM ENV
##########################################################################

PROMPT_COMMAND='share_history'

# Python env
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Ruby env
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

##########################################################################
# MY FUNC
##########################################################################

function brew() {
  if [ -f $(brew --prefix)/etc/brew-wrap ];then
    source $(brew --prefix)/etc/brew-wrap
  fi
}


# "cd" automatically after "git clone"
function gitccd
{
  gitcloneurl=$1
  reponame=$(echo $gitcloneurl | awk -F/ '{print $NF}'| sed -e 's/.git$//')
  cd $reponame
}


# "cd" automatically after "ls"
function chpwd
{
  ls -ll -GF
}

color_palette(){
  for i in $(seq 0 4 255); do
	for j in $(seq $i $(expr $i + 3)); do
		for k in $(seq 1 $(expr 3 - ${#j})); do
			printf " "
		done
		printf "\x1b[38;5;${j}mcolour${j}"
		[[ $(expr $j % 4) != 3 ]] && printf "    "
	done
	printf "\n"
  done
}

# "mkdir" automatically after "cd"
function mkdir
{
  command mkdir $1 && cd $1
}


# Pyenv Version show right prompt
# function pyenv-version-check {
#   echo `pyenv version-name`}
# RPROMPT='%{$fg[yellow]%}pyenv > `pyenv-version-check`%{$reset_color%}'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

netstattop(){
	netstat -p | while l="$(line)";\
 		 do p="$(sed -En 's/^.*( [0-9]+)\/[^ ]*.*/\1/gp'<<<"$l")";\
		     [ "$p" == "" ] || p=" ## $(ps -p $p -o cmd=)";\
   			 echo "$l"$p;\
  done
}

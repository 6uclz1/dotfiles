#########
# ZSHRC #
#########

# --------
# export
# --------

# ZSH Setting
export ZSH=~/.oh-my-zsh

# User configuration
export PATH="/usr/local/bin"
export PATH="/usr/bin:$PATH"
export PATH="/bin:$PATH"
export PATH="/usr/sbin:$PATH"
export PATH="/sbin:$PATH"
export PATH="$HOME/usr/bin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export HOMEBREW_BREWFILE=~/dotfiles/Brewfile

# language environment
export LANG=en_US.UTF-8

plugins=\
(\
my-env\
atom\
autojump\
brew\
brew-cask\
bundler\
cdd\
colored-man\
composer\
docker\
encode64\
gem\
git\
homeshick\
pow\
pyenv\
rails\
rake\
rbenv\
tig\
vagrant\
web-search\
zsh-completions\
zsh-syntax-highlighting\
)

# -------
# source
# -------
# export MANPATH="/usr/local/man:$MANPATH"
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Dupricate delete
typeset -U path cdpath fpath manpath

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -Uz compinit
compinit -u

autoload -U colors
colors

# ----------------
# setopt Setting
# ----------------
setopt auto_menu
setopt auto_cd
setopt nobeep
setopt prompt_subst

HIST_STAMPS="mm/dd/yyyy"

# --------------------
# Theme Setting
# --------------------
ZSH_THEME="agnoster"
CURRENT_BG='NONE'
PRIMARY_FG=black
# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.

# ----------------
# Prompt Setting
# ----------------
prompt_segment()
{
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end()
{
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

prompt_context()
{
  local user=`whoami`
  if ["$SSH_CONNECTION" ]; then
    prompt_segment $PRIMARY_FG default " %(!.%{.})"
  fi
}

# Git: branch/detached head, dirty status
prompt_git()
{
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color=yellow
      ref="${ref} $PLUSMINUS"
    else
      color=green
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    prompt_segment $color $PRIMARY_FG
    print -Pn " $ref"
  fi
}

# Dir: current working directory
prompt_dir()
{
  prompt_segment blue $PRIMARY_FG ' %~ '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status()
{
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default " $symbols "
}

## Main prompt
prompt_agnoster_main()
{
  RETVAL=$?
  CURRENT_BG='NONE'
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

prompt_agnoster_precmd()
{
  vcs_info
  PROMPT='%{%f%b%k%}$(prompt_agnoster_main) %{$reset_color%}'
}

prompt_agnoster_setup()
{
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_agnoster_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' get-revision true
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_agnoster_setup "$@"


if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

# ----------------
# Command Setting
# ----------------

# "cd" automatically after "ls"
function chpwd
{
  ls -a
}

# "cd" automatically after "git clone"
function gitccd
{
  gitcloneurl=$1
  reponame=$(echo $gitcloneurl | awk -F/ '{print $NF}'| sed -e 's/.git$//')
  cd $reponame
}


# "mkdir" automatically after "cd"
function mkdir
{
  command mkdir $1 && cd $1
}

# Auto Run TMUX (optinal)
# [[ -z "$TMUX" && ! -z "$PS1" ]] && tmux
# [[ -z "$TMUX" && -z "$WINDOW" && ! -z "$PS1" ]]

# ----------------
# Aliases
# ----------------
# Open Atom
alias atom="open -a /Users/$USER/Applications/Atom.app"
# Open Emacs
alias emacs="/Users/$USER/Applications/Emacs.app -nw"
# Fix pyenv brew doctor config
alias brew="env PATH=${PATH/\/Users\/takc923\/\.pyenv\/shims:/} brew"
# shortcut
alias .zshrc="source ~/.zshrc"
# Nyan Cat :)
alias nyan='nc -v nyancat.dakko.us 23'

# ----------------
# Programing Setting
# ----------------
# Go lang env
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Ruby env
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Python env
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Pyenv Version show right prompt
function pyenv-version-check
{
  echo `pyenv version | cut -c 1-6`
}

RPROMPT='%{$fg[yellow]%}python > `pyenv-version-check` [%*]%{$reset_color%}'

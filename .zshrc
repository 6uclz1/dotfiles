# ZSH Setting
export ZSH=/Users/$USER/.oh-my-zsh

HIST_STAMPS="mm/dd/yyyy"

plugins=(my-env atom autojump brew brew-cask bundler cdd colored-man composer\
docker encode64 gem git homeshick pow rails rake rbenv tig vagrant web-search\
zsh-syntax-highlighting)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH=/usr/local/bin:$PATH
export HOMEBREW_BREWFILE=/Code/dotfiles/Brewfile

# export MANPATH="/usr/local/man:$MANPATH"
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# language environment
export LANG=en_US.UTF-8

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
prompt_segment() {
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
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

prompt_context() {
  local user=`whoami`
  if ["$SSH_CONNECTION" ]; then
    prompt_segment $PRIMARY_FG default " %(!.%{.})"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
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
prompt_dir() {
  prompt_segment blue $PRIMARY_FG ' %~ '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default " $symbols "
}

## Main prompt
prompt_agnoster_main() {
  RETVAL=$?
  CURRENT_BG='NONE'
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

prompt_agnoster_precmd() {
  vcs_info
  PROMPT='%{%f%b%k%}$(prompt_agnoster_main) %{$reset_color%}'
}

prompt_agnoster_setup() {
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

# ----------------
# Command Setting
# ----------------

# Auto "ls" after "cd"
function chpwd() {ls}

# Auto "mkdir" and "cd"
function mkdir
{
  command mkdir $1 && cd $1
}

autoload -U compinit
compinit

# Auto Run TMUX (optinal)
# [[ -z "$TMUX" && ! -z "$PS1" ]] && tmux
# [[ -z "$TMUX" && -z "$WINDOW" && ! -z "$PS1" ]]

# Auto brew
if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

# ----------------
# Aliases
# ----------------
# Open Atom
alias atom="open -a /Applications/Atom.app"
# Open Emacs
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"

# Fix pyenv brew doctor config
alias brew="env PATH=${PATH/\/Users\/takc923\/\.pyenv\/shims:/} brew"

alias zshrc="source ~/.zshrc"

# Nyan Cat :)
alias nyan='nc -v nyancat.dakko.us 23'

# ----------------
# setopt Setting
# ----------------
setopt auto_menu
setopt auto_cd
setopt nobeep
setopt prompt_subst

# ----------------
# Programing Setting
# ----------------
# Go lang env
export GOPATH=~/.go

# Ruby env
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Python env
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Pyenv Version show right prompt
function pyenv-version-check {
  echo `pyenv version | cut -c 1-6`
}

RPROMPT='%{$fg[yellow]%}python > `pyenv-version-check` [%*]%{$reset_color%}'

export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'

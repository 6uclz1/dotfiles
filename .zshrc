##########################################################################
# ZSHRC
##########################################################################

##########################################################################
# EXPORT
##########################################################################
# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export HOMEBREW_BREWFILE=~/dotfiles/Brewfile

# Don't send analytics
export HOMEBREW_NO_ANALYTICS=1

# emacs like keybind
bindkey -e

# history
HISTFILE=~/.zsh_history
HISTSIZE=1_000_000
SAVEHIST=1_000_000

plugins=\
(\
my-env \
ag \
atom \
autojump \
brew \
brew-cask \
bundler \
cask \
cdd \
colored-man \
composer \
docker \
encode64 \
gem \
git \
homeshick \
pep8 \
pip \
pow \
pyenv \
rails \
rake \
rbenv \
tig \
vagrant \
web-search \
zsh-completions \
zsh-dircolors-solarized \
zsh-syntax-highlighting \
)

##########################################################################
# SOURCE
##########################################################################
# export MANPATH="/usr/local/man:$MANPATH"
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##########################################################################
# AUTOLOAD
##########################################################################
autoload -Uz compinit
compinit -u

autoload -U colors
colors

zmodload -a colors
zmodload -a autocomplete
zmodload -a complist

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
##########################################################################
# SETOPT
##########################################################################
setopt auto_cd
setopt auto_menu
setopt auto_pushd
setopt list_packed

setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_nodups

setopt nobeep

setopt prompt_subst

setopt share_history

HIST_STAMPS="mm/dd/yyyy"

REPORTTIME=3

##########################################################################
# ZSTYLE
##########################################################################


##########################################################################
# THEME
##########################################################################
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

export GREP_COLOR='1;33'

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.

##########################################################################
# PROMPT
##########################################################################
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

##########################################################################
# COMMAND
##########################################################################

# "cd" automatically after "ls"
function chpwd
{
  ls -ll -GF
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

function build_prompt {
  prompt_segment black default '%(1?;%{%F{red}%}✘ ;)%(!;%{%F{yellow}%}⚡ ;)%(1j;%{%F{cyan}%}%j⚙ ;)%{%F{blue}%}%n%{%F{red}%}@%{%F{green}%}%M'
  prompt_segment blue black '%2~'
  if $git_status; then
    prompt_segment green black '${(e)git_info[prompt]}${git_info[status]}'
  fi
  prompt_end
}

# Auto Run TMUX (optinal)
# [[ -z "$TMUX" && ! -z "$PS1" ]] && tmux
# [[ -z "$TMUX" && -z "$WINDOW" && ! -z "$PS1" ]]

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

##########################################################################
# PROGRAMMING
##########################################################################

function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'

function brew() {
  if [ -f $(brew --prefix)/etc/brew-wrap ];then
    source $(brew --prefix)/etc/brew-wrap
  fi
}

# Python env
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# Pyenv Version show right prompt
function pyenv-version-check {
  echo `pyenv version-name`
}

RPROMPT='%{$fg[yellow]%}pyenv > `pyenv-version-check`%{$reset_color%}'

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

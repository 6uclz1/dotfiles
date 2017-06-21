##################################################
# ZSHRC

##################################################
# ZPLUG

export ZPLUG_HOME=${HOME}/.cache/zplug

if [[ ! -d ${ZPLUG_HOME}/ ]];then
  curl -sL --proto-redir -all,\
  https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi

source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "mollifier/anyframe", from:github
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure",  use:pure.zsh, \
                            from:github, \
                            as:theme

zplug "plugins/brew",   from:oh-my-zsh, \
						lazy:true, \
						if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/git",    from:oh-my-zsh, lazy:true
zplug "plugins/pip",    from:oh-my-zsh, lazy:true
zplug "plugins/python", from:oh-my-zsh, lazy:true
zplug "plugins/pyenv",  from:oh-my-zsh, lazy:true
zplug "plugins/sudo",   from:oh-my-zsh, lazy:true

if whence fzf >/dev/null; then
  zplug "junegunn/fzf", \
      as:command, \
      use:"bin/fzf-tmux"

  zplug "junegunn/fzf-bin", \
      as:command, \
      from:gh-r, \
      rename-to:"fzf"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load


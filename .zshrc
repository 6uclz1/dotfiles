##################################################
# ZSHRC

##################################################
# ZPLUG

# AutoInstall
if [[ ! -d ${ZPLUG_HOME}/ ]];then
  curl -sL --proto-redir -all,\
  https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi

# load zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3

zplug "mollifier/anyframe", from:github
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure",  use:pure.zsh, \
                            from:github, \
                            as:theme

zplug "plugins/pip",   from:oh-my-zsh, lazy:true
zplug "plugins/pyenv", from:oh-my-zsh, lazy:true
zplug "plugins/git",   from:oh-my-zsh, lazy:true

zplug "junegunn/fzf", as:command, \
      								use:"bin/fzf-tmux"

zplug "junegunn/fzf-bin", as:command, \
      										from:gh-r, \
      										rename-to:"fzf"

if ! zplug check; then
	zplug install
fi

zplug load

if (which zprof > /dev/null 2>&1) ;then
	zprof
fi

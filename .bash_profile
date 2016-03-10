if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# added by Anaconda2 2.4.0 installer
export PATH="/Applications/anaconda/bin:$PATH"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

ln -sf $HOME/dotfiles/emacs/.emacs.d $HOME/.emacs.d

FILES=\
"Rprofile \
spacemacs \
sshrc \
tmux.conf \
zlogin \
zshenv \
zshrc"

for dotfiles in $FILES

do
  if [ -a $HOME/.$dotfiles ]; then
    echo "existed alias $dotfiles"
  else
    ln -sf $HOME/dotfiles/.$dotfiles $HOME/.$dotfiles
    echo "linked .$dotfiles!"
  fi
done

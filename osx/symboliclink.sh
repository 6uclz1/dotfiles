DOT_FILES=( .zshenv .zshrc .tmux.conf .emacs.d)

for dotfile in ${DOT_FILES[@]}
do
  if [ -a $HOME/$dotfile ]; then
    echo ""
  else
    ln -s $HOME/dotfiles/$dotfile $HOME/$dotfile
    echo "make $dotfile link"
  fi
done

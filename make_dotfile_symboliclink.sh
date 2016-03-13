cd `dirname $0`

DOT_FILES=( .zshenv .zshrc .tmux.conf .emacs.d)

for dotfile in ${DOT_FILES[@]}
do
  if [ -a $HOME/$dotfile ]; then
    echo "$dotfile exists!"
  else
    ln -s ./$dotfile $HOME/$dotfile
    echo "make $dotfile symbolic link"
  fi
done

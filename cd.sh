cd `dirname $0`

DOT_FILES=(zshenv zshrc tmux.conf tmux emacs.d)

for dotfile in ${DOT_FILES[@]}
do
  if [ -a $HOME/.$dotfile ]; then
    echo ".$dotfile exist!"
  else
    echo ".$dotfile"
  fi
done

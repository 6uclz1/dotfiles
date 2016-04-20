
for zsh in $HOME/dotfiles/zsh/.*
do
  if [ -a $HOME/$zsh ]; then
    echo "existed alias $zsh"
  else
    ln -sf $zsh $HOME
    echo "make $zsh link"
  fi
done

ATOM_FILES=\
(\
config.cson \
init.coffee \
keymap.cson \
snippests.cson \
styles.less \
)

for atomfile in ${ATOM_FILES[@]}
do
  if [ -a $HOME/atom/$atomfile ]; then
    echo "existed alias $atomfile"
  else
    ln -sf $HOME/dotfiles/atom/$atomfile $HOME/.atom/$atomfile
    echo "make $atomfile link"
  fi
done

ln -sf $HOME/dotfiles/emacs/.emacs.d $HOME/.emacs.d

ln -sf $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf

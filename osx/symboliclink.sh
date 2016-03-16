DOT_FILES=\
(\
.emacs.d \
.tmux.conf \
.zshenv \
.zlogin \
.zshrc \
Brewfile \
)

for dotfile in ${DOT_FILES[@]}
do
  if [ -a $HOME/$dotfile ]; then
    echo "existed alias $dotfile"
  else
    ln -sf $HOME/dotfiles/$dotfile $HOME/$dotfile
    echo "make $dotfile link"
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
  if [ -a $HOME/.atom/$atomfile ]; then
    echo "existed alias $atomfile"
  else
    ln -sf $HOME/dotfiles/.atom/$atomfile $HOME/.atom/$atomfile
    echo "make $atomfile link"
  fi
done

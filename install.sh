#!/usr/bin/env bash

#BREWFILE_IGNORE
if ! which brew >& /dev/null;then
  brew_installed=0
  echo Homebrew is not installed!
  echo Install now...
  echo ruby -e \"\$\(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install\)\"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo
fi
#BREWFILE_ENDIGNORE

# tap repositories and their packages

brew tap argon/mas
brew install mas

brew tap caskroom/cask
brew cask install alfred
brew cask install atom
brew cask install cycling74-max
brew cask install daisydisk
brew cask install dropbox
brew cask install flux
brew cask install github-desktop
brew cask install karabiner
brew cask install onyx
brew cask install parallels-desktop
brew cask install processing
brew cask install sketch
brew cask install sourcetree

brew tap homebrew/python
brew install numpy

brew tap homebrew/science
brew install hdf5
brew install opencv

brew tap homebrew/versions
brew install glfw3

brew tap rcmdnk/file
brew install brew-file

brew tap sanemat/font

# Other Homebrew packages
brew install autoconf
brew install automake
brew install berkeley-db
brew install boost
brew install boost-python
brew install cabal-install
brew install cairo
brew install cmake
brew install coreutils
brew install czmq
brew install eigen
brew install emacs
brew install ffmpeg
brew install flac
brew install fontconfig
brew install fontforge
brew install freetype
brew install fribidi
brew install gcc
brew install gdbm
brew install gettext
brew install gflags
brew install ghc
brew install glib
brew install glog
brew install gmp
brew install go
brew install gobject-introspection
brew install harfbuzz
brew install icu4c
brew install ilmbase
brew install imagemagick
brew install isl
brew install jack
brew install jpeg
brew install lame
brew install leveldb
brew install libass
brew install libevent
brew install libffi
brew install liblo
brew install libmpc
brew install libogg
brew install libpng
brew install libsamplerate
brew install libsndfile
brew install libsodium
brew install libtiff
brew install libtool
brew install libvo-aacenc
brew install libvorbis
brew install libyaml
brew install little-cms2
brew install lmdb
brew install lua
brew install mackup
brew install mpfr
brew install mpv
brew install mysql
brew install node
brew install openexr
brew install openssl
brew install pango
brew install pcre
brew install peco
brew install pixman
brew install pkg-config
brew install protobuf --devel
brew install pyenv
brew install pyenv-virtualenv
brew install python
brew install python3
brew install rbenv
brew install readline
brew install reattach-to-user-namespace
brew install ruby-build
brew install snappy
brew install sqlite
brew install szip
brew install tmux
brew install wget
brew install x264
brew install xvid
brew install xz
brew install youtube-dl
brew install zeromq
brew install zsh
brew install zsh-completions
brew install zsh-syntax-highlighting

# App Store applications
mas install 443987910 #1Password
mas install 824171161 #Affinity Designer
mas install 974971992 #Alternote
mas install 417375580 #BetterSnapTool
mas install 641027709 #Color Picker
mas install 449589707 #Dash
mas install 422304217 #Day One Classic
mas install 682658836 #GarageBand
mas install 409183694 #Keynote
mas install 411213048 #LadioCast
mas install 890031187 #Marked 2
mas install 409203825 #Numbers
mas install 409201541 #Pages
mas install 967805235 #Paste
mas install 407963104 #Pixelmator
mas install 445189367 #PopClip
mas install 866773894 #Quiver
mas install 803453959 #Slack
mas install 425424353 #The Unarchiver
mas install 557168941 #Tweetbot
mas install 493949693 #iMage Tools
mas install 408981434 #iMovie
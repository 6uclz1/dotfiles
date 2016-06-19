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
brew cask install bettertouchtool
brew cask install colorpicker-skalacolor
brew cask install cycling74-max
brew cask install daisydisk
brew cask install dropbox
brew cask install firefox
brew cask install flux
brew cask install github-desktop
brew cask install google-nik-collection
brew cask install google-photos-backup
brew cask install handbrake
brew cask install iterm2
brew cask install java
brew cask install karabiner
brew cask install onyx
brew cask install parallels-desktop
brew cask install processing
brew cask install sketch
brew cask install sourcetree
brew cask install xld

brew tap homebrew/bundle

brew tap homebrew/core
brew install autoconf
brew install automake
brew install bazel
brew install berkeley-db
brew install boost-python
brew install boost
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
brew install ghostscript
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
brew install jenv
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
brew install nicovideo-dl
brew install nmap
brew install node
brew install openexr
brew install openssl
brew install pango
brew install pcre
brew install peco
brew install pixman
brew install pkg-config
brew install postgresql
brew install protobuf --devel
brew install pyenv-virtualenv
brew install pyenv
brew install python
brew install python3
brew install rbenv
brew install readline
brew install reattach-to-user-namespace
brew install ruby-build
brew install snappy
brew install sqlite
brew install sshrc
brew install szip
brew install tmux
brew install wget
brew install x264
brew install xvid
brew install xz
brew install youtube-dl
brew install zeromq
brew install zsh-completions
brew install zsh-syntax-highlighting
brew install zsh

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

brew tap zyedidia/micro
brew install micro --devel

# Cask applications
brew cask install   --caskroom=/opt/homebrew-cask/Caskroom

# Below applications were installed by Cask,
# but do not have corresponding casks.

#brew cask install Warning: The default Caskroom location has moved to /usr/local/Caskroom.
#brew cask install 
#brew cask install Please migrate your Casks to the new location, or if you would like to keep your
#brew cask install Caskroom at /opt/homebrew-cask/Caskroom, add the following to your HOMEBREW_CASK_OPTS:
#brew cask install 
#brew cask install 
#brew cask install For more details on each of those options, see https://github.com/caskroom/homebrew-cask/issues/21913.

# App Store applications
#appstore 443987910 1Password
#appstore 824171161 Affinity Designer
#appstore 824183456 Affinity Photo
#appstore 974971992 Alternote
#appstore 641027709 Color Picker
#appstore 449589707 Dash
#appstore 422304217 Day One Classic
#appstore 409183694 Keynote
#appstore 411213048 LadioCast
#appstore 890031187 Marked 2
#appstore 409203825 Numbers
#appstore 409201541 Pages
#appstore 407963104 Pixelmator
#appstore 445189367 PopClip
#appstore 866773894 Quiver
#appstore 425424353 The Unarchiver
#appstore 557168941 Tweetbot
#appstore 497799835 Xcode
#appstore 408981434 iMovie

# Other commands
mas install 443987910 #1Password
mas install 824171161 #Affinity Designer
mas install 824183456 #Affinity Photo
mas install 974971992 #Alternote
mas install 641027709 #Color Picker
mas install 449589707 #Dash
mas install 422304217 #Day One Classic
mas install 409183694 #Keynote
mas install 411213048 #LadioCast
mas install 890031187 #Marked 2
mas install 409203825 #Numbers
mas install 409201541 #Pages
mas install 407963104 #Pixelmator
mas install 445189367 #PopClip
mas install 866773894 #Quiver
mas install 425424353 #The Unarchiver
mas install 557168941 #Tweetbot
mas install 1024069033 #Veertu
mas install 497799835 #Xcode
mas install 408981434 #iMovie

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
brew cask install appcleaner
brew cask install atom
brew cask install black-screen
brew cask install colorpicker-skalacolor
brew cask install cycling74-max
brew cask install daisydisk
brew cask install dropbox
brew cask install edgeview
brew cask install firefox
brew cask install flux
brew cask install github-desktop
brew cask install google-nik-collection
brew cask install google-photos-backup
brew cask install iterm2
brew cask install java
brew cask install keyboard-cleaner
brew cask install keycastr
brew cask install onyx
brew cask install parallels-desktop
brew cask install processing
brew cask install sketch
brew cask install sourcetree
brew cask install wireshark
brew cask install xld

brew tap homebrew/core
brew install android-platform-tools
brew install autoconf
brew install automake
brew install berkeley-db
brew install boost
brew install boost-python
brew install c-ares
brew install cairo
brew install cmake
brew install coreutils
brew install czmq
brew install dbus
brew install doxygen
brew install eigen
brew install emacs
brew install fdupes
brew install ffmpeg
brew install flac
brew install fontconfig
brew install fontforge
brew install freetype
brew install fribidi
brew install gcc
brew install gdbm
brew install gdk-pixbuf
brew install geoip
brew install gettext
brew install gflags
brew install ghc
brew install ghostscript
brew install git
brew install git-cal
brew install glib
brew install glog
brew install gmp
brew install gnutls
brew install go
brew install gobject-introspection
brew install gperftools
brew install harfbuzz
brew install icu4c
brew install ilmbase
brew install imagemagick
brew install isl
brew install jenv
brew install jpeg
brew install lame
brew install leveldb
brew install libass
brew install libcroco
brew install libevent
brew install libffi
brew install libgcrypt
brew install libgpg-error
brew install liblo
brew install libmpc
brew install libogg
brew install libpng
brew install librsvg
brew install libsamplerate
brew install libsndfile
brew install libsodium
brew install libtasn1
brew install libtiff
brew install libtool
brew install libvo-aacenc
brew install libvorbis
brew install libyaml
brew install little-cms2
brew install lmdb
brew install lua
brew install mackup
brew install micro
brew install mpfr
brew install mpv
brew install mycli
brew install mysql
brew install nettle
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
brew install pv
brew install pyenv
brew install pyenv-virtualenv
brew install python
brew install python3
brew install rbenv
brew install readline
brew install reattach-to-user-namespace
brew install ruby-build
brew install shared-mime-info
brew install shellcheck
brew install snappy
brew install sqlite
brew install sshrc
brew install stormssh
brew install szip
brew install tmux
brew install uncrustify
brew install wget
brew install x264
brew install xvid
brew install xz
brew install youtube-dl
brew install zeromq
brew install zsh
brew install zsh-completions
brew install zsh-syntax-highlighting

brew tap homebrew/python
brew install numpy

brew tap homebrew/science
brew install hdf5

brew tap homebrew/versions
brew install glfw3

brew tap rcmdnk/file
brew install brew-file

# Below applications were installed by Cask,
# but do not have corresponding casks.

#brew cask install hyperterm (!)

# App Store applications
#appstore 443987910 1Password (6.3.4)
#appstore 824171161 Affinity Designer (1.5.1)
#appstore 824183456 Affinity Photo (1.4.3)
#appstore 974971992 Alternote (1.0.10)
#appstore 641027709 Color Picker (1.4.5)
#appstore 449589707 Dash (3.3.1)
#appstore 412448059 ForkLift (2.6.6)
#appstore 409183694 Keynote (7.0)
#appstore 539883307 LINE (4.9.0)
#appstore 411213048 LadioCast (000012000)
#appstore 890031187 Marked 2 (2.5.6)
#appstore 409203825 Numbers (4.0)
#appstore 409201541 Pages (6.0)
#appstore 1160374471 PiPifier (1.2.1)
#appstore 407963104 Pixelmator (3.5.1)
#appstore 445189367 PopClip (1.5.6)
#appstore 866773894 Quiver (3.0.3)
#appstore 803453959 Slack (2.0.3)
#appstore 425424353 The Unarchiver (3.11.1)
#appstore 557168941 Tweetbot (2.4.4)
#appstore 409789998 Twitter (4.2.4)
#appstore 497799835 Xcode (8.0)
#appstore 408981434 iMovie (10.1.2)

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

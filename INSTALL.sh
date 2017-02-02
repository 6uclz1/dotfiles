#!/bin/bash
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get -y install zsh vim npm tmux htop iftop wget curl

git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

ln -sf ${HOME}/dotfiles/.vimrc ${HOME}/.vimrc
ln -sf ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc
ln -sf ${HOME}/dotfiles/.tmux.conf ${HOME}/.tmux.conf
ln -sf ${HOME}/dotfiles/.Rprofile ${HOME}/.Rprofile

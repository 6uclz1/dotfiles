#!/bin/bash
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get -y install zsh vim npm tmux htop iftop wget curl

npm install --global pure-prompt

git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

wget https://raw.githubusercontent.com/Russell91/sshrc/master/sshrc && chmod +x sshrc && sudo mv sshrc /usr/local/bin

ln -sf ${HOME}/dotfiles/.vimrc ${HOME}/.vimrc
ln -sf ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc
ln -sf ${HOME}/dotfiles/.tmux.conf ${HOME}/.tmux.conf

ln -sf ${HOME}/dotfiles/.sshrc ${HOME}/.sshrc
ln -sf ${HOME}/dotfiles/.Rprofile ${HOME}/.Rprofile

mkdir ${HOME}/.sshrc.d

ln -sf ${HOME}/dotfiles/.tmux.conf ${HOME}/.sshrc.d/.tmux.conf
ln -sf ${HOME}/dotfiles/.vimrc ${HOME}/.sshrc.d/.vimrc

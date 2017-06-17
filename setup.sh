
# install zgen
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# set shell >> zsh
sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
chsh -s /usr/local/bin/zsh

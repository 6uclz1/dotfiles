# init.sh
# Check OS and Run dependence script

init_dir=${DOTPATH}/etc/init

case ${OSTYPE} in
	darwin*)
		echo "macos detected!"

		# Brew install check
		if (which brew > /dev/null 2>&1) ;then
			echo "brew detect"
			brew tap Homebrew/bundle
			brew bundle --file="${DOTPATH}/etc/init/macos/Brewfile"
		else
			echo "brew install"
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

		fi

		# zsh install check
		if (which zsh > /dev/null 2>&1) ;then
			# Set default shell >> zsh
			sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
			chsh -s /usr/local/bin/zsh
		else
			echo "not install zsh"
		fi
		echo ${init_dir}/macos/*.sh
		;;

	linux*)
		echo "linux"

		# build basic package
		sudo apt-get update
		sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev
		sudo apt-get install -y make libreadline-dev libsqlite3-dev wget curl llvm
		sudo apt-get install -y libncurses5-dev libncursesw5-dev libpng-dev
		sudo apt-get -y install zsh vim tmux htop iftop
		sudo apt-get -y install software-properties-common
		sudo add-apt-repository ppa:neovim-ppa/unstable
		sudo apt-get -y install neovim

		# install pyenv
		git clone git://github.com/yyuu/pyenv.git ~/.pyenv
  	;;
esac

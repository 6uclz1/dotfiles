# init.sh
# Check OS and Run dependence script

src_dir=${DOTPATH}/src

case ${OSTYPE} in
	darwin*)
		echo "macos detected!"

		# Brew install check
		if (which brew > /dev/null 2>&1) ;then
			echo "brew detect"
		else
			echo "brew install"
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		fi

		echo "bundle install"
		brew bundle --file="${DOTPATH}/src/macos/Brewfile"

		# zsh install check
		if (which zsh > /dev/null 2>&1) ;then
			# Set default shell >> zsh
			sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
			chsh -s /usr/local/bin/zsh
		else
			echo "zsh detect! stop install zsh"
		fi

		sudo sh ${src_dir}/macos/*.sh
		;;

	linux*)
		echo "linux"
		# TODO
		# ubuntu only
		# add arch

		# ubuntu
		# build basic package
		sudo apt-get update
		sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev
		sudo apt-get install -y make libreadline-dev libsqlite3-dev wget curl llvm
		sudo apt-get install -y libncurses5-dev libncursesw5-dev libpng-dev
		sudo apt-get -y install zsh vim tmux htop iftop
		sudo apt-get -y install software-properties-common
  	;;
esac

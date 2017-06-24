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
  	;;
esac

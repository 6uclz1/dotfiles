sudo xcodebuild -license

xcode-select --install

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew doctor

brew update

brew install rcmdnk/file/brew-file

echo "DONE"

#!/bin/bash
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo
echo $SEPARATOR
echo ">>>>> INSTALL EXCLUSIVE OSX ................"
echo $SEPARATOR

source $BASEDIR/../common/install_func.sh
source $BASEDIR/install_func.sh
source $BASEDIR/install_url.sh
source $MY_SH_CFG_FILE

echo -n "UPDATE? (y/n) > "
read to_update

mkdir -p $HOME/Pictures/screenshots/
defaults write com.apple.screencapture location $HOME/Pictures/screenshots/ && killall SystemUIServer

xcode-select --install
exist_cmd gcc || xcode-select -p /Library/Developer/CommandLineTools
sudo xcodebuild -license accept

brew cask install keybase
brew cask install datagrip
brew cask install virtualbox
brew cask install react-native-debugger
brew cask install slack
brew cask install sublime-text
brew cask install google-chrome
brew cask install postman
brew cask install soapui
brew cask install robo-3t
brew cask install gitkraken
brew cask install sourcetree
brew cask install whatsapp
brew cask install calibre
brew cask install vlc
brew install tree
brew install ack
brew install vim

find_append ~/.zshrc "source $HOME/$REL_MY_SH_CFG_FILE" "\n\n### Personal shell config \nsource $MY_SH_CFG_FILE"
source $BASEDIR/../common/install_alias.sh

echo ":: $SEPARATOR"
echo ":: $SEPARATOR"
echo ":: $SEPARATOR"
uname -a
ruby --version
printf ":: $SEPARATOR\n BREW:\n "
brew list --versions
printf ":: $SEPARATOR\n GCC: "
gcc --version | head -1
printf ":: $SEPARATOR\n RUBY: "
Ruby --version
echo ":: $SEPARATOR"
python --version
echo ":: $SEPARATOR"
git --version
printf ":: $SEPARATOR\n "

echo


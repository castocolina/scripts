#!/bin/bash
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

source $BASEDIR/install_func.sh
source $MY_SH_CFG_FILE
source $BASEDIR/../common/install_func.sh

echo
echo $SEPARATOR
echo ">>>>> INSTALL OSX GUI APPS................"
echo $SEPARATOR

echo -n "UPDATE? (y/n) > "
read to_update

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

exist_cmd watchman || brew install watchman;
is_true $to_update && exist_cmd watchman && brew upgrade watchman;

exist_cmd tree || brew install tree
is_true $to_update && exist_cmd tree && brew upgrade tree;
exist_cmd ack || brew install ack
is_true $to_update && exist_cmd ack && brew upgrade ack;
exist_cmd vim || brew install vim
is_true $to_update && exist_cmd vim && brew upgrade vim;

echo


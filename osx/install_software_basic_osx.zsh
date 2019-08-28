#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

source $BASEDIR/install_func.zsh
source $MY_SH_CFG_FILE
source $BASEDIR/../common/install_func.zsh

echo
echo $SEPARATOR
echo ">>>>> INSTALL OSX BASIC TOOLS................"
echo $SEPARATOR

echo -n "UPDATE? (y/n) > "
read to_update

mkdir -p $HOME/Pictures/screenshots/
defaults write com.apple.screencapture location $HOME/Pictures/screenshots/ && killall SystemUIServer

xcode-select --install
exist_cmd gcc || xcode-select -p /Library/Developer/CommandLineTools
sudo xcodebuild -license accept

ruby --version

echo


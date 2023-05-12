#!/bin/bash

mkdir -p $HOME/Pictures/screenshots/
defaults write com.apple.screencapture location $HOME/Pictures/screenshots/ && killall SystemUIServer

xcode-select --install
xcode-select -p /Library/Developer/CommandLineTools
sudo xcodebuild -license accept
gcc --version
ruby --version

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask
brew tap caskroom/versions
brew doctor
brew update

brew cask install iterm2
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/bash
source ~/.zshrc
curl -L https://iterm2.com/shell_integration/zsh \
-o ~/.iterm2_shell_integration.sh
source ~/.iterm2_shell_integration.sh

#These plugins add support for the corresponding file type to Mac Quick Look 
#(In Finder, mark a file and press Space to start Quick Look).
brew cask install \
    qlcolorcode \
    qlstephen \
    qlmarkdown \
    quicklook-json \
    qlprettypatch \
    quicklook-csv \
    webpquicklook \
    suspicious-package
brew install homebrew/fuse/ntfs-3g

brew install node@8 
#nvm install --lts
#npm install -g exp
sudo npm install -g expo-cli
sudo npm install -g create-react-native-app
brew install yarn --without-node
sudo npm config delete prefix
sudo npm install -g eslint
sudo npm install -g tslint

sudo sysctl -w kern.maxfiles=5242880;
sudo sysctl -w kern.maxfilesperproc=524288

brew cask install virtualbox 
brew cask install genymotion

brew cask install java8

brew cask install android-sdk android-platform-tools androidtool android-ndk android-studio

brew cask install docker

#export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"

brew cask install slack
brew cask install sublime-text
brew cask install google-chrome
brew cask install postman
brew cask install robo-3t
brew cask install gitkraken
brew cask install sourcetree
brew cask install whatsapp
brew cask install calibre
brew cask install vlc
#brew cask install master-pdf-editor

brew install tree
brew install ack
brew install vim
brew install golang

python --version
brew list --versions
go version
java -version
docker run hello-world
docker -v
docker-compose -v
npm --version
node --version

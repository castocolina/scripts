#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo ""
echo $SEPARATOR
echo ">>>>> UPDATE ................"
echo $SEPARATOR

source $BASEDIR/../common/install_func.zsh
source $BASEDIR/install_func.zsh
source $BASEDIR/install_url.zsh
source $MY_SH_CFG_FILE

echo -n "UPDATE? (y/n) > "
read to_update

mkdir -p $HOME/Pictures/screenshots/
defaults write com.apple.screencapture location $HOME/Pictures/screenshots/ && killall SystemUIServer

xcode-select --install
exist_cmd gcc || xcode-select -p /Library/Developer/CommandLineTools
sudo xcodebuild -license accept

printf "\n$SEPARATOR\n >>>>>  BREW\n"

exist_cmd brew || {
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew tap caskroom/cask
	brew tap caskroom/versions
	brew doctor
	brew update --force
  	brew install hello
}

export HOMEBREW_NO_AUTO_UPDATE=1
find_append $MY_SH_CFG_FILE "HOMEBREW_NO_AUTO_UPDATE" "export HOMEBREW_NO_AUTO_UPDATE=1\n"

printf "\n$SEPARATOR\n >>>>> iTerm/ZSH\n"

exist_cmd zsh || {
    echo "INSTALLING..."
    brew cask install iterm2;

    brew install zsh;
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";
    chsh -s /bin/zsh;
    source ~/.zshrc;
    curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh;
    source ~/.iterm2_shell_integration.zsh;

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
      suspicious-package;
}

brew tap caskroom/fonts && brew cask install font-source-code-pro

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

#find_append ~/.zshrc "source $MY_SH_CFG_FILE" "\n\n### Personal shell config \nsource $MY_SH_CFG_FILE"
#source $BASEDIR../common/install_alias.zsh

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


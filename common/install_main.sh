#!/bin/bash
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

source $BASEDIR/install_func.sh
source $MY_SH_CFG_FILE

echo
echo $SEPARATOR
echo ">>>>> MAIN INSTALLER ................"
echo $SEPARATOR

MY_OS=$(get_os)

echo -n "UPDATE? (y/n) > "
read to_update


printf "\n$SEPARATOR\n >>>>> BREW\n"
if [ "$MY_OS" = "darwin" ]; then
  exist_cmd brew || {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap caskroom/cask
    brew tap caskroom/versions
    brew doctor
    brew update --force
    brew install hello
  }
fi
if [ "$MY_OS" = "linux" ]; then
  exist_cmd "brew" || {
    printf "\n ::: Install BREW for linux ...\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>$MY_SH_CFG_FILE

    source $MY_SH_CFG_FILE
    brew update --force
    brew install hello
  }
fi

export HOMEBREW_NO_AUTO_UPDATE=1
find_append $MY_SH_CFG_FILE "HOMEBREW_NO_AUTO_UPDATE" "export HOMEBREW_NO_AUTO_UPDATE=1\n"

printf "\n$SEPARATOR\n >>>>> ZSH\n"
exist_cmd "zsh" || {
  if [ "$MY_OS" = "linux" ]; then
    printf "\n ::: Install ZSH for linux ...\n"
    rm -rf $HOME/.oh-my-zsh
    sudo aptitude install zsh -y
    #oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi

  if [ "$MY_OS" = "darwin" ]; then
    brew install zsh;
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";
    chsh -s /bin/bash;
    ## source ~/.zshrc;
  fi

  echo -n "STOP to RE-RUN with zsh? (y/n) > "
  read to_stop
  is_true $to_stop && exit 0;
}

if [ "$MY_OS" = "darwin" ]; then
  brew cask info iterm2 || {
    brew cask install iterm2;
    curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.sh;
    source ~/.iterm2_shell_integration.sh;
    brew cask install \
        qlcolorcode \
        qlstephen \
        qlmarkdown \
        quicklook-json \
        qlprettypatch \
        quicklook-csv \
        webpquicklook;
      brew tap caskroom/fonts && brew cask install font-source-code-pro

    echo -n "STOP to RE-RUN with iTerm? (y/n) > "
    read to_stop
    is_true $to_stop && exit 0;
  }

  brew cask info suspicious-package || brew cask install suspicious-package
fi


printf "\n$SEPARATOR\n >>>>> SDK\n"
exist_cmd sdk || {
  curl -s "https://get.sdkman.io" | bash

  SDK_CONFIG=$(cat <<'EOF'
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
EOF
);

  find_append $MY_SH_CFG_FILE ".sdkman/bin/sdkman-init.sh" "$SDK_CONFIG"
  source $MY_SH_CFG_FILE
  sdk version
  sdk selfupdate force
}

(is_true $to_update && exist_cmd sdk) && sdk selfupdate force
(is_true $to_update && exist_cmd brew) && brew update --force
(is_true $to_update && exist_cmd zsh && exist_cmd upgrade_oh_my_zsh) && upgrade_oh_my_zsh

uname -a
printf ":: $SEPARATOR\n BREW:\n "
brew list --versions
echo ":: $SEPARATOR"
sdk version
sdk current
printf ":: $SEPARATOR\n GCC: "
gcc --version | head -1
echo ":: $SEPARATOR"

printf ":: $SEPARATOR\n\n"


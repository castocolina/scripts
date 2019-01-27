#!/bin/bash

export SEPARATOR="========================================================================================================================"
# http://sourabhbajaj.com/mac-setup/

export MY_SH_CFG_FILE=~/.zshrc4cco
touch $MY_SH_CFG_FILE

echo ""
echo $SEPARATOR
echo ">>>>> UPDATE ................"
echo $SEPARATOR
source $MY_SH_CFG_FILE
source install_func.sh
source install_url.sh

read -p "UPDATE? (y/n) > " to_update

exist_cmd aptitude || { sudo apt install -y aptitude; }
if is_true $to_update ; then
    sudo aptitude update -y
    sudo aptitude install linux-headers-$(uname -r) -y
fi

printf "\n$SEPARATOR\n >>>>>  ESSENTIALS\n"
exist_pkg "build-essential" || {
  printf "\n ::: Install build-essential ...\n"
  sudo aptitude install build-essential -y
}

exist_pkg linux-image-extra-virtual || sudo aptitude install -y linux-image-extra-virtual
# exist_pkg linux-image-extra-$(uname -r) || sudo aptitude install -y linux-image-extra-$(uname -r)
exist_pkg linux-headers-$(uname -r) || sudo aptitude install -y linux-headers-$(uname -r)
exist_pkg apt-transport-https || sudo aptitude install -y apt-transport-https
exist_pkg ca-certificates || sudo aptitude install -y ca-certificates
exist_pkg software-properties-common || sudo aptitude install -y software-properties-common
exist_pkg git || sudo aptitude install -y git
exist_pkg dkms || sudo aptitude install -y dkms

exist_cmd unzip || { sudo aptitude install -y unzip; }
exist_cmd pip || { sudo aptitude install -y python-pip; sudo -H pip install --upgrade pip; }
exist_setuptools=$(python -c "import sys; sys.exit(0) if 'setuptools' in sys.modules.keys() else sys.exit(1)")
$exist_setuptools || sudo -H pip install setuptools

exist_cmd corkscrew || { sudo apt install -y corkscrew; }

printf "\n$SEPARATOR\n >>>>>  BREW\n"
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

printf "\n$SEPARATOR\n >>>>> ZSH\n"
exist_cmd "zsh" || {
  printf "\n ::: Install ZSH for linux ...\n"
  rm -rf $HOME/.oh-my-zsh
  sudo aptitude install zsh -y
  #oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}


printf "\n$SEPARATOR\n >>>>> SDK\n"
exist_cmd sdk || {
  curl -s "https://get.sdkman.io" | bash

  SDK_CONFIG=$(cat <<'EOF'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
EOF
);
  
  echo "$SDK_CONFIG ----"
  find_append $MY_SH_CFG_FILE ".sdkman/bin/sdkman-init.sh" "$SDK_CONFIG"
  source $MY_SH_CFG_FILE
  sdk version
  sdk selfupdate force
}

printf "\n$SEPARATOR\n >>>>> NODE.js\n"
exist_cmd "nvm" || {
  brew install nvm
  NVM_CONFIG=$(cat <<'EOF'
export NVM_DIR="$HOME/.nvm"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
EOF
);
  echo "$NVM_CONFIG ----"
  find_append $MY_SH_CFG_FILE "NVM_DIR=" "$NVM_CONFIG"
  source $MY_SH_CFG_FILE
}

exist_cmd "node" || {
  nvm install 6 && nvm install 8 && nvm install 10 && nvm install node && nvm use 8
}
exist_cmd yarn || brew install yarn --without-node
exist_cmd react-native || npm install -g react-native
exist_cmd create-react-native-app || npm install -g create-react-native-app
exist_cmd nodemon || npm install -g nodemon
# sudo npm config delete prefix
#exist_cmd react-native-debugger || brew cask install react-native-debugger

printf "\n$SEPARATOR\n >>>>> JAVA / ANDROID\n"

exist_dir "$HOME/.sdkman/candidates/java/current/" || sdk install java 8.0.191-oracle
exist_cmd mvn || sdk install maven 3.6.0
exist_cmd gradle || sdk install gradle 5.1
#exist_cmd adb || brew cask install android-sdk android-platform-tools androidtool android-ndk android-studio
#export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"

printf "\n$SEPARATOR\n >>>>> MULTIMEDIA\n"
exist_cmd ffmpeg || { sudo apt install -y ffmpeg; }
exist_cmd mkvtoolnix-gui || { sudo apt install -y mkvtoolnix-gui; }
exist_pkg spotify-client >/dev/null 2>&1 || { sudo apt install -y spotify-client; }

printf "\n$SEPARATOR\n >>>>> OTHERS\n"
exist_cmd tree || brew install tree
exist_cmd vim || sudo aptitude install vim -y
exist_cmd go || brew install golang

printf "\n$SEPARATOR\n >>>>> DOCKER\n"
# sudo aptitude remove -y docker-ce
exist_cmd docker ||
{
  sudo apt-get remove docker docker-engine docker.io -y
  sudo aptitude install -y docker-ce
  echo "$SEPARATOR"
  sudo usermod -aG docker $USER
  sudo docker run hello-world
  sudo update-grub
  sudo ufw status
  sudo systemctl enable docker
  # /etc/default/ufw /etc/sysconfig/ufw
  #       DEFAULT_FORWARD_POLICY="ACCEPT"
  #sudo ufw allow 2376/tcp
  #sudo ufw reload

  #Edit the /etc/NetworkManager/NetworkManager.conf file.
  #Comment out the dns=dnsmasq line by adding a # character to the beginning of the line.
  # dns=dnsmasq
  sudo sed -i '/dns=dnsmasq/c\#dns=dnsmasq.' /etc/NetworkManager/NetworkManager.conf
  #Save and close the file.
  #Restart both NetworkManager and Docker. As an alternative, you can reboot your system.
  sudo restart network-manager
  sudo restart docker
}
#sudo -H pip install docker-compose
exist_cmd docker-compose && sudo -H pip install docker-compose

printf "\n$SEPARATOR\n >>>>> GUI\n"
exist_cmd meld ca-certificates|| { sudo apt install -y meld; }
exist_cmd filezilla ca-certificates|| { sudo apt install -y filezilla; }
exist_cmd subl || { sudo apt-get install -y sublime-text; }
exist_cmd rabbitvcs || {
  sudo aptitude install -y rabbitvcs-core rabbitvcs-cli
  type nautilus >/dev/null 2>&1 && { sudo aptitude install -y rabbitvcs-nautilus; }
  type nemo >/dev/null 2>&1 && { sudo aptitude install -y nemo-rabbitvcs; }
}

( exist_dir "$INSTALL_DIR/calibre" && echo "Calibre Installed" ) || {
  wget -nv -O- https://download.calibre-ebook.com/linux-installer.py |\
  python -c "import sys; main=lambda x,y:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main('$INSTALL_DIR', True)"

  create_sc "Calibre-ebook" "Calibre Ebook" "Calibre" "3" \
        "$INSTALL_DIR/calibre/calibre" "Utility;Graphics" \
        "epub, pdf, amazon, ebook, awz, awz3, mobi" \
        "$INSTALL_DIR/calibre/resources/images/lt.png" "256"

  create_sc "Calibre-Viewer" "Calibre Ebook - Viewer" "Calibre" "3" \
        "$INSTALL_DIR/calibre/ebook-viewer" "Utility;Graphics" \
        "epub, pdf, amazon, ebook, awz, awz3, mobi" \
        "$INSTALL_DIR/calibre/resources/images/viewer.png" "256"
}

install_deb google-chrome "Google Chrome" "$FILE_GCHROME" "$URL_GCHROME"
install_deb atom "Atom" "$FILE_ATOM" "$URL_ATOM"
install_deb code "VS Code" "$FILE_VSCODE" "$URL_VSCODE"
install_deb gitkraken "GitKraken" "$FILE_GITKRAKEN" "$URL_GITKRAKEN"
install_deb vagrant "Vagrant" "$FILE_VAGRANT" "$URL_VAGRANT"
install_deb masterpdfeditor5 "Master PDF Editor" "$FILE_MASTER_PDF" "$URL_MASTER_PDF"
install_deb virtualbox "Virtual Box" "$FILE_VB" "$URL_VB"


#Eclipse installer
down_uncompress "eclipse-installer" "eclipse-installer" "Eclipse Installer" "$FILE_ECLIPSE_INST" "$URL_ECLIPSE_INST" && {
  ICON_PATH="$INSTALL_DIR/eclipse-installer/icon.xpm";
  EXEC="$INSTALL_DIR/eclipse-installer/eclipse-inst";
  create_sc "eclipseinst" "Eclipse Installer" "Eclipse" "$VERSION_ECLIPSE_INST" \
    "$EXEC" "Development" "Java, JEE, JSE, IDE" "$ICON_PATH" "128";
}

#POSTMAN
# rm -rfv $INSTALL_DIR/postman/
down_uncompress "postman" "Postman" "Postman" "$FILE_POSTMAN" "$URL_POSTMAN" && {
  ICON_PATH="$INSTALL_DIR/postman/app/resources/app/assets/icon.png";
  EXEC="$INSTALL_DIR/postman/Postman";
  create_sc "Postman" "Postman" "Postman" "$VERSION_POSTMAN" \
    "$EXEC" "Development" "post, get, json, rest, api, request" "$ICON_PATH" "128"
}

# rm -rfv $HOME/opt/soapUI-*
down_install_soapui "4" "$FILE_SOAPUI4" "$URL_SOAPUI4"
down_install_soapui "5" "$FILE_SOAPUI5" "$URL_SOAPUI5"

#exist_cmd robo-3t || brew cask install robo-3t

find_append ~/.zshrc "source $MY_SH_CFG_FILE" "\n\n### Personal shell config \nsource $MY_SH_CFG_FILE"
source install_alias.sh

echo
sudo aptitude clean
sudo apt autoremove -y -f
echo

echo ":: $SEPARATOR"
echo ":: $SEPARATOR"
echo ":: $SEPARATOR"
uname -a
printf ":: $SEPARATOR\n BREW: "
brew list --versions
echo ":: $SEPARATOR"
sdk version
sdk current
printf ":: $SEPARATOR\n GCC: "
gcc --version | head -1
echo ":: $SEPARATOR"
python --version
echo ":: $SEPARATOR"
go version
echo ":: $SEPARATOR"
java -version
echo ":: $SEPARATOR"
git --version
printf ":: $SEPARATOR\n DOCKER: "
docker -v
printf ":: $SEPARATOR\n DOCKER-COMPOSE: "
docker-compose -v
printf ":: $SEPARATOR\n NVM: "
nvm --version
printf ":: $SEPARATOR\n NPM: "
npm --version
printf ":: $SEPARATOR\n NODE: "
node --version
printf ":: $SEPARATOR\n "


echo


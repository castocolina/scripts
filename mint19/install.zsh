#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo
echo $SEPARATOR
echo ">>>>> INSTALL EXCLUSIVE LINUX ................"
echo $SEPARATOR

source $BASEDIR/install_func.zsh
source $BASEDIR/install_url.zsh
source $MY_SH_CFG_FILE

echo -n "UPDATE? (y/n) > "
read to_update

exist_cmd aptitude || { sudo apt install -y aptitude; }
if is_true $to_update ; then
    sudo aptitude update -y
    sudo aptitude install linux-headers-$(uname -r) -y
    exist_cmd pip && sudo -H pip install --upgrade pip;
fi

printf "\n$SEPARATOR\n >>>>>  ESSENTIALS\n"
exist_pkg build-essential || sudo aptitude install build-essential -y
exist_pkg linux-image-extra-virtual || sudo aptitude install -y linux-image-extra-virtual
# exist_pkg linux-image-extra-$(uname -r) || sudo aptitude install -y linux-image-extra-$(uname -r)
exist_pkg linux-headers-$(uname -r) || sudo aptitude install -y linux-headers-$(uname -r)
exist_pkg apt-transport-https || sudo aptitude install -y apt-transport-https
exist_pkg ca-certificates || sudo aptitude install -y ca-certificates
exist_pkg software-properties-common || sudo aptitude install -y software-properties-common
exist_pkg bash-completion || sudo aptitude install -y bash-completion

# sudo apt-get install gcc-8 g++-8 -y && 
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-8 && 
# sudo update-alternatives --config gcc

exist_pkg git || sudo aptitude install -y git
exist_pkg dkms || sudo aptitude install -y dkms
exist_pkg xclip || sudo aptitude install -y xclip
exist_pkg xsel || sudo aptitude install -y xsel

exist_cmd unzip || { sudo aptitude install -y unzip; }
exist_cmd pip || { sudo aptitude install -y python-pip; sudo -H pip install --upgrade pip; }
exist_setuptools=$(python -c "import sys; sys.exit(0) if 'setuptools' in sys.modules.keys() else sys.exit(1)")
$exist_setuptools || sudo -H pip install setuptools

exist_cmd corkscrew || { sudo apt install -y corkscrew; }

export HOMEBREW_NO_AUTO_UPDATE=1
find_append $MY_SH_CFG_FILE "HOMEBREW_NO_AUTO_UPDATE" "export HOMEBREW_NO_AUTO_UPDATE=1\n"

exist_cmd watchman || brew install watchman;
exist_cmd watchman && is_true $to_update && brew upgrade watchman;

function download_install_rn_debugger(){
  install_deb react-native-debugger "RN Debugger" "rn_debugger.deb" "$URL_RN_DEBUGGER"
}
exist_cmd react-native-debugger || download_install_rn_debugger
exist_cmd react-native-debugger && is_true $to_update && download_install_rn_debugger;

printf "\n$SEPARATOR\n >>>>> OTHERS ANDROIDS DEPS \n"
exist_pkg cpu-checker || sudo aptitude install -y cpu-checker
exist_pkg qemu-kvm || sudo aptitude install -y qemu-kvm
exist_pkg libvirt-bin || sudo aptitude install -y libvirt-bin
exist_pkg ubuntu-vm-builder || sudo aptitude install -y ubuntu-vm-builder
exist_pkg bridge-utils || sudo aptitude install -y bridge-utils
exist_pkg ia32-libs || sudo aptitude install -y ia32-libs

sudo adduser $USER  kvm
sudo chmod o+x /dev/kvm

# Android Studio
down_uncompress "android-studio-ide" "android-studio" "Android Studio IDE" "$FILE_ANDROID_STUDIO" "$URL_ANDROID_STUDIO" && {
  ICON_PATH="$INSTALL_DIR/android-studio-ide/bin/studio.png";
  EXEC="$INSTALL_DIR/android-studio-ide/bin/studio.sh";
  create_sc "android-studio" "Android Studio IDE" "Android" "$VERSION_ANDROID_STUDIO" \
    "$EXEC" "Development" "Java, Android, IDE" "$ICON_PATH" "128";
}

printf "\n$SEPARATOR\n >>>>> MULTIMEDIA\n"
exist_cmd ffmpeg || { sudo apt install -y ffmpeg; }
exist_cmd mkvtoolnix-gui || { sudo apt install -y mkvtoolnix-gui; }
exist_pkg spotify-client || { sudo apt install -y spotify-client; }
exist_pkg brave-browser || { sudo apt install brave-browser; }

printf "\n$SEPARATOR\n >>>>> OTHERS\n"
exist_cmd tree || brew install tree
exist_cmd tree && is_true $to_update && brew upgrade tree;
exist_cmd vim || sudo aptitude install vim -y
exist_cmd vim && is_true $to_update && brew upgrade vim;

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
install_deb masterpdfeditor5 "Master PDF Editor" "$FILE_MASTER_PDF" "$URL_MASTER_PDF"
install_deb virtualbox "Virtual Box" "$FILE_VB" "$URL_VB"
install_deb slack "Slack" "$FILE_SLACK" "$URL_SLACK"
install_deb run_keybase "Key Base" "$FILE_KEYBASE" "$URL_KEYBASE"


#Eclipse installer
down_uncompress "eclipse-installer" "eclipse-installer" "Eclipse Installer" "$FILE_ECLIPSE_INST" "$URL_ECLIPSE_INST" && {
  ICON_PATH="$INSTALL_DIR/eclipse-installer/icon.xpm";
  EXEC="$INSTALL_DIR/eclipse-installer/eclipse-inst";
  create_sc "eclipseinst" "Eclipse Installer" "Eclipse" "$VERSION_ECLIPSE_INST" \
    "$EXEC" "Development" "Java, JEE, JSE, IDE" "$ICON_PATH" "128";
}

#POSTMAN
delete_confirm "postman" "Postman"

down_uncompress "postman" "Postman" "Postman" "$FILE_POSTMAN" "$URL_POSTMAN" && {
  ICON_PATH="$INSTALL_DIR/postman/app/resources/app/assets/icon.png";
  EXEC="$INSTALL_DIR/postman/Postman";
  create_sc "Postman" "Postman" "Postman" "$VERSION_POSTMAN" \
    "$EXEC" "Development" "post, get, json, rest, api, request" "$ICON_PATH" "128"
}

#Mongo DB
down_uncompress "mongodb4" "mongodb*" "MongoDB" "$FILE_MONGODB_4" "$URL_MONGODB_4" && {

  sudo mkdir -p /data/db
  sudo chown $USER:$USER /data/db
  MONGODB_4_CONFIG=$(cat <<'EOF'
export MONGODB_4_HOME="$HOME/opt/mongodb4"
export MONGODB_HOME="$MONGODB_4_HOME"
export PATH="$MONGODB_HOME/bin:$PATH"
EOF
);
  echo "$MONGODB_4_CONFIG ----"
  find_append $MY_SH_CFG_FILE "MONGODB_4_HOME=" "$MONGODB_4_CONFIG"
  source $MY_SH_CFG_FILE
}

#Robo Studio 3T
exist_dir "$INSTALL_DIR/studio-3t" || {
  down_install4j "studio-3t" "Robo Studio 3T" "$FILE_ROBO_STUDIO_3T" "$URL_ROBO_STUDIO_3T"

  ICON_PATH="$INSTALL_DIR/studio-3t/.install4j/Studio-3T.png";
  EXEC="$INSTALL_DIR/studio-3t/Studio-3T";
  create_sc "studio3t" "Robo Studio 3T" "robo3t" "$VERSION_ROBO_STUDIO_3T" \
    "$EXEC" "Development" \
    "no SQL, Database, non SQL, JSON, Mongo, MongoDB, Document, Javascript, JS" \
    "$ICON_PATH" "48"
}

#Data Grip
down_uncompress "DataGrip" "DataGrip-*" "DataGrip" "$FILE_DATAGRIP" "$URL_DATAGRIP" && {

  cp -f $INSTALL_DIR/DataGrip/bin/datagrip64.vmoptions $INSTALL_DIR/DataGrip/bin/datagrip64.vmoptions.original
  sed -i 's/-Xms.*/-Xms256m/' "$INSTALL_DIR/DataGrip/bin/datagrip64.vmoptions"
  sed -i 's/-Xmx.*/-Xmx1024m/' "$INSTALL_DIR/DataGrip/bin/datagrip64.vmoptions"

  ICON_PATH="$INSTALL_DIR/DataGrip/bin/datagrip.png";
  EXEC="$INSTALL_DIR/DataGrip/bin/datagrip.sh";
  create_sc "datagrip" "DataGrip" "JetBrains" "$VERSION_DATAGRIP" \
    "$EXEC" "Development" \
    "SQL, Database, DML, DDL, Oracle, MySQL, Postgres, PostgreSQL, IBM, DB2, SQL Server, Sybase, SQLite, Derby, HSQLDB, H2" \
    "$ICON_PATH" "128"
}

# rm -rfv $HOME/soapUI-*
down_install4j "soapUI-4" "soapUI v4" "$FILE_SOAPUI4" "$URL_SOAPUI4"
down_install4j "soapUI-5" "soapUI v5" "$FILE_SOAPUI5" "$URL_SOAPUI5"

#exist_cmd robo-3t || brew cask install robo-3t

find_append ~/.zshrc "source $MY_SH_CFG_FILE" "\n\n### Personal shell config \nsource $MY_SH_CFG_FILE"
source $BASEDIR/install_alias.zsh

echo
sudo aptitude clean
sudo apt autoremove -y -f
echo

echo ":: $SEPARATOR"
echo ":: $SEPARATOR"
echo ":: $SEPARATOR"
uname -a
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
git --version

echo


#!/bin/bash

# http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
# http://www.webupd8.org/2015/02/install-oracle-java-9-in-ubuntu-linux.html
SEPARATOR="======================================================"

#Download versions
VERSION_HAROOPAD=-v0.13.1-x64
FILE_HAROOPAD="haroopad$VERSION_HAROOPAD.deb"
URL_HAROOPAD="https://bitbucket.org/rhiokim/haroopad-download/downloads/$FILE_HAROOPAD"

VERSION_REMARKABLE=_1.87_all
FILE_REMARKABLE="remarkable$VERSION_REMARKABLE.deb"
URL_REMARKABLE="https://remarkableapp.github.io/files/$FILE_REMARKABLE"

VERSION_REMARKABLE=_1.87_all
FILE_REMARKABLE="remarkable$VERSION_REMARKABLE.deb"
URL_REMARKABLE="https://remarkableapp.github.io/files/$FILE_REMARKABLE"

#https://atom-installer.github.com/v1.13.0/atom-amd64.deb
FILE_ATOM=atom-amd64.deb
URL_ATOM="https://atom.io/download/deb"

#https://www.getpostman.com/app/download/linux64
VERSION_POSTMAN=4.9.x
FILE_POSTMAN=postman-linux-x64.tar.gz
URL_POSTMAN="https://dl.pstmn.io/download/latest/linux64"

#https://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
VERSION_MVN32=3.2.5
FILE_MVN32=apache-maven-$VERSION_MVN32-bin.tar.gz
URL_MVN32="https://archive.apache.org/dist/maven/maven-3/$VERSION_MVN32/binaries/$FILE_MVN32"

#http://www-us.apache.org/dist/axis/axis2/java/core/1.7.4/axis2-1.7.4-bin.zip
VERSION_AXIS2=1.7.4
FILE_AXIS2=axis2-$VERSION_AXIS2-bin.zip
URL_AXIS2="http://www-us.apache.org/dist/axis/axis2/java/core/$VERSION_AXIS2/$FILE_AXIS2"

#http://www.smartsvn.com/static/svn/download/smartsvn/smartsvn-linux-9_1_3.tar.gz
VERSION_SMARTSVN=9_1_3
FILE_SMARTSVN=smartsvn-linux-$VERSION_SMARTSVN.tar.gz
URL_SMARTSVN="http://www.smartsvn.com/static/svn/download/smartsvn/$FILE_SMARTSVN"

source /etc/os-release
source /etc/lsb-release

echo
echo $SEPARATOR
echo "ADD REPOSITORIES ......"
echo $SEPARATOR

#JAVA PPA
test -f "/etc/apt/sources.list.d/webupd8team-ubuntu-java-xenial.list" || sudo add-apt-repository ppa:webupd8team/java -y
#VIRTUAL BOX
if [ ! -f "/etc/apt/sources.list.d/virtualbox.list" ]; then
    if [ $ID == "ubuntu" ] || [ $ID == "debian" ]; then
      VBOX_REPO="deb http://download.virtualbox.org/virtualbox/debian $DISTRIB_CODENAME contrib"
    else
      VBOX_REPO="deb http://download.virtualbox.org/virtualbox/debian $UBUNTU_CODENAME contrib"
    fi
    echo "$VBOX_REPO" | sudo tee /etc/apt/sources.list.d/virtualbox.list

    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
fi

#DOCKER
if [ ! -f "/etc/apt/sources.list.d/docker.list" ]; then
    sudo apt-key adv \
                   --keyserver hkp://ha.pool.sks-keyservers.net:80 \
                   --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

    if [ $ID == "ubuntu" ] || [ $ID == "debian" ]; then
      DOCKER_REPO="deb https://apt.dockerproject.org/repo $ID-$DISTRIB_CODENAME main"
    else
      DOCKER_REPO="deb https://apt.dockerproject.org/repo $ID_LIKE-$UBUNTU_CODENAME main"
    fi
    
    echo "$DOCKER_REPO" | sudo tee /etc/apt/sources.list.d/docker.list
fi

#Spotify
if [ ! -f "/etc/apt/sources.list.d/spotify.list" ]; then
    # 1. Add the Spotify repository signing key to be able to verify downloaded packages
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
    # 2. Add the Spotify repository
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
fi

#RabbitVCS
#sudo add-apt-repository ppa:rabbitvcs/ppa -y

echo ""
echo $SEPARATOR
echo "UPDATE ................"
echo $SEPARATOR

read -p "UPDATE? (y/n) > " to_update

export USE_UPDATE=false

if [ "$to_update" = true ] || [ "$to_update" = "true" ] || [ "$to_update" = "1" ] || [ "$to_update" = "y" ]|| [ "$to_update" = "yes" ]; then
    export USE_UPDATE=true
fi

type aptitude >/dev/null 2>&1 || { sudo apt install -y aptitude; }
if [ "$USE_UPDATE" = true ]; then
    sudo aptitude update -y
fi

#if hash gdate 2>/dev/null; then
if [ ! -d "/usr/lib/jvm/java-8-oracle" ]; then
    echo
    echo $SEPARATOR
    echo "INSTALL JAVA .........."
    echo $SEPARATOR

    # oracle-java9-installer
    sudo aptitude install -y python-software-properties oracle-java6-installer oracle-java8-installer
    sudo update-alternatives --list java
    sudo update-alternatives --list javac
    java -version
    javac -version
    #sudo update-alternatives --config java
    #sudo update-alternatives --config javac

    JAVA="JAVA_HOME=/usr/lib/jvm/java-8-oracle"
    if ! grep -q "$JAVA" ~/.profile; then
        echo "" >> ~/.profile
        echo "export $JAVA" >> ~/.profile
        echo "PATH=\"\$PATH:\$JAVA_HOME/bin\"" >> ~/.profile
        echo "JAVA SET"
    fi
fi

sudo aptitude install -y oracle-java6-set-default

echo
echo $SEPARATOR
echo "COMMONS ..............."
echo $SEPARATOR

type unzip >/dev/null 2>&1 || { sudo apt install -y unzip; }
type git >/dev/null 2>&1 || { sudo apt install -y git; }
type svn >/dev/null 2>&1 || { sudo apt install -y subversion;  svn --version | head -2; }
type pip >/dev/null 2>&1 || { sudo apt install -y python-pip; sudo pip install --upgrade pip; }
type spotify >/dev/null 2>&1 || { sudo apt install -y spotify-client; }
type corkscrew >/dev/null 2>&1 || { sudo apt install -y corkscrew; }
type meld >/dev/null 2>&1 || { sudo apt install -y meld; }
type filezilla >/dev/null 2>&1 || { sudo apt install -y filezilla; }

#sudo aptitude install -y rabbitvcs-core rabbitvcs-cli
#sudo aptitude install rabbitvcs-nautilus
#sudo aptitude install rabbitvcs-gedit

echo
echo $SEPARATOR
echo "VBOX ................."
echo $SEPARATOR

type dkms >/dev/null 2>&1 || { sudo apt install -y dkms; }
type virtualbox >/dev/null 2>&1 || { sudo apt install -y virtualbox-5.1; }

if ! hash docker 2>/dev/null; then
    echo
    echo $SEPARATOR
    echo "DOCKER ................"
    echo $SEPARATOR

    sudo aptitude install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
    sudo aptitude install -y apt-transport-https ca-certificates
    sudo aptitude install -y docker-engine
    sudo service docker start
    sudo systemctl daemon-reload
    sudo systemctl restart docker

    sudo docker run hello-world
    sudo usermod -aG docker $USER
    sudo update-grub
    sudo ufw status
    sudo systemctl enable docker
    sudo pip install docker-compose

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
    #$ sudo restart network-manager
    # $ sudo restart docker
fi

CURR_DIR=$(pwd)
TMP_INSTALL_DIR=/tmp/installers

mkdir -p $TMP_INSTALL_DIR; cd $TMP_INSTALL_DIR

if [ ! -d "$HOME/opt" ] ; then
    mkdir -p "$HOME/opt"
fi

if ! hash vagrant 2>/dev/null; then
    echo
    echo $SEPARATOR
    echo "VAGRANT .............."
    echo $SEPARATOR
    #TODO: Download
    sudo dpkg -i vagrant_1.9.0_x86_64.deb
    vagrant plugin install vagrant-proxyconf
fi

if [ ! -d "$HOME/opt/smartsvn" ] ; then
  echo
  echo $SEPARATOR
  echo "SMART SVN ............."
  echo $SEPARATOR
    if [ ! -f "$FILE_SMARTSVN" ]; then
        echo "    $URL_SMARTSVN"
        curl -o $FILE_SMARTSVN -fSL $URL_SMARTSVN
    fi
    tar -zxf $FILE_SMARTSVN
    mv smartsvn/ $HOME/opt
    cd $HOME/opt/smartsvn/bin/
    bash add-menuitem.sh
    cd $TMP_INSTALL_DIR
fi

if [ ! -d "$HOME/opt/apache-maven-$VERSION_MVN32" ] ; then
  echo
  echo $SEPARATOR
  echo "MAVEN ................."
  echo $SEPARATOR

    if [ ! -f "$FILE_MVN32" ]; then
        echo "    $URL_MVN32"
        curl -o $FILE_MVN32 -fSL $URL_MVN32
    fi
    tar -zxf $FILE_MVN32
    mv apache-maven-$VERSION_MVN32/ $HOME/opt

    ## ADD
    MVN="MVN_HOME=~/opt/apache-maven-$VERSION_MVN32"
    if ! grep -q "$MVN" ~/.profile; then
        echo "" >> ~/.profile
        echo "export $MVN" >> ~/.profile
        echo "PATH=\"\$PATH:\$MVN_HOME/bin\"" >> ~/.profile
        echo "MAVEN SET"
    fi

    #test
    source $HOME/.profile
    mvn -version
fi

if [ ! -d "$HOME/opt/axis2-$VERSION_AXIS2" ] ; then
  echo
  echo $SEPARATOR
  echo "AXIS 2 ................"
  echo $SEPARATOR

    #curl -o $file -fSL $url
    if [ ! -f "$FILE_AXIS2" ]; then
        echo "    $URL_AXIS2"
        curl -o $FILE_AXIS2 -fSL $URL_AXIS2
    fi
    unzip -q $FILE_AXIS2
    mv axis2-1.7.4/ $HOME/opt

    ## ADD
    AXIS2="AXIS2_HOME=~/opt/axis2-$VERSION_AXIS2"
    if ! grep -q "$AXIS2" ~/.profile; then
        echo "" >> ~/.profile
        echo "export $AXIS2" >> ~/.profile
        echo "PATH=\"\$PATH:\$AXIS2_HOME/bin\"" >> ~/.profile
        echo "AXIS2 SET"
    fi

    #test
    source $HOME/.profile
    wsdl2java.sh -version | head -3
fi

echo
echo $SEPARATOR
echo "OTROS ................."
echo $SEPARATOR

#MarkDown
if ! hash haroopad 2>/dev/null; then
    echo "HAROOPAD ............."

    if [ ! -f "$FILE_HAROOPAD" ]; then
        echo "    $URL_HAROOPAD"
        curl -o $FILE_HAROOPAD -fSL $URL_HAROOPAD
    fi
    sudo dpkg -i $FILE_HAROOPAD
fi

if ! hash atom 2>/dev/null; then
    echo "ATOM ............."

    if [ ! -f "$FILE_ATOM" ]; then
        echo "    $URL_ATOM"
        touch $FILE_ATOM.tmp && chmod 400 $FILE_ATOM.tmp && rm -f $FILE_ATOM.tmp
        curl -o $FILE_ATOM.tmp -fSL $URL_ATOM
        mv -f $FILE_ATOM.tmp $FILE_ATOM
    fi

    if [ -f "$FILE_ATOM" ]; then
        sudo dpkg -i $FILE_ATOM
    fi
fi

if [ ! -d "$HOME/opt/postman" ] ; then
    echo "POSTMAN ............."

    if [ ! -f "$FILE_POSTMAN" ]; then
        echo "    $URL_POSTMAN"
        touch $FILE_POSTMAN.tmp && chmod 400 $FILE_POSTMAN.tmp && rm -f $FILE_POSTMAN.tmp
        curl -o $FILE_POSTMAN.tmp -fSL $URL_POSTMAN
        mv -f $FILE_POSTMAN.tmp $FILE_POSTMAN
    fi

    if [ -f "$FILE_POSTMAN" ] ; then
        tar -zxf $FILE_POSTMAN
        mv -f Postman postman
        mv -f postman/Postman postman/postman
        mv -f postman/ $HOME/opt

        DESKTOP_FILE=postman-$VERSION_POSTMAN.desktop

cat << EOF > $DESKTOP_FILE
[Desktop Entry]
Version=$VERSION_POSTMAN
Encoding=UTF-8
Name=POSTMAN
Keywords=post;json, rest
GenericName=POSTMAN
Type=Application
Categories=Development
Terminal=false
StartupNotify=true
Exec="$HOME/opt/postman/postman"
MimeType=x-directory/normal
Icon=$HOME/opt/postman/resources/app/assets/icon.png
X-Ayatana-Desktop-Shortcuts=NewWindow;
EOF

# seems necessary to refresh immediately:
chmod 644 $DESKTOP_FILE

xdg-desktop-menu install $DESKTOP_FILE
xdg-icon-resource install --size 128 "$HOME/opt/postman/resources/app/assets/icon.png" "postman-$VERSION_POSTMAN"

rm $DESKTOP_FILE

    fi

fi

if ! hash remarkable 2>/dev/null; then
     echo "REMARKABLE ..........."
     if [ ! -f "$FILE_REMARKABLE" ]; then
         echo "    $URL_REMARKABLE"
         curl -o $FILE_REMARKABLE -fSL $URL_REMARKABLE
     fi
     sudo dpkg -i $FILE_REMARKABLE
fi

if ! hash subl 2>/dev/null; then
    #TODO: Download
    sudo dpkg -i sublime-text_build-3126_amd64.deb
fi

SOAP_UI_DIR="$HOME/opt/SmartBear/SoapUI-5.2.1"
if [ ! -d "$SOAP_UI_DIR" ] ; then
    #TODO: Download
    echo SoapUI-x64-5.2.1.sh
    sh SoapUI-x64-5.2.1.sh -q -Dinstall4j.noProxyAutoDetect=true -splash "SOAPUI 5"\
     -dir $SOAP_UI_DIR
fi


#CLEAN ALL
cd $CURR_DIR
#rm -rf /tmp/installers
sudo aptitude clean
sudo apt autoremove -y -f
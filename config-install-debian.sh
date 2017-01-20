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

#source /etc/os-release
source /etc/lsb-release

echo 
echo $SEPARATOR
echo "ADD REPOSITORIES ......"
echo $SEPARATOR

#JAVA PPA
test -f "/etc/apt/sources.list.d/webupd8team-ubuntu-java-xenial.list" || sudo add-apt-repository ppa:webupd8team/java -y
#VIRTUAL BOX
if [ ! -f "/etc/apt/sources.list.d/virtualbox.list" ]; then
    VBOX_REPO="deb http://download.virtualbox.org/virtualbox/debian $DISTRIB_CODENAME contrib"
    echo "$VBOX_REPO" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
fi

#DOCKER
if [ ! -f "/etc/apt/sources.list.d/docker.list" ]; then
    sudo apt-key adv \
                   --keyserver hkp://ha.pool.sks-keyservers.net:80 \
                   --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    DOCKER_REPO="deb https://apt.dockerproject.org/repo $ID-$DISTRIB_CODENAME main"
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

sudo apt-get update -y


#if hash gdate 2>/dev/null; then
if [ ! -d "/usr/lib/jvm/java-8-oracle" ]; then
    echo 
    echo $SEPARATOR
    echo "INSTALL JAVA .........."
    echo $SEPARATOR

    # oracle-java9-installer
    sudo apt-get install -y python-software-properties oracle-java6-installer oracle-java8-installer oracle-java8-set-default
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

echo
echo $SEPARATOR
echo "COMMONS ..............."
echo $SEPARATOR

type unzip >/dev/null 2>&1 || { sudo apt install -y unzip; echo "UNZIP INSTALLED"; }
type git >/dev/null 2>&1 || { sudo apt install -y git; }
type svn >/dev/null 2>&1 || { sudo apt install -y subversion;  svn --version | head -2; }
type pip >/dev/null 2>&1 || { sudo apt install -y python-pip; sudo pip install --upgrade pip; }
type spotify >/dev/null 2>&1 || { sudo apt install -y spotify-client; }
type corkscrew >/dev/null 2>&1 || { sudo apt install -y corkscrew; }
type meld >/dev/null 2>&1 || { sudo apt install -y meld; }
type filezilla >/dev/null 2>&1 || { sudo apt install -y filezilla; }

#sudo apt-get install -y rabbitvcs-core rabbitvcs-cli
#sudo apt-get install rabbitvcs-nautilus
#sudo apt-get install rabbitvcs-gedit

echo
echo $SEPARATOR
echo "VBOX ................."
echo $SEPARATOR

type dkms >/dev/null 2>&1 || { sudo apt install -y dkms; }
type virtualbox >/dev/null 2>&1 || { sudo apt install -y virtualbox-5.1; }

if ! hash vagrant 2>/dev/null; then
    echo
    echo $SEPARATOR
    echo "VAGRANT .............."
    echo $SEPARATOR
    #TODO: Download
    sudo dpkg -i $CURR_DIR/vagrant_1.9.0_x86_64.deb
    vagrant plugin install vagrant-proxyconf
fi


if ! hash docker 2>/dev/null; then
    echo
    echo $SEPARATOR
    echo "DOCKER ................"
    echo $SEPARATOR
    sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
    sudo apt-get install -y apt-transport-https ca-certificates
    sudo apt-get install -y docker-engine
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

mkdir -p /tmp/installers; cd /tmp/installers

if [ ! -d "$HOME/opt" ] ; then
    mkdir -p "$HOME/opt"
fi

echo
echo $SEPARATOR
echo "SMART SVN ............."
echo $SEPARATOR


if [ ! -d "$HOME/opt/smartsvn" ] ; then
    #TODO: Download
    tar -zxf $CURR_DIR/smartsvn-linux-9_1_3.tar.gz
    mv smartsvn/ $HOME/opt
fi

echo
echo $SEPARATOR
echo "MAVEN ................."
echo $SEPARATOR
if [ ! -d "$HOME/opt/apache-maven-3.2.5" ] ; then
    #TODO: DOWNLOAD at https://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
    tar -zxf $CURR_DIR/apache-maven-3.2.5-bin.tar.gz
    mv apache-maven-3.2.5/ $HOME/opt

    ## ADD
    MVN="MVN_HOME=~/opt/apache-maven-3.2.5"
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

echo
echo $SEPARATOR
echo "AXIS 2 ................"
echo $SEPARATOR
if [ ! -d "$HOME/opt/axis2-1.7.4" ] ; then
    #TODO: Download 
    #curl -o $file -fSL $url
    unzip -q $CURR_DIR/axis2-1.7.4-bin.zip
    mv axis2-1.7.4/ $HOME/opt

    ## ADD
    AXIS2="AXIS2_HOME=~/opt/axis2-1.7.4"
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

# if ! hash remarkable 2>/dev/null; then
#     echo "REMARKABLE ..........."
#     if [ ! -f "$FILE_REMARKABLE" ]; then
#         echo "    $URL_REMARKABLE"
#         curl -o $FILE_REMARKABLE -fSL $URL_REMARKABLE
#     fi
#     sudo dpkg -i $FILE_REMARKABLE
# fi

if ! hash subl 2>/dev/null; then
    #TODO: Download
    sudo dpkg -i $CURR_DIR/sublime-text_build-3126_amd64.deb
fi

SOAP_UI_DIR="$HOME/opt/SmartBear/SoapUI-5.2.1"
if [ ! -d "$SOAP_UI_DIR" ] ; then
    #TODO: Download
    echo $CURR_DIR/SoapUI-x64-5.2.1.sh
    sh $CURR_DIR/SoapUI-x64-5.2.1.sh -q -Dinstall4j.noProxyAutoDetect=true -splash "SOAPUI 5"\
     -dir $SOAP_UI_DIR
fi


#CLEAN ALL
cd $CURR_DIR
#rm -rf /tmp/installers
sudo apt-get clean
sudo apt autoremove -y -f

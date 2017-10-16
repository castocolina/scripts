#!/bin/bash

#apache tomcat, glassfish
#vb extensions
#VB Guest additions
#Nodejs

# http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
# http://www.webupd8.org/2015/02/install-oracle-java-9-in-ubuntu-linux.html
SEPARATOR="======================================================"

#Download versions

#https://atom-installer.github.com/v1.13.0/atom-amd64.deb
FILE_ATOM=atom-amd64.deb
URL_ATOM="https://atom.io/download/deb"

#https://www.getpostman.com/app/download/linux64
VERSION_POSTMAN=5.3.0
FILE_POSTMAN="postman-linux-x64-$VERSION_POSTMAN.tar.gz"
URL_POSTMAN="https://dl.pstmn.io/download/latest/linux64"

#https://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
VERSION_MVN32=3.2.5
FILE_MVN32=apache-maven-$VERSION_MVN32-bin.tar.gz
URL_MVN32="https://archive.apache.org/dist/maven/maven-3/$VERSION_MVN32/binaries/$FILE_MVN32"

#https://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
VERSION_MVN35=3.5.0
FILE_MVN35=apache-maven-$VERSION_MVN35-bin.tar.gz
URL_MVN35="https://archive.apache.org/dist/maven/maven-3/$VERSION_MVN35/binaries/$FILE_MVN35"

#http://www-us.apache.org/dist/axis/axis2/java/core/1.7.4/axis2-1.7.4-bin.zip
VERSION_AXIS2=1.7.6
FILE_AXIS2=axis2-$VERSION_AXIS2-bin.zip
URL_AXIS2="http://www-us.apache.org/dist/axis/axis2/java/core/$VERSION_AXIS2/$FILE_AXIS2"

#http://www.smartsvn.com/static/svn/download/smartsvn/smartsvn-linux-9_1_3.tar.gz
VERSION_SMARTSVN=9_2_1
FILE_SMARTSVN=smartsvn-linux-$VERSION_SMARTSVN.tar.gz
URL_SMARTSVN="http://www.smartsvn.com/static/svn/download/smartsvn/$FILE_SMARTSVN"

#https://releases.hashicorp.com/vagrant/1.9.3/vagrant_1.9.3_x86_64.deb
VERSION_VAGRANT=1.9.3
FILE_VAGRANT="vagrant_${VERSION_VAGRANT}_x86_64.deb"
URL_VAGRANT="https://releases.hashicorp.com/vagrant/$VERSION_VAGRANT/$FILE_VAGRANT"

#https://download.sublimetext.com/sublime-text_build-3126_amd64.deb
VERSION_SUBLIME=3126_amd64
FILE_SUBLIME=sublime-text_build-$VERSION_SUBLIME.deb
URL_SUBLIME="https://download.sublimetext.com/$FILE_SUBLIME"

#http://cdn01.downloads.smartbear.com/soapui/5.3.0/SoapUI-x64-5.3.0.sh
VERSION_SOAPUI5=5.3.0
FILE_SOAPUI5=SoapUI-x64-$VERSION_SOAPUI5.sh
URL_SOAPUI5="http://cdn01.downloads.smartbear.com/soapui/$VERSION_SOAPUI5/$FILE_SOAPUI5"

#http://smartbearsoftware.com/distrib/soapui/4.0.1/soapUI-x32-4_0_1.sh
VERSION_SOAPUI4=4.0.1
FILE_SOAPUI4=soapUI-x32-4_0_1.sh
URL_SOAPUI4="http://smartbearsoftware.com/distrib/soapui/$VERSION_SOAPUI4/$FILE_SOAPUI4"

#https://www.gitkraken.com/download/linux-deb
VERSION_GITKRAKEN=2.5
FILE_GITKRAKEN=gitkraken-amd64.deb
URL_GITKRAKEN="https://release.gitkraken.com/linux/$FILE_GITKRAKEN"

#http://eclipse.c3sl.ufpr.br/oomph/epp/neon/R2a/eclipse-inst-linux64.tar.gz
VERSION_ECLIPSE_INST=R2a
FILE_ECLIPSE_INST=eclipse-inst-linux64.tar.gz
URL_ECLIPSE_INST="http://eclipse.c3sl.ufpr.br/oomph/epp/neon/$VERSION_ECLIPSE_INST/$FILE_ECLIPSE_INST"

#https://github.com/java-decompiler/jd-gui/releases/download/v1.4.0/jd-gui_1.4.0-0_all.deb
#https://github.com/java-decompiler/jd-gui/releases/download/v1.4.0/jd-gui-1.4.0.jar
VERSION_JAVADEC=1.4.0
FILE_JAVADEC=jd-gui_$VERSION_JAVADEC.jar
URL_JAVADEC="https://github.com/java-decompiler/jd-gui/releases/download/v$VERSION_JAVADEC/$FILE_JAVADEC"

#https://dl.google.com/dl/android/studio/ide-zips/2.3.3.0/android-studio-ide-162.4069837-linux.zip
VERSION_ANDSTUDIO=2.3.3.0
FILE_ANDSTUDIO=android-studio-ide-162.4069837-linux.zip
URL_ANDSTUDIO="https://dl.google.com/dl/android/studio/ide-zips/$VERSION_ANDSTUDIO/$FILE_ANDSTUDIO"

#https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
VERSION_ANDTOOLS=r25.2.3
FILE_ANDTOOLS=tools_$VERSION_ANDTOOLS-linux.zip
URL_ANDTOOLS="https://dl.google.com/android/repository/$FILE_ANDTOOLS"

#https://dl.google.com/android/repository/platform-tools-latest-linux.zip
VERSION_AND_PLATF_TOOLS=latest
FILE_AND_PLATF_TOOLS=platform-tools-latest-linux.zip
URL_AND_PLATF_TOOLS="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"

#https://services.gradle.org/distributions/gradle-3.4.1-all.zip
VERSION_GRADLE=3.4.1
FILE_GRADLE=gradle-$VERSION_GRADLE-all.zip
URL_GRADLE="https://services.gradle.org/distributions/$FILE_GRADLE"

#https://download-cf.jetbrains.com/idea/ideaIU-2017.2.3-no-jdk.tar.gz
VERSION_INTELLIJ_U=2017.2.3-no-jdk
FILE_INTELLIJ_U="ideaIU-$VERSION_INTELLIJ_U.tar.gz"
URL_INTELLIJ_U="https://download-cf.jetbrains.com/idea/$FILE_INTELLIJ_U"

#https://download-cf.jetbrains.com/idea/ideaIC-2017.2.3-no-jdk.tar.gz
VERSION_INTELLIJ_C=2017.2.3-no-jdk
FILE_INTELLIJ_C="ideaIC-$VERSION_INTELLIJ_C.tar.gz"
URL_INTELLIJ_C="https://download-cf.jetbrains.com/idea/$FILE_INTELLIJ_C"

#https://download-cf.jetbrains.com/datagrip/datagrip-2017.2.2.tar.gz
VERSION_DATAGRIP=2017.2.2
FILE_DATAGRIP="datagrip-$VERSION_DATAGRIP.tar.gz"
URL_DATAGRIP="https://download-cf.jetbrains.com/datagrip/$FILE_DATAGRIP"

#file://media/ccolina/DATA_MINT/Downloads/sqldeveloper-17.2.0.188.1159-no-jre.zip
VERSION_ORA_SQLDEVELOPER=17.2.0
FILE_ORA_SQLDEVELOPER="sqldeveloper-17.2.0.188.1159-no-jre.zip"
URL_ORA_SQLDEVELOPER="/media/ccolina/DATA_MINT/Downloads/$FILE_ORA_SQLDEVELOPER"

#http://mirror.predic8.com/membrane/monitor/linux-x86/membrane-monitor-linux-x86-gtk-3.2.2.tar.gz
VERSION_MEMBRANE=3.2.2
FILE_MEMBRANE="membrane-monitor-linux-x86-gtk-$VERSION_MEMBRANE.tar.gz"
URL_MEMBRANE="http://mirror.predic8.com/membrane/monitor/linux-x86/$FILE_MEMBRANE"

function create_sc(){
    PSNAME=$1
    PNAME=$2
    PVERSION=$3
    PEXEC=$4
    PCATEGORIES=$5
    PKEYS=$6
    PICON=$7
    PICON_SIZE=$8

    DESKTOP_FILE=$PSNAME-$PVERSION.desktop

    if [ ! -f "$DESKTOP_FILE" ] ; then
        rm -f $DESKTOP_FILE
    fi
    touch $DESKTOP_FILE

    echo "[Desktop Entry]" >> $DESKTOP_FILE
    echo "Version=$PVERSION" >> $DESKTOP_FILE
    echo "Encoding=UTF-8" >> $DESKTOP_FILE
    echo "Name=$PNAME" >> $DESKTOP_FILE
    echo "Keywords=$PKEYS" >> $DESKTOP_FILE
    echo "GenericName=$PNAME" >> $DESKTOP_FILE
    echo "Type=Application" >> $DESKTOP_FILE
    echo "Categories=$PCATEGORIES" >> $DESKTOP_FILE
    printf "Terminal=false\nStartupNotify=true\n" >> $DESKTOP_FILE
    printf "Exec=\"$PEXEC\"\nIcon=$PICON\n" >> $DESKTOP_FILE
    echo "X-Ayatana-Desktop-Shortcuts=NewWindow;" >> $DESKTOP_FILE

    # seems necessary to refresh immediately:
    chmod 755 $DESKTOP_FILE

    echo $DESKTOP_FILE
    echo "$SEPARATOR"
    cat $DESKTOP_FILE
    echo "$SEPARATOR"

    xdg-desktop-menu install $DESKTOP_FILE
    xdg-icon-resource install --size $PICON_SIZE "$PICON" "$PSNAME-$PVERSION"

    rm $DESKTOP_FILE
}

source /etc/os-release
source /etc/lsb-release

echo
echo $SEPARATOR
echo "ADD REPOSITORIES ......"
echo $SEPARATOR

#JAVA PPA
test -f "/etc/apt/sources.list.d/webupd8team-java-xenial.list" || sudo add-apt-repository ppa:webupd8team/java -y

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
# if [ ! -f "/etc/apt/sources.list.d/spotify.list" ]; then
#     # 1. Add the Spotify repository signing key to be able to verify downloaded packages
#     sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
#     # 2. Add the Spotify repository
#     echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
# fi

#RabbitVCS
## sudo add-apt-repository ppa:rabbitvcs/ppa -y

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
    sudo aptitude install linux-headers-$(uname -r) -y
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
read -p "UPDATE JAVA? (y/n) > " to_update

export USE_UPDATE=false

if [ "$to_update" = true ] || [ "$to_update" = "true" ] || [ "$to_update" = "1" ] || [ "$to_update" = "y" ]|| [ "$to_update" = "yes" ]; then
    export USE_UPDATE=true
fi

if [ "$USE_UPDATE" = true ]; then
  #sudo aptitude install -y oracle-java8-set-default
  sudo update-alternatives --config java
fi

echo
echo $SEPARATOR
echo "COMMONS ..............."
echo $SEPARATOR

type xmllint >/dev/null 2>&1 || { sudo apt install -y libxml2-utils; }
type unzip >/dev/null 2>&1 || { sudo apt install -y unzip; }
type git >/dev/null 2>&1 || { sudo apt install -y git; }
type svn >/dev/null 2>&1 || { sudo apt install -y subversion;  svn --version | head -2; }
type pip >/dev/null 2>&1 || { sudo apt install -y python-pip; sudo pip install --upgrade pip; }
type spotify >/dev/null 2>&1 || { sudo apt install -y spotify-client; }
type corkscrew >/dev/null 2>&1 || { sudo apt install -y corkscrew; }
type meld >/dev/null 2>&1 || { sudo apt install -y meld; }
type filezilla >/dev/null 2>&1 || { sudo apt install -y filezilla; }

if ! hash rabbitvcs 2>/dev/null; then
  type gedit >/dev/null 2>&1 && { sudo aptitude install -y gedit; }
  sudo aptitude install -y rabbitvcs-core rabbitvcs-cli rabbitvcs-gedit
  type nautilus >/dev/null 2>&1 && { sudo aptitude install -y rabbitvcs-nautilus; }
  type nemo >/dev/null 2>&1 && { sudo aptitude install -y nemo-rabbitvcs; }
fi

echo
echo $SEPARATOR
echo "VBOX ................."
echo $SEPARATOR

type dkms >/dev/null 2>&1 || { sudo apt install -y dkms; }
type virtualbox >/dev/null 2>&1 || \
    { sudo apt install -y virtualbox-5.1 linux-headers-generic virtualbox-dkms virtualbox-ext-pack\
    virtualbox-guest-additions-iso virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11\
    ; }

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
    sudo pip install setuptools
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
    if [ ! -f "$FILE_VAGRANT" ]; then
        echo "    $URL_VAGRANT"
        curl -o $FILE_VAGRANT -fSL $URL_VAGRANT
    fi
    sudo dpkg -i $FILE_VAGRANT
    vagrant plugin install vagrant-proxyconf
fi

if ! hash gitkraken 2>/dev/null; then
    echo
    echo $SEPARATOR
    echo "GITKRAKEN .............."
    echo $SEPARATOR
    if [ ! -f "$FILE_GITKRAKEN" ]; then
        echo "    $URL_GITKRAKEN"
        curl -o $FILE_GITKRAKEN -fSL $URL_GITKRAKEN
    fi
    sudo dpkg -i $FILE_GITKRAKEN
fi

# if ! hash jd-gui 2>/dev/null; then
#     echo
#     echo $SEPARATOR
#     echo "JAVA DECOMPILER .............."
#     echo $SEPARATOR
#     if [ ! -f "$FILE_JAVADEC" ]; then
#         echo "    $URL_JAVADEC"
#         curl -o $FILE_JAVADEC -fSL $URL_JAVADEC
#     fi
#     sudo dpkg -i $FILE_JAVADEC
# fi

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
    sed -i '/MimeType=/d' add-menuitem.sh
    bash add-menuitem.sh
    cd $TMP_INSTALL_DIR
fi

if [ ! -d "$HOME/opt/eclipse-installer" ] ; then
    echo
    echo $SEPARATOR
    echo "ECLIPSE INSTALLER ............."
    echo $SEPARATOR
    if [ ! -f "$FILE_ECLIPSE_INST" ]; then
        echo "    $URL_ECLIPSE_INST"
        curl -o $FILE_ECLIPSE_INST -fSL $URL_ECLIPSE_INST
    fi
    tar -zxf $FILE_ECLIPSE_INST
    mv eclipse-installer/ $HOME/opt
    #echo "-vm" >> "$HOME/opt/eclipse-installer/eclipse-inst.ini"
    #echo "/usr/lib/jvm/java-8-oracle/bin/javaw" >> "$HOME/opt/eclipse-installer/eclipse-inst.ini"

    DESKTOP_FILE=eclipse-installer-$VERSION_ECLIPSE_INST.desktop
    ICON_PATH="$HOME/opt/eclipse-installer/icon.xpm"

cat << EOF > $DESKTOP_FILE
[Desktop Entry]
Version=$VERSION_ECLIPSE_INST
Encoding=UTF-8
Name=Eclipse Installer
Keywords=Java, JEE, JSE, IDE
GenericName=Eclipse Installer
Type=Application
Categories=Development
Terminal=false
StartupNotify=true
Exec="$HOME/opt/eclipse-installer/eclipse-inst"
Icon=$ICON_PATH
X-Ayatana-Desktop-Shortcuts=NewWindow;
EOF

    # seems necessary to refresh immediately:
    chmod 644 $DESKTOP_FILE

    xdg-desktop-menu install $DESKTOP_FILE
    xdg-icon-resource install --size 128 "$ICON_PATH" "eclipse-inst-$VERSION_ECLIPSE_INST"

    rm $DESKTOP_FILE
fi

if [ ! -d "$HOME/opt/IntelliJ-Ultimate" ] ; then
    echo
    echo $SEPARATOR
    echo "IntelliJ Ultimate INSTALLER ............."
    echo $SEPARATOR
    if [ ! -f "$FILE_INTELLIJ_U" ]; then
        echo "    $URL_INTELLIJ_U"
        curl -o $FILE_INTELLIJ_U -fSL $URL_INTELLIJ_U
    fi
    mkdir -p $HOME/opt/IntelliJ-Ultimate
    tar -zxf $FILE_INTELLIJ_U
    mv idea-IU*/* $HOME/opt/IntelliJ-Ultimate/
    rm -rf idea-IU*/

    EXEC="$HOME/opt/IntelliJ-Ultimate/bin/idea.sh"
    ICON="$HOME/opt/IntelliJ-Ultimate/bin/idea.png"

    cp $HOME/opt/IntelliJ-Ultimate/bin/idea64.vmoptions $HOME/opt/IntelliJ-Ultimate/bin/idea64.vmoptions.original
    sed -i 's/-Xms.*/-Xms256m/' "$HOME/opt/IntelliJ-Ultimate/bin/idea64.vmoptions"
    sed -i 's/-Xmx.*/-Xmx1024m/' "$HOME/opt/IntelliJ-Ultimate/bin/idea64.vmoptions"

    create_sc "IntelliJ-Ultimate" "IDEA IntelliJ Ultimate Edition" "$VERSION_INTELLIJ_U" \
    "$EXEC" "Development" "Java, JEE, JSE, IDE, Groovy, Scala, Android" \
    "$ICON" "128"
fi

if [ ! -d "$HOME/opt/IntelliJ-CE" ] ; then
    echo
    echo $SEPARATOR
    echo "IntelliJ CE INSTALLER ............."
    echo $SEPARATOR
    if [ ! -f "$FILE_INTELLIJ_C" ]; then
        echo "    $URL_INTELLIJ_C"
        curl -o $FILE_INTELLIJ_C -fSL $URL_INTELLIJ_C
    fi
    mkdir -p $HOME/opt/IntelliJ-CE
    tar -zxf $FILE_INTELLIJ_C
    mv idea-IC*/* $HOME/opt/IntelliJ-CE/
    rm -rf idea-IC*/

    EXEC="$HOME/opt/IntelliJ-CE/bin/idea.sh"
    ICON="$HOME/opt/IntelliJ-CE/bin/idea.png"

    cp $HOME/opt/IntelliJ-CE/bin/idea64.vmoptions $HOME/opt/IntelliJ-CE/bin/idea64.vmoptions.original
    sed -i 's/-Xms.*/-Xms256m/' "$HOME/opt/IntelliJ-CE/bin/idea64.vmoptions"
    sed -i 's/-Xmx.*/-Xmx1024m/' "$HOME/opt/IntelliJ-CE/bin/idea64.vmoptions"

    create_sc "IntelliJ-CE" "IDEA IntelliJ Community Edition" "$VERSION_INTELLIJ_C" \
    "$EXEC" "Development" "Java, JEE, JSE, IDE, Groovy, Scala, Android" \
    "$ICON" "128"
fi

if [ ! -d "$HOME/opt/DataGrip" ] ; then
    echo
    echo $SEPARATOR
    echo "DataGrip INSTALLER ............."
    echo $SEPARATOR
    if [ ! -f "$FILE_DATAGRIP" ]; then
        echo "    $URL_DATAGRIP"
        curl -o $FILE_DATAGRIP -fSL $URL_DATAGRIP
    fi
    mkdir -p $HOME/opt/DataGrip
    tar -zxf $FILE_DATAGRIP
    mv DataGrip-*/* $HOME/opt/DataGrip/
    rm -rf DataGrip-*/

    EXEC="$HOME/opt/DataGrip/bin/datagrip.sh"
    ICON="$HOME/opt/DataGrip/bin/datagrip.png"

    cp $HOME/opt/DataGrip/bin/datagrip64.vmoptions $HOME/opt/DataGrip/bin/datagrip64.vmoptions.original
    sed -i 's/-Xms.*/-Xms256m/' "$HOME/opt/DataGrip/bin/datagrip64.vmoptions"
    sed -i 's/-Xmx.*/-Xmx1024m/' "$HOME/opt/DataGrip/bin/datagrip64.vmoptions"

    create_sc "DataGrip" "JetBrains DataGrip" "$VERSION_DATAGRIP" \
    "$EXEC" "Development" \
    "SQL, Database, DML, DDL, Oracle, MySQL, Postgres, PostgreSQL,, IBM, DB2, SQL Server, Sybase, SQLite, Derby, HSQLDB, H2" \
    "$ICON" "128"
fi

if [ ! -d "$HOME/opt/SQLDeveloper" ] ; then
    echo
    echo $SEPARATOR
    echo "SQLDeveloper INSTALLER ............."
    echo $SEPARATOR
    if [ ! -f "$FILE_" ]; then
        echo "    $URL_ORA_SQLDEVELOPER"
        #curl -o $FILE_ORA_SQLDEVELOPER -fSL $URL_ORA_SQLDEVELOPER
        cp -f $URL_ORA_SQLDEVELOPER $FILE_ORA_SQLDEVELOPER
    fi
    mkdir -p $HOME/opt/SQLDeveloper
    unzip -q $FILE_ORA_SQLDEVELOPER
    mv sqldeveloper*/* $HOME/opt/SQLDeveloper/
    rm -rf SQLDeveloper-*/

    EXEC="$HOME/opt/SQLDeveloper/sqldeveloper.sh"
    ICON="$HOME/opt/SQLDeveloper/sqldeveloper/doc/icon.png"

    create_sc "SQLDeveloper" "ORACLE SQLDeveloper" "$VERSION_ORA_SQLDEVELOPER" \
    "$EXEC" "Development" \
    "SQL, Database, DML, DDL, Oracle" \
    "$ICON" "59"
fi

if [ ! -d "$HOME/opt/Membrane" ] ; then
    echo
    echo $SEPARATOR
    echo "Membrane INSTALLER ............."
    echo $SEPARATOR
    if [ ! -f "$FILE_MEMBRANE" ]; then
        echo "    $URL_MEMBRANE"
        curl -o $FILE_MEMBRANE -fSL $URL_MEMBRANE
        sudo apt-get install libgtk-3-dev
    fi
    mkdir -p $HOME/opt/Membrane
    tar -zxf $FILE_MEMBRANE
    mv membrane-monitor-*/* $HOME/opt/Membrane/
    rm -rf membrane-monitor-*/

    EXEC="$HOME/opt/Membrane/membrane-monitor"
    ICON="$HOME/opt/Membrane/icon.xpm"

    create_sc "Membrane" "Oracle Membrane Monitor" "$VERSION_MEMBRANE" \
    "$EXEC" "Development" \
    "SOA, HTTP Proxy, Webservices, XML, json" \
    "$ICON" "48"
fi

if [ ! -d "$HOME/opt/apache-maven-$VERSION_MVN32" ] ; then
  echo
  echo $SEPARATOR
  echo "MAVEN 3.2.5 ................."
  echo $SEPARATOR

    if [ ! -f "$FILE_MVN32" ]; then
        echo "    $URL_MVN32"
        curl -o $FILE_MVN32 -fSL $URL_MVN32
    fi
    tar -zxf $FILE_MVN32
    mv apache-maven-$VERSION_MVN32/ $HOME/opt

    ## ADD
    MVN32="MVN32_HOME=~/opt/apache-maven-$VERSION_MVN32"
    if ! grep -q "$MVN32" ~/.profile; then
        echo "" >> ~/.profile
        echo "export $MVN32" >> ~/.profile
        #echo "PATH=\"\$PATH:\$MVN32_HOME/bin\"" >> ~/.profile
        echo "MAVEN 3.2.5 SET"
    fi

    #test
    source $HOME/.profile
    $MVN32/bin/mvn -version
fi

if [ ! -d "$HOME/opt/apache-maven-$VERSION_MVN35" ] ; then
  echo
  echo $SEPARATOR
  echo "MAVEN 3.5.0 ................."
  echo $SEPARATOR

    if [ ! -f "$FILE_MVN35" ]; then
        echo "    $URL_MVN35"
        curl -o $FILE_MVN35 -fSL $URL_MVN35
    fi
    tar -zxf $FILE_MVN35
    mv apache-maven-$VERSION_MVN35/ $HOME/opt

    ## ADD
    MVN35="MVN35_HOME=~/opt/apache-maven-$VERSION_MVN35"
    if ! grep -q "$MVN35" ~/.profile; then
        echo "" >> ~/.profile
        echo "export $MVN35" >> ~/.profile
        echo "export MVN_HOME=\$MVN35_HOME" >> ~/.profile
        echo "PATH=\"\$PATH:\$MVN_HOME/bin\"" >> ~/.profile
        echo "MAVEN 3.5.0 SET"
    fi

    #test
    source $HOME/.profile
    $MVN35/bin/mvn -version
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
    mv axis2-$VERSION_AXIS2/ $HOME/opt

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

        ICON_PATH="$HOME/opt/postman/resources/app/assets/icon.png"
        EXEC="$HOME/opt/postman/postman"

        create_sc "POSTMAN" "POSTMAN $VERSION_POSTMAN" "$VERSION_POSTMAN" \
        "$EXEC" "Development" "post;get;json, rest" \
        "$ICON_PATH" "128"

    fi
fi

if ! hash subl 2>/dev/null; then
  echo "SUBLIME ..........."
  if [ ! -f "$FILE_SUBLIME" ]; then
      echo "    $URL_SUBLIME"
      curl -o $FILE_SUBLIME -fSL $URL_SUBLIME
  fi
  sudo dpkg -i $FILE_SUBLIME
fi

SOAPUI5_DIR="$HOME/opt/soapUI-$VERSION_SOAPUI5"
if [ ! -d "$SOAPUI5_DIR" ] ; then
    echo "SOAPUI5 ..........."
    if [ ! -f "$FILE_SOAPUI5" ]; then
        echo "    $URL_SOAPUI5"
        curl -o $FILE_SOAPUI5 -fSL $URL_SOAPUI5
    fi
    echo $FILE_SOAPUI5
    sh $FILE_SOAPUI5 -q -Dinstall4j.noProxyAutoDetect=true -splash "SOAPUI 5 installer"\
     -dir $SOAPUI5_DIR
fi

SOAPUI4_DIR="$HOME/opt/soapUI-$VERSION_SOAPUI4"
if [ ! -d "$SOAPUI4_DIR" ] ; then
    echo "SOAPUI4 ..........."
    if [ ! -f "$FILE_SOAPUI4" ]; then
        echo "    $URL_SOAPUI4"
        curl -o $FILE_SOAPUI4 -fSL $URL_SOAPUI4
    fi
    echo $FILE_SOAPUI4
    sh $FILE_SOAPUI4 -q -Dinstall4j.noProxyAutoDetect=true -splash "SOAPUI 4 installer"\
     -dir $SOAPUI4_DIR
fi

if [ ! -d "$HOME/opt/android-platform-tools" ] ; then
  echo
  echo $SEPARATOR
  echo "Android Platform Tools ............."
  echo $SEPARATOR

  sudo apt-get install libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386

    if [ ! -f "$FILE_AND_PLATF_TOOLS" ]; then
        echo "    $URL_AND_PLATF_TOOLS"
        curl -o $FILE_AND_PLATF_TOOLS -fSL $URL_AND_PLATF_TOOLS
    fi
    unzip -q $FILE_AND_PLATF_TOOLS
    mv platform-tools/ $HOME/opt/android-platform-tools

    ## ADD
    AND_PLATFORM_TOOLS_HOME="AND_PLATFORM_TOOLS_HOME=$HOME/opt/android-platform-tools"
    if ! grep -q "$AND_PLATFORM_TOOLS_HOME" ~/.profile; then
        echo "" >> ~/.profile
        echo "#Android Platform Tools" >> ~/.profile
        echo "export $AND_PLATFORM_TOOLS_HOME" >> ~/.profile
        echo "PATH=\"\$PATH:\$AND_PLATFORM_TOOLS_HOME\"" >> ~/.profile
        echo "ANDROID TOOLS SET"
    fi

    #load
    source $HOME/.profile
    #test
    adb -version
fi

if [ ! -d "$HOME/opt/android-studio" ] ; then
  echo
  echo $SEPARATOR
  echo "Android Studio ................."
  echo $SEPARATOR

    if [ ! -f "$FILE_ANDSTUDIO" ]; then
        echo "    $URL_ANDSTUDIO"
        curl -o $FILE_ANDSTUDIO -fSL $URL_ANDSTUDIO
    fi
    unzip -q $FILE_ANDSTUDIO
    mv android-studio/ $HOME/opt

    EXEC="$HOME/opt/android-studio/bin/studio.sh"
    ICON_PATH="$HOME/opt/android-studio/bin/studio.png"

    create_sc "android-studio-$VERSION_ANDSTUDIO" "Android Studio" "$VERSION_ANDSTUDIO" \
        "$EXEC" "Development" "Java, JEE, JSE, IDE, Mobile, Android, Java" \
        "$ICON_PATH" "128"

fi

if [ ! -d "$HOME/opt/gradle-$VERSION_GRADLE" ] ; then
  echo
  echo $SEPARATOR
  echo "GRADLE ................."
  echo $SEPARATOR

    if [ ! -f "$FILE_GRADLE" ]; then
        echo "    $URL_GRADLE"
        curl -o $FILE_GRADLE -fSL $URL_GRADLE
    fi
    unzip -q $FILE_GRADLE
    mv gradle-$VERSION_GRADLE/ $HOME/opt

    ## ADD
    GRADLE="GRADLE_HOME=~/opt/gradle-$VERSION_GRADLE"
    if ! grep -q "$GRADLE" ~/.profile; then
        echo "" >> ~/.profile
        echo "export $GRADLE" >> ~/.profile
        echo "PATH=\"\$PATH:\$GRADLE_HOME/bin\"" >> ~/.profile
        echo "GRADLE SET"
    fi

    #test
    source $HOME/.profile
    gradle -v
fi

#ALIASES
ALIAS_DOKER_STATS="alias docker-stats='docker stats \$(docker ps --format={{.Names}})'"
if ! grep -q "$ALIAS_DOKER_STATS" ~/.profile; then
    echo "" >> ~/.profile
    echo "$ALIAS_DOKER_STATS" >> ~/.profile
    echo "DOCKER STATS ALIAS"
fi

ALIAS_MVN32="alias mvn32='~/opt/apache-maven-$VERSION_MVN32/bin/mvn'"
if ! grep -q "$ALIAS_MVN32" ~/.profile; then
    echo "" >> ~/.profile
    echo "$ALIAS_MVN32" >> ~/.profile
    echo "MAVEN $VERSION_MVN32 ALIAS"
fi

#test
source $HOME/.profile

#CLEAN ALL
cd $CURR_DIR
#rm -rf /tmp/installers
sudo aptitude clean
sudo apt autoremove -y -f

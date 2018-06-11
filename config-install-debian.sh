#!/bin/bash

BASEDIR=$(dirname "$0")
source $BASEDIR/config-install-debian-url.sh

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
# http://www.webupd8.org/2015/02/install-oracle-java-9-in-ubuntu-linux.html
#NEXT: https://www.linuxuprising.com/2018/04/install-oracle-java-10-in-ubuntu-or.html
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
    #wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
fi

#DOCKER
if [ ! -f "/etc/apt/sources.list.d/docker.list" ]; then

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo apt-key adv \
                   --keyserver hkp://ha.pool.sks-keyservers.net:80 \
                   --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

    if [ $ID == "ubuntu" ]; then
      DOCKER_REPO="deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    elif [ $ID == "debian" ]; then
      DOCKER_REPO="deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    else
      DOCKER_REPO="deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable"
    fi

    #sudo add-apt-repository "$DOCKER_REPO"
    echo "$DOCKER_REPO" | sudo tee /etc/apt/sources.list.d/docker.list
    read -p "DOCKER" aaaaaa
fi

#SUBLIME
if [ ! -f "/etc/apt/sources.list.d/sublime-text.list" ]; then
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

    sudo apt-get install apt-transport-https -y
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
fi

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
    echo "INSTALL JAVA 8.........."
    echo $SEPARATOR

    #JAVA 9 END OF LIFE (Apr 2018)
    sudo aptitude install -y python-software-properties oracle-java8-installer

    JAVA8="JAVA8_HOME=/usr/lib/jvm/java-8-oracle"
    if ! grep -q "$JAVA8" ~/.profile; then
        echo "" >> ~/.profile
        echo "export $JAVA8" >> ~/.profile
        echo "export JAVA_HOME=\$JAVA8_HOME" >> ~/.profile
        echo "PATH=\"\$PATH:\$JAVA_HOME/bin\"" >> ~/.profile
        echo "JAVA 8 SET"
    fi
fi

read -p "UPDATE JAVA? (y/n) > " to_update

export USE_UPDATE=false

if [ "$to_update" = true ] || [ "$to_update" = "true" ] || [ "$to_update" = "1" ] || [ "$to_update" = "y" ]|| [ "$to_update" = "yes" ]; then
    export USE_UPDATE=true
fi

if [ "$USE_UPDATE" = true ]; then
  sudo update-alternatives --config java
  sudo update-alternatives --config javac
  sudo update-alternatives --config javaws
fi

echo
echo $SEPARATOR
echo "COMMONS ..............."
echo $SEPARATOR

type xmllint >/dev/null 2>&1 || { sudo apt install -y libxml2-utils; }
type unzip >/dev/null 2>&1 || { sudo apt install -y unzip; }
type git >/dev/null 2>&1 || { sudo apt install -y git; }
type svn >/dev/null 2>&1 || { sudo apt install -y subversion;  svn --version | head -2; }
type pip >/dev/null 2>&1 || { sudo apt install -y python-pip; sudo -H pip install --upgrade pip; }
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


type subl >/dev/null 2>&1 || { sudo apt-get install -y sublime-text; }
sudo aptitude install -y ia32-libs

echo
echo $SEPARATOR
echo "VBOX ................."
echo $SEPARATOR

type dkms >/dev/null 2>&1 || { sudo apt install -y dkms; }
type virtualbox >/dev/null 2>&1 || \
    { sudo apt install -y virtualbox-5.2 linux-headers-generic virtualbox-dkms virtualbox-ext-pack\
    virtualbox-guest-additions-iso virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11\
    ; }

if ! hash docker 2>/dev/null; then
    echo
    echo $SEPARATOR
    echo "DOCKER ................"
    echo $SEPARATOR

    sudo aptitude install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
    sudo aptitude install -y apt-transport-https ca-certificates
    sudo aptitude install -y docker-ce
    sudo service docker start
    sudo systemctl daemon-reload
    sudo systemctl restart docker

    sudo docker run hello-world
    sudo usermod -aG docker $USER
    sudo update-grub
    sudo ufw status
    sudo systemctl enable docker
    sudo -H pip install setuptools

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
fi

if hash docker 2>/dev/null; then

    if ! hash docker-compose 2>/dev/null; then
        sudo -H pip install docker-compose
    fi

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

    ICON_PATH="$HOME/opt/eclipse-installer/icon.xpm"
    EXEC="$HOME/opt/eclipse-installer/eclipse-inst"

    create_sc "Eclipse-Installer" "Eclipse Installer" "$VERSION_ECLIPSE_INST" \
    "$EXEC" "Development" "Java, JEE, JSE, IDE" \
    "$ICON_PATH" "128"

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
    "SQL, Database, DML, DDL, Oracle, MySQL, Postgres, PostgreSQL, IBM, DB2, SQL Server, Sybase, SQLite, Derby, HSQLDB, H2" \
    "$ICON" "128"
fi

if [ ! -d "$HOME/opt/SQLDeveloper" ] ; then
    echo
    echo $SEPARATOR
    echo "SQLDeveloper INSTALLER ............."
    echo $SEPARATOR
    if [ ! -f "$FILE_ORA_SQLDEVELOPER" ]; then
        echo "    $URL_ORA_SQLDEVELOPER"
        #curl -o $FILE_ORA_SQLDEVELOPER -fSL $URL_ORA_SQLDEVELOPER
        #cp -f $URL_ORA_SQLDEVELOPER $FILE_ORA_SQLDEVELOPER
    fi

    if [ -f "$FILE_ORA_SQLDEVELOPER" ]; then
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

if [ ! -d "$HOME/opt/mongodb-$VERSION_MONGODB34" ] ; then
    echo
    echo $SEPARATOR
    echo "mongodb $VERSION_MONGODB34 INSTALLER ............."
    echo $SEPARATOR
    if [ ! -f "$FILE_MONGODB34" ]; then
        echo "    $URL_MONGODB34"
        curl -o $FILE_MONGODB34 -fSL $URL_MONGODB34
    fi
    mkdir -p $HOME/opt/mongodb-$VERSION_MONGODB34
    tar -zxf $FILE_MONGODB34
    mv mongodb-*$VERSION_MONGODB34*/* $HOME/opt/mongodb-$VERSION_MONGODB34
    rm -rf mongodb-*$VERSION_MONGODB34*/

    ## ADD
    MONGODB34="MONGODB34_HOME=~/opt/mongodb-$VERSION_MONGODB34"
    if ! grep -q "$MONGODB34" ~/.profile; then
        echo "" >> ~/.profile
        echo "export $MONGODB34" >> ~/.profile
        echo "MONGODB $VERSION_MONGODB34 SET"
    fi

    #test
    source $HOME/.profile
    $MONGODB34_HOME/bin/mongo -version
fi

if [ ! -d "$HOME/opt/jmeter-$VERSION_JMETER" ] ; then
    echo
    echo $SEPARATOR
    echo "JMeter v$VERSION_JMETER INSTALLER ............."
    echo $SEPARATOR
    if [ ! -f "$FILE_JMETER" ]; then
        echo "    $URL_JMETER"
        curl -o $FILE_JMETER -fSL $URL_JMETER
    fi

    if [ -f "$FILE_JMETER" ]; then
        mkdir -p $HOME/opt/jmeter-$VERSION_JMETER
        tar -zxf $FILE_JMETER
        mv apache-jmeter-*/* $HOME/opt/jmeter-$VERSION_JMETER
        rm -rf apache-jmeter-*/

        EXEC="$HOME/opt/jmeter-$VERSION_JMETER/bin/jmeter"
        ICON="$HOME/opt/jmeter-$VERSION_JMETER/docs/images/jmeter_square.png"

        create_sc "JMeter" "Apache JMeter" "$VERSION_JMETER" \
        "$EXEC" "Development" \
        "Load test, Unit test, Web, HTTP, SOA, REST"  "$ICON" "256"
    fi
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

if ! hash google-chrome 2>/dev/null; then
    echo "Google Chrome ............."

    if [ ! -f "$FILE_GCHROME" ]; then
        echo "    $URL_GCHROME"
        touch $FILE_GCHROME.tmp && chmod 400 $FILE_GCHROME.tmp && rm -f $FILE_GCHROME.tmp
        curl -o $FILE_GCHROME.tmp -fSL $URL_GCHROME
        mv -f $FILE_GCHROME.tmp $FILE_GCHROME
    fi

    if [ -f "$FILE_ATOM" ]; then
        sudo dpkg -i $FILE_ATOM
    fi
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

if ! hash masterpdfeditor4 2>/dev/null; then
    echo "MASTER PDF EDITOR ............."

    if [ ! -f "$FILE_MASTER_PDF" ]; then
        echo "    $URL_MASTER_PDF"
        touch $FILE_MASTER_PDF.tmp && chmod 400 $FILE_MASTER_PDF.tmp && rm -f $FILE_MASTER_PDF.tmp
        curl -o $FILE_MASTER_PDF.tmp -fSL $URL_MASTER_PDF
        mv -f $FILE_MASTER_PDF.tmp $FILE_MASTER_PDF
    fi

    if [ -f "$FILE_MASTER_PDF" ]; then
        sudo dpkg -i $FILE_MASTER_PDF
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

#https://github.com/exebetche/vlsub/
if [ ! -f "$HOME/.local/share/vlc/lua/extensions/vlsub.lua" ] ; then
  echo
  echo $SEPARATOR
  echo "VL-SUB ................."
  echo $SEPARATOR

    if [ ! -f "$FILE_VL_SUB" ]; then
        echo "    $URL_VL_SUB"
        curl -o $FILE_VL_SUB -fSL $URL_VL_SUB
    fi
    unzip -qo $FILE_VL_SUB
    mkdir -p "$HOME/.local/share/vlc/lua/extensions/"

    ls -la vlsub-master
    mv -f vlsub-master/vlsub.lua $HOME/.local/share/vlc/lua/extensions/
    mv -f vlsub-master/locale $HOME/.local/share/vlc/lua/extensions/userdata/vlsub/

    echo "VLSUB installed!"
fi

#ALIASES
ALIAS_DOKER_STATS="alias docker-stats='docker stats \$(docker ps --format={{.Names}})'"
if ! grep -q "$ALIAS_DOKER_STATS" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "$ALIAS_DOKER_STATS" >> ~/.bashrc
    echo "DOCKER STATS ALIAS"
fi

ALIAS_MVN32="alias mvn32='~/opt/apache-maven-$VERSION_MVN32/bin/mvn'"
if ! grep -q "$ALIAS_MVN32" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "$ALIAS_MVN32" >> ~/.bashrc
    echo "MAVEN $VERSION_MVN32 ALIAS"
fi

ALIAS_MVN32_JAVA6="alias mvn32-j6='JAVA_HOME=$JAVA6_HOME;~/opt/apache-maven-$VERSION_MVN32/bin/mvn'"
if ! grep -q "$ALIAS_MVN32_JAVA6" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "$ALIAS_MVN32_JAVA6" >> ~/.bashrc
    echo "MAVEN $VERSION_MVN32 whit JAVA 6 (mvn32-j6) ALIAS"
fi

ALIAS_MVN35_JAVA7="alias mvn35-j7='JAVA_HOME=$JAVA7_HOME;~/opt/apache-maven-$VERSION_MVN35/bin/mvn'"
if ! grep -q "$ALIAS_MVN35_JAVA7" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "$ALIAS_MVN35_JAVA7" >> ~/.bashrc
    echo "MAVEN $VERSION_MVN35 whit JAVA 7 (mvn35-j7) ALIAS"
fi

ALIAS_MVN35_JAVA8="alias mvn35-j8='JAVA_HOME=$JAVA8_HOME;~/opt/apache-maven-$VERSION_MVN35/bin/mvn'"
if ! grep -q "$ALIAS_MVN35_JAVA8" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "$ALIAS_MVN35_JAVA8" >> ~/.bashrc
    echo "MAVEN $VERSION_MVN35 whit JAVA 8 (mvn35-j8) ALIAS"
fi

#ALIAS_MONGODB34="alias mvn32='~/opt/apache-maven-$VERSION_MONGODB34/bin/mvn'"
#if ! grep -q "$ALIAS_MONGODB34" ~/.bashrc; then
#    echo "" >> ~/.bashrc
#    echo "$ALIAS_MONGODB34" >> ~/.bashrc
#    echo "MAVEN $VERSION_MONGODB34 ALIAS"
#fi

#test
source $HOME/.bashrc

#CLEAN ALL
cd $CURR_DIR
#rm -rf /tmp/installers
sudo aptitude clean
sudo apt autoremove -y -f

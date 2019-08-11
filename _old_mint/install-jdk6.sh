#!/bin/bash

INSTALLER_FILE="jdk-6u45-linux-x64.bin"
export INSTALL_JAVA6_HOME="/usr/lib/jvm/java-6-oracle"

bash $INSTALLER_FILE

sudo rm -rf $INSTALL_JAVA6_HOME
sudo mkdir -p $INSTALL_JAVA6_HOME

sudo mv jdk1.6*/* $INSTALL_JAVA6_HOME
rm -rf jdk1.6*/

JAVA6="JAVA6_HOME=$INSTALL_JAVA6_HOME"
if ! grep -q "$JAVA6" ~/.profile; then
    echo "" >> ~/.profile
    echo "export $JAVA6" >> ~/.profile
    echo "JAVA6 SET"
    source $HOME/.profile
fi

$JAVA6_HOME/bin/java -version

sudo update-alternatives --install "/usr/bin/java" "java" "$INSTALL_JAVA6_HOME/bin/java" 1080
sudo update-alternatives --install "/usr/bin/javac" "javac" "$INSTALL_JAVA6_HOME/bin/javac" 1080
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "$INSTALL_JAVA6_HOME/bin/javaws" 1080

sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config javaws

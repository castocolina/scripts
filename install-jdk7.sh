#!/bin/bash

INSTALLER_FILE="jdk-7u80-linux-x64.tar.gz"
export INSTALL_JAVA7_HOME="/usr/lib/jvm/java-7-oracle"

tar -zxf $INSTALLER_FILE

sudo rm -rf $INSTALL_JAVA7_HOME
sudo mkdir -p $INSTALL_JAVA7_HOME

sudo mv jdk1.7*/* $INSTALL_JAVA7_HOME
rm -rf jdk1.7*/


sudo update-alternatives --install "/usr/bin/java" "java" "$INSTALL_JAVA7_HOME/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "$INSTALL_JAVA7_HOME/bin/javac" 1
#sudo update-alternatives --install "/usr/bin/javaws" "javaws" "$INSTALL_JAVA7_HOME/bin/javaws" 1

sudo update-alternatives --config java
sudo update-alternatives --config javac
#sudo update-alternatives --config javaw

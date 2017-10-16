#!/bin/bash

INSTALLER_FILE="jdk-6u45-linux-x64.bin"
export INSTALL_JAVA6_HOME="/usr/lib/jvm/java-6-oracle"

bash $INSTALLER_FILE

sudo rm -rf $INSTALL_JAVA6_HOME
sudo mkdir -p $INSTALL_JAVA6_HOME

sudo mv jdk1.6*/* $INSTALL_JAVA6_HOME
rm -rf jdk1.6*/


sudo update-alternatives --install "/usr/bin/java" "java" "$INSTALL_JAVA6_HOME/bin/java" 2
sudo update-alternatives --install "/usr/bin/javac" "javac" "$INSTALL_JAVA6_HOME/bin/javac" 2
#sudo update-alternatives --install "/usr/bin/javaws" "javaws" "$INSTALL_JAVA7_HOME/bin/javaws" 1

sudo update-alternatives --config java
sudo update-alternatives --config javac
#sudo update-alternatives --config javaw

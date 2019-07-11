#!/bin/zsh

source /etc/os-release
source /etc/lsb-release

echo
echo $SEPARATOR
echo "ADD REPOSITORIES ......"
echo $SEPARATOR

#Download versions

#https://downloads.slack-edge.com/linux_releases/slack-desktop-3.4.2-amd64.deb
VERSION_SLACK="3.4.2"
FILE_SLACK=slack-desktop-$VERSION_SLACK-amd64.deb
URL_SLACK="https://downloads.slack-edge.com/linux_releases/$FILE_SLACK"

#https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
FILE_GCHROME=google-chrome-stable_current_amd64.deb
URL_GCHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

#https://update.code.visualstudio.com/1.30.1/linux-deb-x64/stable
VERSION_VSCODE="1.34.0"
FILE_VSCODE=vscode-amd64-$VERSION_VSCODE.deb
URL_VSCODE="https://update.code.visualstudio.com/$VERSION_VSCODE/linux-deb-x64/stable"

#https://www.gitkraken.com/download/linux-deb
FILE_GITKRAKEN=gitkraken-amd64.deb
URL_GITKRAKEN="https://release.gitkraken.com/linux/$FILE_GITKRAKEN"

#https://code-industry.net/public/master-pdf-editor-5.0.15_qt5.amd64.deb
VERSION_MASTER_PDF=5.2.20
FILE_MASTER_PDF="master-pdf-editor-${VERSION_MASTER_PDF}_qt5.amd64.deb"
URL_MASTER_PDF="https://code-industry.net/public/$FILE_MASTER_PDF"

#https://download.virtualbox.org/virtualbox/6.0.0/virtualbox-6.0_6.0.0-127566~Ubuntu~bionic_amd64.deb
VERSION_VB=6.0.0
FILE_VB="virtualbox-6.0_${VERSION_VB}-127566~Ubuntu~bionic_amd64.deb"
URL_VB="https://download.virtualbox.org/virtualbox/$VERSION_VB/$FILE_VB"

#https://releases.hashicorp.com/vagrant/2.2.2/vagrant_2.2.2_x86_64.deb
VERSION_VAGRANT=2.2.2
FILE_VAGRANT="vagrant_${VERSION_VAGRANT}_x86_64.deb"
URL_VAGRANT="https://releases.hashicorp.com/vagrant/$VERSION_VAGRANT/$FILE_VAGRANT"

#https://www.getpostman.com/app/download/linux64
VERSION_POSTMAN=6.7.1
FILE_POSTMAN="postman-linux-x64-$VERSION_POSTMAN.tar.gz"
URL_POSTMAN="https://dl.pstmn.io/download/latest/linux64"

#http://cdn01.downloads.smartbear.com/soapui/5.3.0/SoapUI-x64-5.3.0.sh
#https://s3.amazonaws.com/downloads.eviware/soapuios/5.4.0/SoapUI-x64-5.4.0.sh
VERSION_SOAPUI5=5.4.0
FILE_SOAPUI5=SoapUI-x64-$VERSION_SOAPUI5.sh
URL_SOAPUI5="https://s3.amazonaws.com/downloads.eviware/soapuios/$VERSION_SOAPUI5/$FILE_SOAPUI5"

#http://smartbearsoftware.com/distrib/soapui/4.0.1/soapUI-x32-4_0_1.sh
VERSION_SOAPUI4=4.0.1
FILE_SOAPUI4=soapUI-x32-4_0_1.sh
URL_SOAPUI4="http://smartbearsoftware.com/distrib/soapui/$VERSION_SOAPUI4/$FILE_SOAPUI4"

#http://eclipse.c3sl.ufpr.br/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz
#http://espejito.fder.edu.uy/eclipse/oomph/epp/2018-12/R/eclipse-inst-linux64.tar.gz
VERSION_ECLIPSE_INST=2018-12
FILE_ECLIPSE_INST=eclipse-inst-linux64.tar.gz
URL_ECLIPSE_INST="http://espejito.fder.edu.uy/eclipse/oomph/epp/$VERSION_ECLIPSE_INST/R/$FILE_ECLIPSE_INST"

#https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
VERSION_ANDROID_TOOLS=4333796
FILE_ANDROID_TOOLS="sdk-tools-linux-$VERSION_ANDROID_TOOLS.zip"
URL_ANDROID_TOOLS="https://dl.google.com/android/repository/$FILE_ANDROID_TOOLS"

#https://dl.google.com/dl/android/studio/ide-zips/3.2.1.0/android-studio-ide-181.5056338-linux.zip
#https://dl.google.com/dl/android/studio/ide-zips/3.3.0.20/android-studio-ide-182.5199772-linux.zip
VERSION_ANDROID_STUDIO=3.3.0.20
FILE_ANDROID_STUDIO=android-studio-ide-182.5199772-linux.zip
URL_ANDROID_STUDIO="https://dl.google.com/dl/android/studio/ide-zips/$VERSION_ANDROID_STUDIO/$FILE_ANDROID_STUDIO"

#https://repo.mongodb.org/apt/ubuntu/dists/bionic/mongodb-org/4.0/multiverse/binary-amd64/mongodb-org-server_4.0.5_amd64.deb
#http://downloads.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1804-4.0.5.tgz
VERSION_MONGODB_4=4.0.5
FILE_MONGODB_4="mongodb-linux-x86_64-ubuntu1804-$VERSION_MONGODB_4.tgz"
URL_MONGODB_4="http://downloads.mongodb.org/linux/$FILE_MONGODB_4"

#https://download.studio3t.com/studio-3t/linux/2018.6.1/studio-3t-linux-x64.tar.gz
VERSION_ROBO_STUDIO_3T=2018.6.1
FILE_ROBO_STUDIO_3T="studio-3t-linux-x64.tar.gz"
URL_ROBO_STUDIO_3T="https://download.studio3t.com/studio-3t/linux/$VERSION_ROBO_STUDIO_3T/$FILE_ROBO_STUDIO_3T"

#https://download-cf.jetbrains.com/idea/ideaIC-2017.2.3-no-jdk.tar.gz
VERSION_INTELLIJ_C=2017.2.5-no-jdk
FILE_INTELLIJ_C="ideaIC-$VERSION_INTELLIJ_C.tar.gz"
URL_INTELLIJ_C="https://download-cf.jetbrains.com/idea/$FILE_INTELLIJ_C"

#https://download-cf.jetbrains.com/datagrip/datagrip-2017.2.2.tar.gz
VERSION_DATAGRIP=2017.1.5
FILE_DATAGRIP="datagrip-$VERSION_DATAGRIP.tar.gz"
URL_DATAGRIP="https://download-cf.jetbrains.com/datagrip/$FILE_DATAGRIP"

#http://www-eu.apache.org/dist//jmeter/binaries/apache-jmeter-4.0.tgz
VERSION_JMETER=4.0
FILE_JMETER="apache-jmeter-$VERSION_JMETER.tgz"
URL_JMETER="http://www.us.apache.org/dist//jmeter/binaries/$FILE_JMETER"


# REPOSITORIES

if [ ! -f "/etc/apt/sources.list.d/sublime-text.list" ]; then
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

    sudo apt-get install apt-transport-https -y
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
fi

if [ ! -f "/etc/apt/sources.list.d/brave-browser.list" ]; then
    # ${UBUNTU_CODENAME}
    curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | \
     sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
    echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ xenial main" \
     | sudo tee /etc/apt/sources.list.d/brave-browser.list
fi

if [ ! -f "/etc/apt/sources.list.d/kubernetes.list" ]; then
    #${UBUNTU_CODENAME}
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -;
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list;
fi

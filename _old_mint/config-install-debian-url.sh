#!/bin/bash

SEPARATOR="======================================================"

#Download versions

#https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
FILE_GCHROME=google-chrome-stable_current_amd64.deb
URL_GCHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

#https://atom-installer.github.com/v1.22.0/atom-amd64.deb
FILE_ATOM=atom-amd64.deb
URL_ATOM="https://atom.io/download/deb"

#https://code-industry.net/public/master-pdf-editor-5.0.15_qt5.amd64.deb
VERSION_MASTER_PDF=5.0.15
FILE_MASTER_PDF="master-pdf-editor-${VERSION_MASTER_PDF}_qt5.amd64.deb"
URL_MASTER_PDF="https://code-industry.net/public/$FILE_MASTER_PDF"

#https://www.getpostman.com/app/download/linux64
VERSION_POSTMAN=6.1.3
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

#https://releases.hashicorp.com/vagrant/1.9.3/vagrant_1.9.3_x86_64.deb
VERSION_VAGRANT=2.1.1
FILE_VAGRANT="vagrant_${VERSION_VAGRANT}_x86_64.deb"
URL_VAGRANT="https://releases.hashicorp.com/vagrant/$VERSION_VAGRANT/$FILE_VAGRANT"

#http://cdn01.downloads.smartbear.com/soapui/5.3.0/SoapUI-x64-5.3.0.sh
#https://s3.amazonaws.com/downloads.eviware/soapuios/5.4.0/SoapUI-x64-5.4.0.sh
VERSION_SOAPUI5=5.4.0
FILE_SOAPUI5=SoapUI-x64-$VERSION_SOAPUI5.sh
URL_SOAPUI5="https://s3.amazonaws.com/downloads.eviware/soapuios/$VERSION_SOAPUI5/$FILE_SOAPUI5"

#http://smartbearsoftware.com/distrib/soapui/4.0.1/soapUI-x32-4_0_1.sh
VERSION_SOAPUI4=4.0.1
FILE_SOAPUI4=soapUI-x32-4_0_1.sh
URL_SOAPUI4="http://smartbearsoftware.com/distrib/soapui/$VERSION_SOAPUI4/$FILE_SOAPUI4"

#https://www.gitkraken.com/download/linux-deb
VERSION_GITKRAKEN=3.6.3
FILE_GITKRAKEN=gitkraken-amd64.deb
URL_GITKRAKEN="https://release.gitkraken.com/linux/$FILE_GITKRAKEN"

#http://eclipse.c3sl.ufpr.br/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz
VERSION_ECLIPSE_INST=oxygen-R
FILE_ECLIPSE_INST=eclipse-inst-linux64.tar.gz
URL_ECLIPSE_INST="http://eclipse.c3sl.ufpr.br/oomph/epp/oxygen/R/$FILE_ECLIPSE_INST"

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

#https://codeload.github.com/exebetche/vlsub/zip/master
VERSION_VL_SUB=0.10.2
FILE_VL_SUB=vlsub-master.zip
URL_VL_SUB="https://codeload.github.com/exebetche/vlsub/zip/master"

#https://download-cf.jetbrains.com/idea/ideaIU-2017.2.3-no-jdk.tar.gz
VERSION_INTELLIJ_U=2017.1.5-no-jdk
FILE_INTELLIJ_U="ideaIU-$VERSION_INTELLIJ_U.tar.gz"
URL_INTELLIJ_U="https://download-cf.jetbrains.com/idea/$FILE_INTELLIJ_U"

#https://download-cf.jetbrains.com/idea/ideaIC-2017.2.3-no-jdk.tar.gz
VERSION_INTELLIJ_C=2017.2.5-no-jdk
FILE_INTELLIJ_C="ideaIC-$VERSION_INTELLIJ_C.tar.gz"
URL_INTELLIJ_C="https://download-cf.jetbrains.com/idea/$FILE_INTELLIJ_C"

#https://download-cf.jetbrains.com/datagrip/datagrip-2017.2.2.tar.gz
VERSION_DATAGRIP=2017.1.5
FILE_DATAGRIP="datagrip-$VERSION_DATAGRIP.tar.gz"
URL_DATAGRIP="https://download-cf.jetbrains.com/datagrip/$FILE_DATAGRIP"

#file://media/ccolina/DATA_MINT/Downloads/sqldeveloper-17.2.0.188.1159-no-jre.zip
VERSION_ORA_SQLDEVELOPER=17.2.0
FILE_ORA_SQLDEVELOPER="sqldeveloper-17.2.0.188.1159-no-jre.zip"
URL_ORA_SQLDEVELOPER="/media/ccolina/DATA_MINT/Downloads/$FILE_ORA_SQLDEVELOPER"

#https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1604-3.4.10.tgz
VERSION_MONGODB34=3.4.10
FILE_MONGODB34="mongodb-linux-x86_64-enterprise-ubuntu1604-$VERSION_MONGODB34.tgz"
URL_MONGODB34="https://downloads.mongodb.com/linux/$FILE_MONGODB34"

#http://www-eu.apache.org/dist//jmeter/binaries/apache-jmeter-4.0.tgz
VERSION_JMETER=4.0
FILE_JMETER="apache-jmeter-$VERSION_JMETER.tgz"
URL_JMETER="http://www.us.apache.org/dist//jmeter/binaries/$FILE_JMETER"


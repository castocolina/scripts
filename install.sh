#!/bin/sh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo
echo $SEPARATOR
echo ">>>>> GENERAL INSTALL ................"
echo $SEPARATOR

source $BASEDIR/common/install_func.sh
MY_OS=$(get_os)

[ "$MY_OS" = "darwin" ] && source osx/install_software_basic_osx.sh
[ "$MY_OS" = "linux" ] && source ubuntu/install_software_basic_ubuntu.sh

source common/install_main.sh
source common/install_nodejs.sh
source common/install_code.sh
source common/install_golang.sh
source common/install_minikube.sh
source common/install_android.sh

[ "$MY_OS" = "darwin" ] && source osx/install_software_final_osx.sh
[ "$MY_OS" = "linux" ] && source ubuntu/install_software_final_ubuntu.sh

source common/install_alias.sh

brew cleanup
[ "$MY_OS" = "linux" ] && { sudo aptitude clean; sudo apt autoremove -y -f}

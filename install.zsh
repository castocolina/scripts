#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo
echo $SEPARATOR
echo ">>>>> GENERAL INSTALL ................"
echo $SEPARATOR

source $BASEDIR/common/install_func.zsh
MY_OS=$(get_os)

[ "$MY_OS" = "darwin" ] && source osx/install_software_basic_osx.zsh
[ "$MY_OS" = "linux" ] && source mint19/install_software_basic_mint19.zsh

source common/install_main.zsh
source common/install_nodejs.zsh
source common/install_code.zsh
source common/install_golang.zsh
source common/install_minikube.zsh
source common/install_android.zsh

[ "$MY_OS" = "darwin" ] && source osx/install_software_final_osx.zsh
[ "$MY_OS" = "linux" ] && source mint19/install_software_final_mint19.zsh

source common/install_alias.zsh

brew cleanup
[ "$MY_OS" = "linux" ] && { sudo aptitude clean; sudo apt autoremove -y -f}

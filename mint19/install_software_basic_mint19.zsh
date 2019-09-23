#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

source $BASEDIR/install_func.zsh
source $BASEDIR/../common/install_func.zsh
source $BASEDIR/install_url.zsh
source $MY_SH_CFG_FILE

echo
echo $SEPARATOR
echo ">>>>> INSTALL BASIC LINUX TOOLS................"
echo $SEPARATOR

echo -n "UPDATE? (y/n) > "
read to_update


exist_cmd aptitude || { sudo apt install -y aptitude; }
if is_true $to_update ; then
    sudo aptitude update -y
    sudo aptitude install linux-headers-$(uname -r) -y
    exist_cmd pip && sudo -H pip install --upgrade pip;
fi

printf "\n$SEPARATOR\n >>>>>  ESSENTIALS\n"
exist_pkg build-essential || sudo aptitude install build-essential -y
exist_pkg linux-image-extra-virtual || sudo aptitude install -y linux-image-extra-virtual
# exist_pkg linux-image-extra-$(uname -r) || sudo aptitude install -y linux-image-extra-$(uname -r)
exist_pkg linux-headers-$(uname -r) || sudo aptitude install -y linux-headers-$(uname -r)
exist_pkg apt-transport-https || sudo aptitude install -y apt-transport-https
exist_pkg ca-certificates || sudo aptitude install -y ca-certificates
exist_pkg software-properties-common || sudo aptitude install -y software-properties-common
exist_pkg bash-completion || sudo aptitude install -y bash-completion

# sudo apt-get install gcc-8 g++-8 -y && 
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-8 && 
# sudo update-alternatives --config gcc

exist_pkg git || sudo aptitude install -y git
exist_pkg dkms || sudo aptitude install -y dkms
exist_pkg xclip || sudo aptitude install -y xclip
exist_pkg xsel || sudo aptitude install -y xsel

exist_cmd unzip || { sudo aptitude install -y unzip; }
exist_cmd pip || { sudo aptitude install -y python-pip; sudo -H pip install --upgrade pip; }
exist_setuptools=$(python -c "import sys; sys.exit(0) if 'setuptools' in sys.modules.keys() else sys.exit(1)")
$exist_setuptools || sudo -H pip install setuptools

exist_cmd corkscrew || { sudo apt install -y corkscrew; }

printf "\n$SEPARATOR\n >>>>> FOR ANDROID \n"
exist_pkg cpu-checker || sudo aptitude install -y cpu-checker
exist_pkg qemu-kvm || sudo aptitude install -y qemu-kvm
exist_pkg libvirt-bin || sudo aptitude install -y libvirt-bin
exist_pkg ubuntu-vm-builder || sudo aptitude install -y ubuntu-vm-builder
exist_pkg bridge-utils || sudo aptitude install -y bridge-utils
exist_pkg ia32-libs || sudo aptitude install -y ia32-libs

sudo adduser $USER  kvm
sudo chmod o+x /dev/kvm

echo
sudo aptitude clean
sudo apt autoremove -y -f
echo

echo


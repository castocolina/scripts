source install_func.sh
source install_url.sh
source $MY_SH_CFG_FILE

#DOCKER
if [ ! -f "/etc/apt/sources.list.d/docker.list" ]; then

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo apt-key fingerprint 0EBFCD88

    if [ $ID == "ubuntu" ]; then
      DOCKER_REPO="deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    elif [ $ID == "debian" ]; then
      DOCKER_REPO="deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    else
      DOCKER_REPO="deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable"
    fi

    #sudo add-apt-repository "$DOCKER_REPO"
    echo "$DOCKER_REPO" | sudo tee /etc/apt/sources.list.d/docker.list
fi


#https://download.virtualbox.org/virtualbox/6.0.0/virtualbox-6.0_6.0.0-127566~Ubuntu~bionic_amd64.deb
VERSION_VB=6.0.0
FILE_VB="virtualbox-6.0_${VERSION_VB}-127566~Ubuntu~bionic_amd64.deb"
URL_VB="https://download.virtualbox.org/virtualbox/$VERSION_VB/$FILE_VB"

#https://releases.hashicorp.com/vagrant/2.2.2/vagrant_2.2.2_x86_64.deb
VERSION_VAGRANT=2.2.2
FILE_VAGRANT="vagrant_${VERSION_VAGRANT}_x86_64.deb"
URL_VAGRANT="https://releases.hashicorp.com/vagrant/$VERSION_VAGRANT/$FILE_VAGRANT"
#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo
echo $SEPARATOR
echo ">>>>> MINIKUBE ................"
echo $SEPARATOR

source $BASEDIR/install_func.zsh
source $MY_SH_CFG_FILE
MY_OS=$(get_os)

echo -n "UPDATE? (y/n) > "
read to_update

echo ""
echo $SEPARATOR
echo ">>>>> INSTAL K8 Developer Utilities ................"
echo $SEPARATOR


if [ "$MY_OS" = "darwin" ]; then
  sysctl kern.hv_support
  brew cask install docker
fi
if [ "$MY_OS" = "linux" ]; then
  egrep --color 'vmx|svm' /proc/cpuinfo

  printf "\n$SEPARATOR\n >>>>> DOCKER\n"
  # sudo aptitude remove -y docker-ce
  exist_cmd docker ||
  {
    sudo apt-get remove docker docker-engine docker.io -y
    sudo aptitude install -y docker-ce
    echo "$SEPARATOR"
    sudo usermod -aG docker $USER
    sudo docker run hello-world
    sudo update-grub
    sudo ufw status
    sudo systemctl enable docker
    #Edit the /etc/NetworkManager/NetworkManager.conf file.
    #Comment out the dns=dnsmasq line by adding a # character to the beginning of the line.
    # dns=dnsmasq
    sudo sed -i '/dns=dnsmasq/c\#dns=dnsmasq.' /etc/NetworkManager/NetworkManager.conf
    #Save and close the file.
    #Restart both NetworkManager and Docker. As an alternative, you can reboot your system.
    sudo restart network-manager
    sudo restart docker
  }
  #sudo -H pip install docker-compose
  exist_cmd docker-compose || sudo -H pip install docker-compose

fi

if [ "$MY_OS" = "darwin" ]; then
  (is_false $to_update && exist_cmd docker-machine-driver-hyperkit) || {
    echo "INSTALL HYPERKIT";
    curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-hyperkit \
    && chmod +x docker-machine-driver-hyperkit \
    && sudo mv docker-machine-driver-hyperkit /usr/local/bin/ \
    && sudo chown root:wheel /usr/local/bin/docker-machine-driver-hyperkit \
    && sudo chmod u+s /usr/local/bin/docker-machine-driver-hyperkit
  }
fi

(is_false $to_update && exist_cmd kubectl) || {
  echo "INSTALL KUBECTL";
  if [ "$MY_OS" = "linux" ]; then
    sudo apt-get install -y apt-transport-https;
    sudo apt-get install -y kubectl;
  fi
  if [ "$MY_OS" = "darwin" ]; then
    latest=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt);
    curl -fSLO https://storage.googleapis.com/kubernetes-release/release/$latest/bin/darwin/amd64/kubectl;
    chmod +x ./kubectl;
    sudo mv ./kubectl /usr/local/bin/kubectl;
  fi
}

(is_false $to_update && exist_cmd minikube) || {
  echo "INSTALL MINIKUBE";
  curl -fSLo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-$MY_OS-amd64;
  chmod +x minikube;
  sudo mv minikube /usr/local/bin
}

(is_false $to_update && exist_cmd kubeseal ) || {
  echo "INSTALL KUBESEAL";
  release=$(get_github_latest_release "bitnami-labs/sealed-secrets" "v0.8.1")
  echo "VERSION ($release)"
  curl -fSLo kubeseal https://github.com/bitnami-labs/sealed-secrets/releases/download/$release/kubeseal-$MY_OS-amd64;
  chmod +x kubeseal;
  sudo mv kubeseal /usr/local/bin;
}

(is_false $to_update && exist_cmd skaffold) || {
  echo "INSTALL SKAFFOLD";
  curl -fSLo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-$MY_OS-amd64;
  chmod +x skaffold;
  sudo mv skaffold /usr/local/bin;
}

exist_cmd kubectx || brew install kubectx
exist_cmd kubectx && is_true $to_update && brew upgrade kubectx

exist_cmd kube_ps1 || {
  brew install kube-ps1;
}

CONFIG_KUBE_PS1=$(cat <<'EOF'
PROMPT='$(kube_ps1)'$PROMPT
EOF
);
find_append $MY_SH_CFG_FILE "PROMPT='$(kube_ps1)'" "$CONFIG_KUBE_PS1"

exist_cmd kube-prompt || {
  curl -fSLO "https://github.com/c-bata/kube-prompt/releases/download/v1.0.6/kube-prompt_v1.0.6_$(echo $MY_OS)_amd64.zip";
  unzip kube-prompt_v1.0.6_$(echo $MY_OS)_amd64.zip
  chmod +x kube-prompt
  sudo mv ./kube-prompt /usr/local/bin/kube-prompt
  rm -rf kube-prompt_v1.0.6_$(echo $MY_OS)_amd64.zip
}

printf "\n\n:: $SEPARATOR\n "
docker -v
docker-compose -v
docker run hello-world
docker image rm -f hello-world

printf "\n:: $SEPARATOR\n kubectl: "
kubectl version --client --short
printf ":: $SEPARATOR\n minikube: "
minikube version
printf ":: $SEPARATOR\n skaffold: "
skaffold version
printf ":: $SEPARATOR\n "
kubeseal --version
printf ":: $SEPARATOR\n "

echo


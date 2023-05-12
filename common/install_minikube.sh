#!/bin/bash
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

source $BASEDIR/install_func.sh
source $MY_SH_CFG_FILE
MY_OS=$(get_os)

echo
echo $SEPARATOR
echo ">>>>> MINIKUBE ................"
echo $SEPARATOR

echo -n "UPDATE? (y/n) > "
read to_update

echo
echo $SEPARATOR
echo ">>>>> INSTAL K8 Developer Utilities ................"
echo $SEPARATOR

if is_true $to_update && [ "$MY_OS" = "linux" ]; then
    sudo aptitude update -y
fi

if [ "$MY_OS" = "darwin" ]; then
  sysctl kern.hv_support
  exist_cmd docker || brew cask install docker
  exist_cmd docker && is_true $to_update && brew cask upgrade docker
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

if [ "$MY_OS" = "linux" ]; then
  (is_false $to_update && exist_cmd docker-machine-driver-kvm2) || {
    echo "INSTALL KVM2";

    sudo apt install ebtables dnsmasq firewalld -y
    sudo systemctl restart libvirtd

    # install kvm2 driver
    curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 && \
    sudo install docker-machine-driver-kvm2 /usr/local/bin/
    rm -rf docker-machine-driver-kvm2

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

(is_false $to_update && exist_cmd helm ) || {
  echo "INSTALL HELM";
  release=$(get_github_latest_release "helm/helm" "v3.0.0-rc.3")
  echo "VERSION ($release)"
  curl -L https://git.io/get_helm.sh | bash
  helm init
}

exist_cmd kubectx || brew install kubectx
exist_cmd kubectx && is_true $to_update && brew upgrade kubectx

brew list kube-ps1 || {
  brew install kube-ps1;
}
brew list kube-ps1 && is_true $to_update && brew upgrade kube-ps1

CONFIG_KUBE_PS1=$(cat <<'EOF'
PROMPT='$(kube_ps1)'$PROMPT
EOF
);
find_append $MY_SH_CFG_FILE "$CONFIG_KUBE_PS1" "$CONFIG_KUBE_PS1"

(exist_cmd kube-prompt && is_false $to_update ) || {
  echo "INSTALL KUBE-PROMPT";
  release=$(get_github_latest_release "c-bata/kube-prompt" "v1.0.6")

  FILE_NAME="kube-prompt_$(echo $release)_$(echo $MY_OS)_amd64.zip"
  FILE_URL="https://github.com/c-bata/kube-prompt/releases/download/$release/$FILE_NAME"
  echo "VERSION ($release) --> $FILE_URL"

  curl -fSLO "$FILE_URL";
  unzip $FILE_NAME
  chmod +x kube-prompt
  sudo mv ./kube-prompt /usr/local/bin/kube-prompt
  rm -rf $FILE_NAME
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


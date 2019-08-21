#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo -n "UPDATE? (y/n) > "
read to_update

source $BASEDIR/install_func.zsh
source $MY_SH_CFG_FILE

is_true $to_update && sudo aptitude update -y

echo ""
echo $SEPARATOR
echo ">>>>> INSTAL K8 Developer Utilities ................"
echo $SEPARATOR

MY_OS=$(get_os)
if [ "$MY_OS" = "linux" ]; then
  egrep --color 'vmx|svm' /proc/cpuinfo
  exist_pkg dkms || sudo aptitude install -y dkms
  exist_pkg apt-transport-https || sudo aptitude install -y apt-transport-https
  exist_pkg bash-completion || sudo aptitude install -y bash-completion
else
  echo "IS OSX??? $MY_OS"
fi

(is_false $to_update && exist_cmd kubectl) || {
  if [ "$MY_OS" = "linux" ]; then
    echo "INSTALL KUBECTL";
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

exist_cmd kube-prompt || {
  curl -fSLO "https://github.com/c-bata/kube-prompt/releases/download/v1.0.6/kube-prompt_v1.0.6_$(echo $MY_OS)_amd64.zip";
  unzip kube-prompt_v1.0.6_$(echo $MY_OS)_amd64.zip
  chmod +x kube-prompt
  sudo mv ./kube-prompt /usr/local/bin/kube-prompt
  rm -rf kube-prompt_v1.0.6_$(echo $MY_OS)_amd64.zip
}

printf ":: $SEPARATOR\n kubectl: "
kubectl version --client --short
printf ":: $SEPARATOR\n minikube: "
minikube version
printf ":: $SEPARATOR\n skaffold: "
skaffold version
printf ":: $SEPARATOR\n "
kubeseal --version
printf ":: $SEPARATOR\n "

echo


#!/bin/bash
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"
# http://sourabhbajaj.com/mac-setup/
ZSH_COMPLETIONS_DIR=$HOME/.oh-my-zsh/completions
mkdir -p $ZSH_COMPLETIONS_DIR
export MY_ZSH_COMPLETION_MINIKUBE=$ZSH_COMPLETIONS_DIR/_minikube.zsh
export MY_ZSH_COMPLETION_KUBECTL=$ZSH_COMPLETIONS_DIR/_kubectl.zsh
export MY_ZSH_COMPLETION_KUBECTX=$ZSH_COMPLETIONS_DIR/_kubectx.zsh
export MY_ZSH_COMPLETION_KUBENS=$ZSH_COMPLETIONS_DIR/_kubens.zsh

echo ""
echo $SEPARATOR
echo ">>>>> INSTAL K8 Developer Utilities ................"
echo $SEPARATOR
source $BASEDIR/install_func.sh
source $MY_SH_CFG_FILE

egrep --color 'vmx|svm' /proc/cpuinfo

exist_pkg dkms || sudo aptitude install -y dkms
exist_pkg apt-transport-https || sudo aptitude install -y apt-transport-https

#check is installed VB
# install_deb virtualbox "Virtual Box" "$FILE_VB" "$URL_VB"


exist_cmd kubectl || { 
  sudo apt-get update && sudo apt-get install -y apt-transport-https;
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -;
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list;
  sudo apt-get update;
  sudo apt-get install -y kubectl;
}

exist_cmd minikube || { 
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube;
  sudo cp minikube /usr/local/bin && rm minikube
}

exist_cmd kubectx || brew install kubectx
exist_cmd kube_ps1 || {
  brew install kube-ps1;

  KUBE_PS1_COMMENT="#PS1 load config"
  KUBE_PS1_CONFIG=$(cat << EOF

$KUBE_PS1_COMMENT
source "/home/linuxbrew/.linuxbrew/opt/kube-ps1/share/kube-ps1.sh"
PS1='\$(kube_ps1)'\$PS1

EOF
);
    
  echo "   $KUBE_PS1_CONFIG ----"
  find_append $MY_SH_CFG_FILE "$KUBE_PS1_COMMENT" "$KUBE_PS1_CONFIG"
  source $MY_SH_CFG_FILE
}
exist_cmd kube-prompt || {
  wget https://github.com/c-bata/kube-prompt/releases/download/v1.0.6/kube-prompt_v1.0.6_linux_amd64.zip;
  unzip kube-prompt_v1.0.6_linux_amd64.zip
  chmod +x kube-prompt
  sudo mv ./kube-prompt /usr/local/bin/kube-prompt
}

if [ ! -f "$MY_ZSH_COMPLETION_MINIKUBE" ] ; then
  touch $MY_ZSH_COMPLETION_MINIKUBE
  echo "#!/bin/zsh" > "$MY_ZSH_COMPLETION_MINIKUBE"
  minikube completion zsh >> "$MY_ZSH_COMPLETION_MINIKUBE"
fi

if [ ! -f "$MY_ZSH_COMPLETION_KUBECTL" ] ; then
  touch $MY_ZSH_COMPLETION_KUBECTL
  echo "#!/bin/zsh" > "$MY_ZSH_COMPLETION_KUBECTL"
  kubectl completion zsh >> "$MY_ZSH_COMPLETION_KUBECTL"
fi

if [ ! -f "$MY_ZSH_COMPLETION_KUBECTX" ] ; then
  curl -o $MY_ZSH_COMPLETION_KUBECTX -fSL "https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubectx.zsh"
fi

if [ ! -f "$MY_ZSH_COMPLETION_KUBENS" ] ; then
  curl -o $MY_ZSH_COMPLETION_KUBENS -fSL "https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubens.zsh"
fi

minikube stop --alsologtostderr
# --gpu --vm-driver=kvm2
minikube start --alsologtostderr

set x && printf "\n\n $SEPARATOR\n USE: \n\t minikube dashboard --url --alsologtostderr\n to get URL of dashboard\n $SEPARATOR\n\n"

printf ":: $SEPARATOR\n kubectl: "
kubectl version
printf ":: $SEPARATOR\n minikube:"
minikube version
printf ":: $SEPARATOR\n "

echo


#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"
# http://sourabhbajaj.com/mac-setup/

#read -p "UPDATE? (y/n) > " to_update
echo -n "UPDATE? (y/n) > "
read to_update

export COMPLETION_KUBECTX=$HOME/.completion-kubectx.zsh;
export COMPLETION_KUBENS=$HOME/.completion-kubens.zsh;

echo ""
echo $SEPARATOR
echo ">>>>> INSTAL K8 Developer Utilities ................"
echo $SEPARATOR
source $BASEDIR/install_func.sh
source $MY_SH_CFG_FILE

egrep --color 'vmx|svm' /proc/cpuinfo

exist_pkg dkms || sudo aptitude install -y dkms
exist_pkg apt-transport-https || sudo aptitude install -y apt-transport-https
exist_pkg bash-completion || sudo aptitude install -y bash-completion

#check is installed VB
# install_deb virtualbox "Virtual Box" "$FILE_VB" "$URL_VB"

(is_false $to_update && exist_cmd minikube) || {
  echo "INSTALL MINIKUBE";
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64;
  chmod +x minikube;
  sudo mv minikube /usr/local/bin
}

(is_false $to_update && exist_cmd skaffold) || {
  echo "INSTALL SKAFFOLD";
  curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64;
  chmod +x skaffold;
  sudo mv skaffold /usr/local/bin;
}

(is_false $to_update && exist_cmd kubectl) || {
  echo "INSTALL KUBECTL";
  sudo apt-get update && sudo apt-get install -y apt-transport-https;
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -;
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list;
  sudo apt-get update;
  sudo apt-get install -y kubectl;
}

exist_cmd kubectx || brew install kubectx
exist_cmd kubectx && is_true $to_update && brew upgrade kubectx

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

#### MINIKUBE COMPLETION
MINIKUBE_COMMENT="#MINIKUBE load config"
MINIKUBE_CONFIG=$(cat << EOF

$MINIKUBE_COMMENT
source <(minikube completion zsh)

EOF
);
    
  echo "   $MINIKUBE_CONFIG ----"
  find_append $MY_SH_CFG_FILE "$MINIKUBE_COMMENT" "$MINIKUBE_CONFIG"
  source $MY_SH_CFG_FILE

#### KUBECTL COMPLETION
KUBECTL_COMMENT="#KUBECTL load config"
KUBECTL_CONFIG=$(cat << EOF

$KUBECTL_COMMENT
source <(kubectl completion zsh)

EOF
);
    
  echo "   $KUBECTL_CONFIG ----"
  find_append $MY_SH_CFG_FILE "$KUBECTL_COMMENT" "$KUBECTL_CONFIG"
  source $MY_SH_CFG_FILE

#### KUBECTX COMPLETION
if [ ! -f "$COMPLETION_KUBECTX" ] ; then
  rm -rf $COMPLETION_KUBECTX
  curl -o $COMPLETION_KUBECTX -fSL "https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubectx.zsh"

KUBECTX_COMMENT="#KUBECTX load config"
KUBECTX_CONFIG=$(cat << EOF

$KUBECTX_COMMENT
source $COMPLETION_KUBECTX

EOF
);
    
  echo "   $KUBECTX_CONFIG ----"
  find_append $MY_SH_CFG_FILE "$KUBECTX_COMMENT" "$KUBECTX_CONFIG"
  source $MY_SH_CFG_FILE
fi

#### KUBENS COMPLETION
if [ ! -f "$COMPLETION_KUBENS" ] ; then
  rm -rf $COMPLETION_KUBENS
  curl -o $COMPLETION_KUBENS -fSL "https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubens.zsh"
  
KUBENS_COMMENT="#KUBENS load config"
KUBENS_CONFIG=$(cat << EOF

$KUBENS_COMMENT
source $COMPLETION_KUBENS

EOF
);
    
  echo "   $KUBENS_CONFIG ----"
  find_append $MY_SH_CFG_FILE "$KUBENS_COMMENT" "$KUBENS_CONFIG"
  source $MY_SH_CFG_FILE
fi

# minikube stop --alsologtostderr
# # --gpu --vm-driver=kvm2
# minikube start --alsologtostderr

# set x && printf "\n\n $SEPARATOR\n USE: \n\t minikube dashboard --url --alsologtostderr\n to get URL of dashboard\n $SEPARATOR\n\n"

printf ":: $SEPARATOR\n kubectl: "
kubectl version
printf ":: $SEPARATOR\n minikube: "
minikube version
printf ":: $SEPARATOR\n skaffold: "
skaffold version
printf ":: $SEPARATOR\n "

echo


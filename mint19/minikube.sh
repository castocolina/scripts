#!/bin/bash

sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"
# http://sourabhbajaj.com/mac-setup/

export MY_ZSH_COMPLETION_MINIKUBE=~/.zsh_minikube
export MY_ZSH_COMPLETION_KUBECTL=~/.zsh_kubectl

echo ""
echo $SEPARATOR
echo ">>>>> INSTAL K8 Developer Utilities ................"
echo $SEPARATOR
source install_func.sh
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

COMPLETION_COMMENT="#Load minikube & kubectl completion for zsh"
KUBE_CONFIG=$(cat << EOF

$COMPLETION_COMMENT
zsh $MY_ZSH_COMPLETION_KUBECTL
zsh $MY_ZSH_COMPLETION_MINIKUBE

EOF
);
  
echo "   $KUBE_CONFIG ----"
find_append $MY_SH_CFG_FILE "$COMPLETION_COMMENT" "$KUBE_CONFIG"
source $MY_SH_CFG_FILE

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


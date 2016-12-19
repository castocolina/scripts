#!/bin/bash

SSH_KEYNAME="myemail@example.com"
if [ $# -eq 0 ] || [ -z "$1" ]; then
    echo "No arguments supplied"
else
    SSH_KEYNAME="$1"
fi

# https://help.github.com/articles/generating-an-ssh-key/
SSH_KEYFILE="$HOME/.ssh/$SSH_KEYNAME"
if [ ! -f "$SSH_KEYFILE" ] ; then
    echo "CREATE SSH KEY FOR $SSH_KEYFILE"

    ssh-keygen -t rsa -f $SSH_KEYFILE -b 4096 -C $SSH_KEYNAME
    eval "$(ssh-agent -s)"
    ssh-add $SSH_KEYFILE
fi

echo 
echo "PUBLIC KEYS..."
ls $HOME/.ssh/*.pub

if [ -z "xclip" ]; then
    sudo apt-get -y install xclip
fi

xclip -sel clip < $SSH_KEYFILE.pub

echo
echo "Copies the contents of the "$SSH_KEYFILE.pub" (public key) file to your clipboard..."
echo 
cat $SSH_KEYFILE.pub
echo


#https://help.github.com/articles/using-ssh-over-the-https-port/
sshcfile="$HOME/.ssh/config"
if [ ! -f "$sshfile" ] ; then
    touch $sshcfile
    printf "" > $sshcfile
fi

if ! grep -q "github" $sshcfile; then
    echo "Host github.com" >> $sshcfile
    echo "    Hostname ssh.github.com" >> $sshcfile
    echo "    Port 443" >> $sshcfile
    echo "" >> $sshcfile
fi

cat $sshcfile
echo

ssh -T git@github.com
echo
#!/bin/bash

SEPARATOR="---------------------"
SSH_KEYNAME="myemail@example.com"
if [ $# -eq 0 ] || [ -z "$1" ]; then
    echo "No arguments supplied"
    read -p "Enter your key name (default: '$SSH_KEYNAME' > " key
    [ ! -z "$key" ] && SSH_KEYNAME=$key
else
    SSH_KEYNAME="$1"
fi

#FILE_ALPHAN_NAME=$(echo "$SSH_KEYNAME" | tr -c '[[:alnum:]].-' '_')
FILE_ALPHAN_NAME=$(echo $SSH_KEYNAME | sed -r 's/[^a-z0-9\.]/_/g')

# https://help.github.com/articles/generating-an-ssh-key/
SSH_KEYFILE="$HOME/.ssh/$FILE_ALPHAN_NAME"
if [ ! -f "$SSH_KEYFILE" ] ; then
    echo "CREATE SSH KEY FOR $SSH_KEYFILE"

    ssh-keygen -t rsa -f $SSH_KEYFILE -b 4096 -C $SSH_KEYNAME
fi

eval "$(ssh-agent -s)"
ssh-add $SSH_KEYFILE

echo
echo "PUBLIC KEYS..."
ls $HOME/.ssh/*.pub

type xclip >/dev/null 2>&1 || { sudo apt install -y xclip; }

xclip -sel clip < $SSH_KEYFILE.pub

echo
echo "Copies the contents of the "$SSH_KEYFILE.pub" (public key) file to your clipboard..."
echo
cat $SSH_KEYFILE.pub
echo


#https://help.github.com/articles/using-ssh-over-the-https-port/
sshcfile="$HOME/.ssh/config"
if [ ! -f "$sshcfile" ] ; then
    echo "NOT EXIST ... $sshcfile"
    touch $sshcfile
    printf "" > $sshcfile
fi

if ! grep -q "github" $sshcfile; then
    echo "CFG GH"
    echo "Host github.com" >> $sshcfile
    echo "    Hostname ssh.github.com" >> $sshcfile
    echo "    Port 443" >> $sshcfile
    echo "#   ProxyCommand corkscrew %h %p" >> $sshcfile
    echo "" >> $sshcfile
fi
if ! grep -q "bitbucket" $sshcfile; then
    echo "CFG BB"
    echo "Host bitbucket.org" >> $sshcfile
    echo "    Hostname altssh.bitbucket.org" >> $sshcfile
    echo "    Port 443" >> $sshcfile
    echo "#   ProxyCommand corkscrew %h %p" >> $sshcfile
    echo "" >> $sshcfile
fi
if ! grep -q "gitlab" $sshcfile; then
    echo "CFG GL"
    echo "Host gitlab.com" >> $sshcfile
    echo "    Hostname altssh.gitlab.com" >> $sshcfile
    echo "    Port 443" >> $sshcfile
    echo "#   ProxyCommand corkscrew %h %p" >> $sshcfile
    echo "" >> $sshcfile
fi

echo $SEPARATOR
cat $sshcfile
echo $SEPARATOR
echo

echo
echo "TEST GH   ssh -i $SSH_KEYFILE -T git@github.com"
echo $SEPARATOR
ssh -i $SSH_KEYFILE -T git@github.com

echo
echo "TEST BB   ssh -i $SSH_KEYFILE -T git@bitbucket.org"
echo $SEPARATOR
ssh -i $SSH_KEYFILE -T git@bitbucket.org
echo

echo
echo "TEST GL   ssh -i $SSH_KEYFILE -T git@gitlab.com"
echo $SEPARATOR
ssh -i $SSH_KEYFILE -T git@gitlab.com
echo

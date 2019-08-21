#!/bin/zsh

SEPARATOR="---------------------"
SSH_KEYNAME="id_rsa"
if [ $# -eq 0 ] || [ -z "$1" ]; then
    echo "No arguments supplied"
    #read -p "Enter your key name (default: '$SSH_KEYNAME' > " key
    echo -n "Enter your key name (default: '$SSH_KEYNAME' > "
    read key

    [ ! -z "$key" ] && SSH_KEYNAME=$key
else
    SSH_KEYNAME="$1"
fi

FILE_ALPHAN_NAME=$(echo $SSH_KEYNAME | sed 's/[^a-z0-9\.]/_/g')

# https://help.github.com/articles/generating-an-ssh-key/
SSH_KEYFILE="$HOME/.ssh/$FILE_ALPHAN_NAME"
if [ ! -f "$SSH_KEYFILE" ] ; then
    echo "CREATE SSH KEY FOR $SSH_KEYFILE"

    ssh-keygen -t rsa -f $SSH_KEYFILE -b 4096 -C $SSH_KEYNAME
        chmod 600 $SSH_KEYNAME
    chmod 600 $SSH_KEYNAME.pub
fi

eval `ssh-agent`
ssh-add -K $SSH_KEYFILE

echo
echo "PUBLIC KEYS..."
ls $HOME/.ssh/*.pub

pbcopy < $SSH_KEYFILE.pub

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

if ! grep -q "UseKeychain" $sshcfile; then
    echo "CFG UseKeychain"
    echo "Host *" >> $sshcfile
    echo "    UseKeychain yes" >> $sshcfile
    echo "" >> $sshcfile
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
echo "TEST GH   ssh -T git@github.com"
echo $SEPARATOR
ssh -T git@github.com

echo
echo "TEST BB   ssh -T git@bitbucket.org"
echo $SEPARATOR
ssh -T git@bitbucket.org
echo

echo
echo "TEST GL   ssh -T git@gitlab.com"
echo $SEPARATOR
ssh -T git@gitlab.com
echo

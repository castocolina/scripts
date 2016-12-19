#!/bin/bash

echo "========================================="
echo "GIT LOCAL REPO CONFIG"
echo "========================================="

if [ $# -eq 0 ] || [ -z "$1" ]  || [ -z "$2" ]; then
    echo "No arguments supplied or incompleted"
    #echo -n "Enter your name > "
    #read -a username
    read -p "Enter your name > " username
    #echo -n "Enter your email > "
    #read useremail
    read -p "Enter your email > " useremail
else
    username="$1"
    useremail="$2"
fi

git config --local --unset-all user.name
git config --local --unset-all user.email
git config --local --replace-all user.name "$username"
git config --local --replace-all user.email "$useremail"
git config --local core.filemode true
git config --global core.editor nano
#git config --global --unset core.editor
git config --global core.longpaths true

if [ "$(uname)" == "Darwin" ]; then
    git config --global core.autocrlf input
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    git config --global core.autocrlf input
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    git config --global core.autocrlf true
fi

git config -l

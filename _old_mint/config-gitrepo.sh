#!/bin/bash

echo "========================================="
echo "GIT LOCAL REPO CONFIG"
echo "========================================="

username=$(git config --get user.name)
useremail=$(git config --get user.email)

if [ $# -eq 0 ] || [ -z "$1" ]  || [ -z "$2" ]; then
    echo "No arguments supplied or incompleted"
    #echo -n "Enter your name > "
    #read -a username
    read -p "Enter your name (default: '$username') > " iusername
    #echo -n "Enter your email > "
    #read useremail
    read -p "Enter your email (default: '$useremail')> " iuseremail
else
    iusername="$1"
    iuseremail="$2"
fi

[ ! -z "$iusername" ] && username=$iusername
[ ! -z "$iuseremail" ] && useremail=$iuseremail

git config --local --unset-all user.name
git config --local --unset-all user.email
git config --local --replace-all user.name "$username"
git config --local --replace-all user.email "$useremail"
git config --global core.editor vim
git config --global push.default simple
git config --global core.longpaths true

## https://help.github.com/articles/dealing-with-line-endings/
if [ "$(uname)" == "Darwin" ]; then
    git config --global core.autocrlf input
    echo "Mac ::: git config --global core.autocrlf input"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    git config --global core.autocrlf input
    echo "Linux ::: git config --global core.autocrlf input"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    git config --global core.autocrlf true
    echo "WIN ::: git config --global core.autocrlf true"
fi

git config -l

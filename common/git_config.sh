#!/bin/bash

echo "========================================="
echo "GIT LOCAL REPO CONFIG"
echo "========================================="

cusername=$(git config --get user.name)
cuseremail=$(git config --get user.email)

iusername=${1:-$cusername}
iuseremail=${2:-$cuseremail}

if [ $# -eq 0 ] || [ -z "$1" ]  || [ -z "$2" ]; then
    echo "No arguments supplied or incompleted"
    echo -n "Enter your name (default: '$cusername') > "
    read iusername
    echo -n "Enter your email (default: '$cuseremail')> "
    read iuseremail
fi

newusername=${iusername:-$cusername}
newuseremail=${iuseremail:-$cuseremail}

git config --local --unset-all user.name
git config --local --unset-all user.email
git config --local --replace-all user.name "$newusername"
git config --local --replace-all user.email "$newuseremail"
git config --global core.editor vim
git config --global push.default simple
git config --global core.longpaths true

uname_s=$(uname -s)

## https://help.github.com/articles/dealing-with-line-endings/
if [ "$uname_s" = "Darwin" ] ; then
    git config --global core.autocrlf input
    echo "Mac ($uname_s) ::: git config --global core.autocrlf input"
elif [ "$(expr substr $uname_s 1 5)" = "Linux" ] ; then
    git config --global core.autocrlf input
    echo "Linux ($uname_s) ::: git config --global core.autocrlf input"
elif [ "$(expr substr $uname_s 1 10)" = "MINGW32_NT" ] ; then
    git config --global core.autocrlf true
    echo "WIN ($uname_s) ::: git config --global core.autocrlf true"
fi

echo
echo
git --no-pager config -l

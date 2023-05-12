#!/bin/bash

echo "========================================="
echo "GIT REPO UPDATE USER INFO"
echo "========================================="

usage="$(basename "$0") [-h|u] oldemail newemail 'Old Name' 'New Name' -- script for replace old user for new on git local repo

where:
    -h  show this help text
    -u  show this help text"

while getopts ':hu' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    u) echo "$usage"
       exit
       ;;
#
  esac
done
shift $((OPTIND - 1))

cusername=$(git config --get user.name)
cuseremail=$(git config --get user.email)

if [ $# -eq 0 ] || [ -z "$1" ]  || [ -z "$2" ] ; then
    echo "No arguments supplied or incompleted"
    echo
    echo -n "Enter your oldemail > "
    read iolduseremail
    echo -n "Enter your newemail > "
    read inewuseremail
    echo -n "Enter your oldname > "
    read ioldusername
    echo -n "Enter your newname > "
    read inewusername
    echo
else
    iolduseremail=$1
    inewuseremail=$2
    ioldusername=$3
    inewusername=$4
fi

olduseremail=${iolduseremail:-$cuseremail}
newuseremail=${inewuseremail:-$cuseremail}
oldusername=${ioldusername:-$cusername}
newusername=${inewusername:-$cusername}

export olduseremail newuseremail oldusername newusername

git config --local --unset-all user.name
git config --local --unset-all user.email
git config --local --replace-all user.name "$newusername"
git config --local --replace-all user.email "$newuseremail"

echo
echo "NEW OLD EMAIL: $olduseremail"
echo "NEW OLD NAME: '$oldusername'"
echo "NEW USER EMAIL: $newuseremail"
echo "NEW USER NAME: '$newusername'"
echo

#git log -10

git filter-branch -f --env-filter '
    
    if [ -n "$olduseremail" ] && [ -n "$newuseremail" ] && [ "$GIT_AUTHOR_EMAIL" = "$olduseremail" ]; then
      GIT_AUTHOR_EMAIL=$newuseremail; 
      export GIT_AUTHOR_EMAIL; 
      echo "AUTHOR EMAIL = $GIT_AUTHOR_EMAIL"
    fi

    if [ -n "$olduseremail" ] && [ -n "$newuseremail" ] && [ "$GIT_COMMITTER_EMAIL" = "$olduseremail" ]; then
      GIT_COMMITTER_EMAIL=$newuseremail; 
      export GIT_COMMITTER_EMAIL; 
      echo "COMMITER EMAIL = $GIT_COMMITTER_EMAIL"
    fi
    
    if [ -n "$oldusername" ] && [ -n "$newusername" ] && [ "$GIT_AUTHOR_NAME" = "$oldusername" ]; then
      GIT_AUTHOR_NAME=$newusername; 
      export GIT_AUTHOR_NAME; 
      echo "AUTHOR NAME = $GIT_AUTHOR_NAME";
    fi
    
    if [ -n "$oldusername" ] && [ -n "$newusername" ] && [ "$GIT_COMMITTER_NAME" = "$oldusername" ] ; then
      GIT_COMMITTER_NAME=$newusername; 
      export GIT_COMMITTER_NAME; 
      echo "COMMITER NAME = $GIT_COMMITTER_NAME"
    fi
    
' HEAD

echo 
echo "GIT_AUTHOR_EMAIL: $GIT_AUTHOR_EMAIL"
echo "GIT_COMMITTER_EMAIL: '$GIT_COMMITTER_EMAIL'"
echo "GIT_AUTHOR_NAME: $GIT_AUTHOR_NAME"
echo "GIT_COMMITTER_NAME: '$GIT_COMMITTER_NAME'"

echo
echo "============================================= "
git --no-pager log -3
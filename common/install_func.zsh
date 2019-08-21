#!/bin/zsh

export REL_MY_SH_CFG_FILE=.zshrc4$USER
export MY_SH_CFG_FILE=~/$REL_MY_SH_CFG_FILE
touch $MY_SH_CFG_FILE
export TMP_INSTALL_DIR=/tmp/installers
export INSTALL_DIR=$HOME/opt

function exist_cmd() {
  CMD=$1
  { command -v $CMD >/dev/null 2>&1 && echo "'$CMD' is INSTALLED!" && return_cd=0; } || \
  { echo >&2 "I require '$CMD' but it's not installed."; return_cd=1; }
  # type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  # hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  # echo $return_cd;
  return $return_cd;
}

function delete_confirm(){
  FOLDER_NAME=$1; NAME=$2; FINAL_TARGET_DIR=$3;
  APP_TARGET=${FINAL_TARGET_DIR:-$INSTALL_DIR}
  echo -n "DELETE $NAME? (y/n) > "
  read to_delete

  is_true $to_delete && [ -d "$APP_TARGET/$FOLDER_NAME" ] && rm -rf $APP_TARGET/$FOLDER_NAME/
}

function down_uncompress(){
  CURR_DIR=$(pwd)
  mkdir -p $TMP_INSTALL_DIR; cd $TMP_INSTALL_DIR
  #target folder name, original folder name, desc name, file name, url
  ENAME=$1; CNAME=$2; NAME=$3; FNAME=$4; URL=$5; FINAL_TARGET_DIR=$6;

  APP_TARGET=${FINAL_TARGET_DIR:-$INSTALL_DIR}

  if [ ! -d "$APP_TARGET/$ENAME" ] ; then
    mkdir -p $APP_TARGET
    echo
    echo $SEPARATOR
    echo "$NAME ............. $FNAME ->> $APP_TARGET"
    echo $SEPARATOR
    if [ ! -f "$FNAME" ]; then
        echo "    $URL"
        curl -o "$FNAME" -fSL $URL
    fi

    if [[ $FNAME == *.tar.gz ]] || [[ $FNAME == *.tgz ]]; then
      tar -zxf $FNAME
    fi

    if [[ $FNAME == *.zip ]]; then
      unzip -q $FNAME
    fi
    
    if [ -d "$CNAME" ] && [ ! "$CNAME" = "$ENAME" ]; then 
      mv -f $CNAME/ $ENAME
    fi

    if [ -d "$ENAME" ] ; then 
      mv -f $ENAME/ $APP_TARGET/
    fi

    return_cd=0
  else
    echo "$NAME ............. IS INSTALLED ->> $APP_TARGET"
    return_cd=1
  fi
  cd $CURR_DIR
  return $return_cd;
}

function find_append(){
  FILE=$1
  FIND=$2
  TEXT=$3
  touch $FILE
  if ! grep -q "$FIND" $FILE; then
    printf "$TEXT\n\n" >> $FILE
  fi
}

function is_true() {
  if [ "$1" = true ] || [ "$1" = "true" ] || [ "$1" = "1" ] || [ "$1" = "y" ] || [ "$1" = "yes" ]; then
    return 0;
  fi
  return 1;
}


function is_false() {
  if is_true $1 ; then
    return 1;
  fi
  return 0;
}

function exist_dir() {
  if [ -d "$1" ] ; then
    echo "DIR '$1' EXIST!"
    return 0;
  fi
  echo >&2 "I require DIR '$1' but it's not exist.";
  return 1;
}

function exist_file() {
  if [ -f "$1" ] ; then
    return 0;
  fi
  return 1;
}

function git_down_update(){
  GIT_URL=$1
  REPO_NAME=$2
  DOWN_PATH="$INSTALL_DIR/$REPO_NAME"
  echo "$GIT_URL ........... >> $DOWN_PATH"
  if [ ! -d "$DOWN_PATH" ]; then
    git clone --progress -v $GIT_URL "$DOWN_PATH"
  else
    git -C "$DOWN_PATH" pull --all --progress -v
  fi
}

function get_github_latest_release(){
  REPO_NAME=$1
  DEFAULT=$2
  FULL_URL="https://api.github.com/repos/$REPO_NAME/releases/latest"
  RELEASE=$(curl --silent $FULL_URL | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')
  echo ${RELEASE:-$DEFAULT};
}

function get_os(){
  echo $(uname -s | tr '[:upper:]' '[:lower:]');
}

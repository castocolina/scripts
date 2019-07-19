#!/bin/bash

export MY_SH_CFG_FILE=~/.zshrc4cco
touch $MY_SH_CFG_FILE

function exist_cmd() {
  CMD=$1
  { command -v $CMD >/dev/null 2>&1 && echo "'$CMD' is INSTALLED!" && return_cd=0; } || \
  { echo >&2 "I require '$CMD' but it's not installed."; return_cd=1; }
  # type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  # hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  # echo $return_cd;
  return $return_cd;
}


TMP_INSTALL_DIR=/tmp/installers
export INSTALL_DIR=$HOME/opt

function install_deb(){
  
  CURR_DIR=$(pwd)
  mkdir -p $TMP_INSTALL_DIR; cd $TMP_INSTALL_DIR

  CMD=$1; NAME="$2"; FNAME=$3; URL=$4;
  exist_cmd $1 || {
    echo
    echo $SEPARATOR
    echo "$NAME .............."
    echo $SEPARATOR
    if [ ! -f "$FNAME" ]; then
        echo "    $URL"
        curl -o "$FNAME" -fSL $URL
    fi
    sudo dpkg -i $FNAME
  }

  cd $CURR_DIR
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

function exist_pkg() {
  PKG=$1
  { dpkg -s $PKG >/dev/null 2>&1 && echo "'$PKG' is INSTALLED!" && return_cd=0; } || \
  { echo >&2 "I require '$PKG' but it's not installed."; return_cd=1; }
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

function create_sc(){
    PSNAME=$1
    PNAME=$2
    PVENDOR=$3
    PVERSION=$4
    PEXEC=$5
    PCATEGORIES=$6
    PKEYS=$7
    PICON=$8
    PICON_SIZE=$9

    DESKTOP_FILE="$PSNAME.desktop"

    if [ -f "$DESKTOP_FILE" ] ; then
        rm -f $DESKTOP_FILE
    fi
    touch $DESKTOP_FILE
    ## Version=$PVERSION
    cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Encoding=UTF-8
Name=$PNAME
Keywords=$PKEYS
GenericName=$PNAME
Type=Application
Categories=$PCATEGORIES
Terminal=false
StartupNotify=true
Exec=$PEXEC
Icon=$PICON
X-Ayatana-Desktop-Shortcuts=NewWindow;
EOF

    # seems necessary to refresh immediately:
    chmod 755 "$DESKTOP_FILE"

    ls -la $DESKTOP_FILE
    ls -la $PICON
    ls -la $PEXEC

    echo $DESKTOP_FILE
    echo "$SEPARATOR"
    # cat $DESKTOP_FILE
    echo "$SEPARATOR"

    # xdg-desktop-menu install $DESKTOP_FILE
    desktop-file-install --dir=$HOME/.local/share/applications/ --delete-original $DESKTOP_FILE
    xdg-icon-resource install --size $PICON_SIZE "$PICON" "$PVENDOR-$PSNAME"
    echo "CREATE SC for $PNAME"
}

function down_install4j(){

  CURR_DIR=$(pwd)
  mkdir -p $TMP_INSTALL_DIR; cd $TMP_INSTALL_DIR

  SNAME=$1; NAME=$2; FILE=$3; URL=$4;

  PROGRAM_DIR="$INSTALL_DIR/$SNAME"
  echo "$NAME ........... >> $PROGRAM_DIR"
  if [ ! -d "$PROGRAM_DIR" ] ; then
      if [ ! -f "$FILE" ]; then
          echo "    $URL"
          curl -o $FILE -fSL $URL
      fi
      echo $FILE
      bash $FILE -q -Dinstall4j.noProxyAutoDetect=true -splash "$NAME $VERSION installer" -dir $PROGRAM_DIR
  fi

  cd $CURR_DIR
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
  FULL_URL="https://api.github.com/repos/$REPO_NAME/releases/latest"
  echo $FULL_URL
  RELEASE=$(curl --silent $FULL_URL | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')
  echo "$REPO_NAME REV: $RELEASE"
  echo $RELEASE
}

function get_os(){
  return $(uname -s | tr '[:upper:]' '[:lower:]');
}

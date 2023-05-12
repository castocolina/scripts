#!/bin/bash

function exist_pkg() {
  PKG=$1
  { dpkg -s $PKG >/dev/null 2>&1 && echo "'$PKG' is INSTALLED!" && return_cd=0; } || \
  { echo >&2 "I require '$PKG' but it's not installed."; return_cd=1; }
  return $return_cd;
}

function install_deb(){
  
  CURR_DIR=$(pwd)
  mkdir -p $TMP_INSTALL_DIR; cd $TMP_INSTALL_DIR

  CMD=$1; NAME="$2"; FNAME=$3; URL=$4;
  exist_cmd $CMD || {
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

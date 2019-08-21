#!/bin/zsh

function install_dmg2() {
    set -x
    tempd=$(mktemp -d)
    curl $1 > $FNAME
    listing=$(sudo hdiutil attach $tempd/pkg.dmg | grep Volumes)
    volume=$(echo "$listing" | cut -f 3)
    if [ -e "$volume"/*.app ]; then
      sudo cp -rf "$volume"/*.app /Applications
    elif [ -e "$volume"/*.pkg ]; then
      package=$(ls -1 "$volume" | grep .pkg | head -1)
      sudo installer -pkg "$volume"/"$package" -target /
    fi
    sudo hdiutil detach "$(echo "$listing" | cut -f 1)"
    rm -rf $tempd
    set +x
}

function install_dmg(){
  
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
    ## sudo dpkg -i $FNAME
    listing=$(sudo hdiutil attach $FNAME | grep Volumes)
    volume=$(echo "$listing" | cut -f 3)
    if [ -e "$volume"/*.app ]; then
      sudo cp -rf "$volume"/*.app /Applications
    elif [ -e "$volume"/*.pkg ]; then
      package=$(ls -1 "$volume" | grep .pkg | head -1)
      sudo installer -pkg "$volume"/"$package" -target /
    fi
    sudo hdiutil detach "$(echo "$listing" | cut -f 1)"
    #    rm -rf $tempd
    set +x
  }

  cd $CURR_DIR
}
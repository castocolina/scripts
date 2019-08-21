#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo ""
echo $SEPARATOR
echo ">>>>> UPDATE ................"
echo $SEPARATOR

source $BASEDIR/install_func.zsh
source $MY_SH_CFG_FILE

echo -n "UPDATE? (y/n) > "
read to_update

MY_OS=$(get_os)

if [ "$MY_OS" = "darwin" ]; then
  # default for osx 9152
  sudo sysctl -w kern.maxfiles=5242880;
  # default for osx 24576
  sudo sysctl -w kern.maxfilesperproc=524288;
fi

release=$(get_github_latest_release "nvm-sh/nvm" "v0.34.0")
curl -fSLo- https://raw.githubusercontent.com/nvm-sh/nvm/$release/install.sh | bash

NVM_CONFIG=$(cat <<'EOF'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
EOF
);
find_append $MY_SH_CFG_FILE "NVM_DIR=" "$NVM_CONFIG"
source $MY_SH_CFG_FILE
nvm --version

nvm install 8;
nvm install 10;
nvm install node;
nvm use 8;

rm -rf $HOME/.yarn
exist_cmd yarn || curl -o- -fSL https://yarnpkg.com/install.sh | bash -s -- --rc

(exist_cmd create-react-native-app || is_false $to_update) || npm i -g create-react-native-app
(exist_cmd nodemon || is_false $to_update) || npm i -g nodemon
(exist_cmd eslint || is_false $to_update) || npm i -g eslint
(exist_cmd tslint || is_false $to_update) || npm i -g tslint
(exist_cmd nodemon || is_false $to_update) || npm i -g nodemon
(exist_cmd jest || is_false $to_update) || npm i -g jest
sudo npm config delete prefix



echo ":: $SEPARATOR"
npm --version
node --version
echo ":: $SEPARATOR"
#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo -n "UPDATE? (y/n) > "
read to_update

source $BASEDIR/install_func.zsh
source $MY_SH_CFG_FILE

printf "\n$SEPARATOR\n >>>>> SDK\n"
exist_cmd sdk || {
  curl -s "https://get.sdkman.io" | bash

  SDK_CONFIG=$(cat <<'EOF'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
EOF
);

  echo "$SDK_CONFIG ----"
  find_append $MY_SH_CFG_FILE ".sdkman/bin/sdkman-init.sh" "$SDK_CONFIG"
  source $MY_SH_CFG_FILE
  sdk version
  sdk selfupdate force
}

(is_true $to_update && exist_cmd sdk) && sdk selfupdate force
(is_true $to_update && exist_cmd brew) && brew update --force

uname -a
printf ":: $SEPARATOR\n BREW:\n "
brew list --versions
echo ":: $SEPARATOR"
sdk version
sdk current
printf ":: $SEPARATOR\n GCC: "
gcc --version | head -1
echo ":: $SEPARATOR"

printf ":: $SEPARATOR\n\n"


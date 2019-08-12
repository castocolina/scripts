#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo ""
echo $SEPARATOR
echo ">>>>> UPDATE ................"
echo $SEPARATOR

source $BASEDIR/install_func.zsh
source $BASEDIR/install_url.zsh
source $MY_SH_CFG_FILE

echo -n "UPDATE? (y/n) > "
read to_update

exist_cmd go || brew install golang
exist_cmd go && is_true $to_update && brew upgrade golang;
exist_cmd go && is_true $to_update && {
  mkdir -p $HOME/go;
  GOLANG_CONFIG=$(cat <<'EOF'
export GOPATH="$HOME/go";
export PATH="$PATH:$GOPATH/bin";
EOF
);
  find_append $MY_SH_CFG_FILE "GOPATH=" "$GOLANG_CONFIG"
  source $MY_SH_CFG_FILE

  mkdir -p $GOPATH/src $GOPATH/pkg $GOPATH/bin

  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

  go get -u -v github.com/rakyll/gotest

  #Go debugger
  go get -u -v github.com/go-delve/delve/cmd/dlv
  # Go lint
  go get -u -v github.com/golangci/golangci-lint/cmd/golangci-lint

  go get -u -v github.com/ramya-rao-a/go-outline
  go get -u -v github.com/rogpeppe/godef
  go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs
  go get -u -v github.com/sqs/goreturns

};


echo ":: $SEPARATOR"
go version
echo ":: $SEPARATOR"
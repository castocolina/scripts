#!/bin/bash
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

source $BASEDIR/install_func.sh
source $MY_SH_CFG_FILE
VS_CODE_PATH_OSX="Visual Studio Code.app"
MY_OS=$(get_os)

echo
echo $SEPARATOR
echo ">>>>> VSCODE ................"
echo $SEPARATOR

echo -n "UPDATE? (y/n) > "
read to_update


if [ "$MY_OS" = "darwin" ]; then
VSCODE_CONFIG=$(cat <<'EOF'
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin";
EOF
);
	find_append $MY_SH_CFG_FILE "$VS_CODE_PATH_OSX" "$VSCODE_CONFIG"
	source $MY_SH_CFG_FILE
fi

exist_cmd code || {
	if [ "$MY_OS" = "darwin" ]; then
		echo "Download for OSX"
		source $BASEDIR/../osx/install_url.sh
		source $BASEDIR/../osx/install_func.sh
		download_remote_file $FILE_VSCODE $URL_VSCODE
		uncompress_file $TMP_INSTALL_DIR/$FILE_VSCODE
		move_to_apps "$TMP_INSTALL_DIR/$VS_CODE_PATH_OSX"
	fi
}


exist_cmd code && is_true $to_update && {
	
	code --install-extension googlecloudtools.cloudcode
	code --install-extension wholroyd.hcl
	code --install-extension ms-azuretools.vscode-azureterraform

	code --install-extension eamodio.gitlens
	code --install-extension ms-vscode.go
	code --install-extension Equinusocio.vsc-material-theme
	code --install-extension PKief.material-icon-theme

	code --install-extension dbaeumer.vscode-eslint
	code --install-extension EditorConfig.EditorConfig
	code --install-extension esbenp.prettier-vscode

	code --install-extension ms-python.python

	code --install-extension redhat.vscode-yaml
	code --install-extension ms-azuretools.vscode-docker
	code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
}

#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

source $BASEDIR/install_func.zsh
source $MY_SH_CFG_FILE
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
	find_append $MY_SH_CFG_FILE "Visual Studio Code.app" "$VSCODE_CONFIG"
	source $MY_SH_CFG_FILE
fi


exist_cmd code && is_true $to_update && {
	
	code --install-extension wholroyd.hcl
	code --install-extension ms-azuretools.vscode-azureterraform

	code --install-extension eamodio.gitlens
	code --install-extension ms-vscode.go
	code --install-extension Equinusocio.vsc-material-theme
	code --install-extension PKief.material-icon-theme

	code --install-extension EditorConfig.EditorConfig
	code --install-extension esbenp.prettier-vscode

	code --install-extension ms-python.python

	code --install-extension redhat.vscode-yaml
	code --install-extension ms-azuretools.vscode-docker
	code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
}

# eamodio.gitlens
# josin.kusto-syntax-highlighting
# ms-mssql.mssql
# PKief.material-icon-theme
# rogalmic.zsh-debug


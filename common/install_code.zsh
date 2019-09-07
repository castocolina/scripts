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
	
	code --install-extension -f wholroyd.hcl
	code --install-extension -f ms-azuretools.vscode-azureterraform

	code --install-extension -f eamodio.gitlens
	code --install-extension -f ms-vscode.go
	code --install-extension -f Equinusocio.vsc-material-theme
	code --install-extension -f PKief.material-icon-theme

	code --install-extension -f dbaeumer.vscode-eslint
	code --install-extension -f EditorConfig.EditorConfig
	code --install-extension -f esbenp.prettier-vscode

	code --install-extension -f ms-python.python

	code --install-extension -f redhat.vscode-yaml
	code --install-extension -f ms-azuretools.vscode-docker
	code --install-extension -f ms-kubernetes-tools.vscode-kubernetes-tools
}

# eamodio.gitlens
# josin.kusto-syntax-highlighting
# ms-mssql.mssql
# PKief.material-icon-theme
# rogalmic.zsh-debug


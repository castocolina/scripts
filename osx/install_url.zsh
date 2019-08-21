#!/bin/zsh
BASEDIR=$(dirname "$0")

#https://prerelease.keybase.io/keybase_amd64.deb
FILE_KEYBASE=keybase_amd64.deb
URL_KEYBASE="https://prerelease.keybase.io/keybase_amd64.deb"

#https://update.code.visualstudio.com/1.30.1/linux-deb-x64/stable
VERSION_VSCODE="1.34.0"
FILE_VSCODE=vscode-amd64-$VERSION_VSCODE.deb
URL_VSCODE="https://update.code.visualstudio.com/$VERSION_VSCODE/linux-deb-x64/stable"

VERSION_DATAGRIP=2017.1.5
FILE_DATAGRIP="datagrip-$VERSION_DATAGRIP.tar.gz"
URL_DATAGRIP="https://download-cf.jetbrains.com/datagrip/$FILE_DATAGRIP"
#!/bin/bash

BASEDIR=$(dirname "$0")
source $BASEDIR/install_func.zsh
MY_SH_CFG_FILE=~/.zshrc4cco
touch $MY_SH_CFG_FILE

#ALIASES
exist_cmd docker &&
{
    ALIAS_DOKER_STATS="alias docker-stats='docker stats \$(docker ps --format={{.Names}})'"
    if ! grep -q "$ALIAS_DOKER_STATS" $MY_SH_CFG_FILE; then
        echo "" >> $MY_SH_CFG_FILE
        echo "$ALIAS_DOKER_STATS" >> $MY_SH_CFG_FILE
        echo "DOCKER STATS ALIAS"
    fi
}

MY_OS=$(get_os)
if [ "$MY_OS" = "linux" ]; then
    ALIAS_PBCOPY="alias pbcopy='xclip -selection clipboard'"
    if ! grep -q "$ALIAS_PBCOPY" $MY_SH_CFG_FILE; then
        echo "" >> $MY_SH_CFG_FILE
        echo "$ALIAS_PBCOPY" >> $MY_SH_CFG_FILE
        echo "PBCOPY ALIAS"
    fi

    ALIAS_PBPASTE="alias pbpaste='xclip -selection clipboard -o'"
    if ! grep -q "$ALIAS_PBPASTE" $MY_SH_CFG_FILE; then
        echo "" >> $MY_SH_CFG_FILE
        echo "$ALIAS_PBPASTE" >> $MY_SH_CFG_FILE
        echo "PBPASTE ALIAS"
    fi
fi


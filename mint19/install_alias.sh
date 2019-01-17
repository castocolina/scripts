#!/bin/bash

MY_SH_CFG_FILE=~/.zshrc4cco
touch $MY_SH_CFG_FILE

#ALIASES
ALIAS_DOKER_STATS="alias docker-stats='docker stats \$(docker ps --format={{.Names}})'"
if ! grep -q "$ALIAS_DOKER_STATS" $MY_SH_CFG_FILE; then
    echo "" >> $MY_SH_CFG_FILE
    echo "$ALIAS_DOKER_STATS" >> $MY_SH_CFG_FILE
    echo "DOCKER STATS ALIAS"
fi

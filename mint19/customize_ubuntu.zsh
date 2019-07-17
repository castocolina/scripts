#!/bin/zsh

# Customize switch workspace down/up (unused). Because disable vscode copy down/up line
# Base on https://askubuntu.com/questions/315625/how-to-disable-the-shortcut-ctrl-alt-arrow-in-gnome-3-8

EXPECTED="['<Super>Page_Down', '<Control><Alt>Down']"
gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-down
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['']"
gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-down
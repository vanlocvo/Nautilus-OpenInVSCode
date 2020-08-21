#!/bin/bash


restart_nautilus()
{
    read -p "Do you want restart Nautilus (Files) [Y/N]? " VAR
    if [[ $VAR = 'y' || $VAR = 'Y' ]]; then
        nautilus -q
    fi    
}
cp_file() {
    FILE=vscode-nautilus.py
    TARGDIR=$1
    if [[ ! -d $TARGDIR ]]; then
        mkdir -v -p "$TARGDIR"
    fi
    cp -v "$FILE" "$TARGDIR"
    restart_nautilus
}
cp_file_sudo() {
    FILE=vscode-nautilus.py
    TARGDIR=$1
    if [[ ! -d $TARGDIR ]]; then
        sudo mkdir -v -p "$TARGDIR"
    fi
    sudo cp -v "$FILE" "$TARGDIR"
    restart_nautilus
}

if [[ $UID != 0 ]]; then
    read -p "This script is running without sudo, install for current user [Y/N]? " VAR
    if [[ $VAR = 'y' || $VAR = 'Y' ]]; then 
        TARGDIR=~/.local/share/nautilus-python/extensions
        cp_file "$TARGDIR"
    else
        read -p "Do you want install for all user [Y/N]? " VAR
        if [[ $VAR = 'y' || $VAR = 'Y' ]]; then 
            TARGDIR=/usr/share/nautilus-python/extensions
            cp_file_sudo "$TARGDIR"
        else
            echo "Install failed!"
        fi
    fi
    else
        read -p "This script is running with sudo, install for all user [Y/N]? " VAR
        if [[ $VAR = 'y' || $VAR = 'Y' ]]; then
            TARGDIR=/usr/share/nautilus-python/extensions
            cp_file "$TARGDIR"
        else
            echo "Install failed!"
        fi
fi


#!/bin/bash


restart_nautilus()
{
    read -p "Do you want restart Nautilus (Files) [Y/n]? " VAR
    if [[ $VAR = 'n' || $VAR = 'N' ]]; then
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
    set_location
    restart_nautilus
}
cp_file_sudo() {
    FILE=vscode-nautilus.py
    TARGDIR=$1
    if [[ ! -d $TARGDIR ]]; then
        sudo mkdir -v -p "$TARGDIR"
    fi
    sudo cp -v "$FILE" "$TARGDIR"
    set_location
    restart_nautilus
}

set_location() {
    if [[ -e "/usr/bin/code" ]]; then
        echo "VSCode is installed in /usr/bin/code"
        sed -i "s|CODE_REPLACE|/usr/bin/code|g" $TARGDIR/vscode-nautilus.py
    elif [[ -e "/usr/bin/code-insiders" ]]; then
        echo "VSCode is installed in /usr/bin/code-insiders"
        sed -i "s|CODE_REPLACE|/usr/bin/code|g" $TARGDIR/vscode-nautilus.py
    elif [[ -e "/snap/bin/code" ]]; then
        echo "VSCode is installed in /snap/bin/code"
        sed -i "s|CODE_REPLACE|/snap/bin/code|g" $TARGDIR/vscode-nautilus.py
    else 
        echo "Could not find VSCode installation path"
        read -p "Please enter the path to VSCode: " VAR
        sed -i "s|/usr/bin/code|${VAR}|g" $TARGDIR/vscode-nautilus.py
    fi
}

if [[ $UID != 0 ]]; then
    read -p "This script is running without sudo, install for current user [y/N]? " VAR
    if [[ $VAR = 'y' || $VAR = 'Y' ]]; then 
        TARGDIR=~/.local/share/nautilus-python/extensions
        cp_file "$TARGDIR"
    else
        read -p "Do you want install for all user [y/N]? " VAR
        if [[ $VAR = 'y' || $VAR = 'Y' ]]; then 
            TARGDIR=/usr/share/nautilus-python/extensions
            cp_file_sudo "$TARGDIR"
        else
            echo "Install failed!"
        fi
    fi
    else
        read -p "This script is running with sudo, install for all user [y/N]? " VAR
        if [[ $VAR = 'y' || $VAR = 'Y' ]]; then
            TARGDIR=/usr/share/nautilus-python/extensions
            cp_file "$TARGDIR"
        else
            echo "Install failed!"
        fi
fi


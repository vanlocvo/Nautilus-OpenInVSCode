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
    # VSCode
    if [[ -e "/usr/bin/code" ]]; then
        echo "VSCode is installed in /usr/bin/code"
        sed -i "s|CODE_REPLACE|/usr/bin/code|g" $TARGDIR/vscode-nautilus.py
    
    # VSCode Insiders
    elif [[ -e "/usr/bin/code-insiders" ]]; then
        echo "VSCode is installed in /usr/bin/code-insiders"
        sed -i "s|CODE_REPLACE|/usr/bin/code|g" $TARGDIR/vscode-nautilus.py
    
    # VSCode installed with Snap
    elif [[ -e "/snap/bin/code" ]]; then
        echo "VSCode is installed in /snap/bin/code"
        sed -i "s|CODE_REPLACE|/snap/bin/code|g" $TARGDIR/vscode-nautilus.py

    # VSCode installed with Flatpak
    elif [[ -e "/var/lib/flatpak/app/com.visualstudio.code/current/active/files/bin/code" ]]; then
        echo "VSCode is installed with Flatpak"
        sed -i "s|CODE_REPLACE|flatpak run com.visualstudio.code|g" $TARGDIR/vscode-nautilus.py
    
    # VSCodium
    elif [[ -e "/usr/bin/codium" ]]; then
        echo "VSCodium is installed in /usr/bin/codium"
        sed -i "s|CODE_REPLACE|/usr/bin/codium|g" $TARGDIR/vscode-nautilus.py
        sed -i "s|Open in Code|Open in Codium|g" $TARGDIR/vscode-nautilus.py
        sed -i "s|Open this folder/file in VSCode|Open this folder/file in VSCodium|g" $TARGDIR/vscode-nautilus.py
    
    # VSCodium installed with Snap
    elif [[ -e "/snap/bin/codium" ]]; then
        echo "VSCodium is installed in /snap/bin/codium"
        sed -i "s|CODE_REPLACE|/snap/bin/codium|g" $TARGDIR/vscode-nautilus.py
        sed -i "s|Open in Code|Open in Codium|g" $TARGDIR/vscode-nautilus.py
        sed -i "s|Open this folder/file in VSCode|Open this folder/file in VSCodium|g" $TARGDIR/vscode-nautilus.py

    # VSCodium installed with Flatpak
    elif [[ -e "/var/lib/flatpak/app/com.vscodium.codium/current/active/files/bin/codium" ]]; then
        echo "VSCodium is installed with Flatpak"
        sed -i "s|CODE_REPLACE|flatpak run com.vscodium.codium|g" $TARGDIR/vscode-nautilus.py
        sed -i "s|Open in Code|Open in Codium|g" $TARGDIR/vscode-nautilus.py
        sed -i "s|Open this folder/file in VSCode|Open this folder/file in VSCodium|g" $TARGDIR/vscode-nautilus.py

    # If none of the above, ask user to enter the path
    else 
        echo "Could not find VSCode/VSCodium installation path"
        read -p "Please enter the path to VSCode/VSCodium : " VAR
        sed -i "s|/usr/bin/code|${VAR}|g" $TARGDIR/vscode-nautilus.py
        if [[ ${VAR} =~ "codium" ]]; then 
            sed -i "s|Open in Code|Open in Codium|g" $TARGDIR/vscode-nautilus.py
            sed -i "s|Open this folder/file in VSCode|Open this folder/file in VSCodium|g" $TARGDIR/vscode-nautilus.py
        fi;
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


#!/bin/bash

#sudo dnf update -y

read -p "If you are on a Debian/Ubuntu or Arch-based OS, the tarball package is not required. Official releases for those distros are provided by Mojang, which will be also be installed by this script, if you want. Otherwise, it's just a simple download and click. Would you like to continue? (y/n)"

if [[ "$choice" == "n" || "$choice" == "N" ]]; then

    echo "Terminating script."
    exit 1  # Exit the script

echo "Select corresponding number for your OS, or what it's based on (Linux Mint is Ubuntu-based :P)"
echo "1 Debian/Ubuntu"
echo "2 Arch"
echo "3 tar.gz package for other OSes (will technically work for Debian/Ubuntu and Arch as well, but as mentioned before, official packages are provided)"

case $distro_selection in

    1)
        echo "Debian/Ubuntu selected."
        sudo apt update -y
        sudo apt upgrade -y

        wget -P "https://launcher.mojang.com/download/Minecraft.deb"

        cd Downloads
        sudo apt install ./Minecraft.deb

        exit 1

        ;;
    2)
        echo "Arch selected."
        # enter install commands here
        ;;
    3)
        echo "Other selected."



# File URL and target directory
FILE_URL="https://launcher.mojang.com/download/Minecraft.tar.gz"
TARGET_DIR="$HOME/Downloads"

# Download file
wget -P "$TARGET_DIR" "$FILE_URL"

# Outputs message saying file downloaded
echo "Minecraft Java tarball archive downloaded."

# Extracts archive and outputs to home directory
cd
cd Downloads
tar -xzvf Minecraft.tar.gz -C $HOME

echo "Extracted to user home directory."

cd
cd Downloads
rm -r Minecraft.tar.gz

"Tarball not needed anymore, removed."

cd
cd minecraft-launcher

"Opening Minecraft launcher..."

./minecraft-launcher

echo "Minecraft install should be located in the .minecraft folder in the user home directory."

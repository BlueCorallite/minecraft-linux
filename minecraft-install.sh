#!/bin/bash

# Exit script on error
set -e

# Prompt user for continuation
read -p "If you are on a Debian/Ubuntu or Arch-based OS, the tarball package is not required. Official releases for those distros are provided by Mojang, which will also be installed by this script if you want. Would you like to continue? (y/n): " choice

if [[ "$choice" =~ ^(n|N)$ ]]; then
    echo "Terminating script."
    exit 1
fi

# Ask the user to select their operating system
echo "Select the corresponding number for your OS, or what it's based on (e.g., Linux Mint is Ubuntu-based, EndeavorOS is Arch-based):"
echo "1. Debian/Ubuntu"
echo "2. Arch"
echo "3. tar.gz package for other OSes (can also work for Debian/Ubuntu and Arch, but official packages are recommended)"
read -p "Enter your choice: " distro_selection

case $distro_selection in
    1)
        echo "Debian/Ubuntu selected."
        sudo apt update -y && sudo apt upgrade -y

        # Download and install Minecraft Debian package
        wget -P "$HOME/Downloads" "https://launcher.mojang.com/download/Minecraft.deb" || { echo "Failed to download package."; exit 1; }

        cd "$HOME/Downloads"
        if [[ ! -f "Minecraft.deb" ]]; then
            echo "Error: Downloaded file not found."
            exit 1
        fi

        sudo apt install ./Minecraft.deb -y || { echo "Failed to install Minecraft."; exit 1; }

        echo "Minecraft installed successfully!"
        ;;
    2)
        echo "Arch selected."
        echo "For Arch-based systems, Minecraft is available in the AUR."
        echo ""

        read -p "Would you like to continue? (y/n): " arch_choice
        if [[ "$arch_choice" =~ ^(n|N)$ ]]; then
            echo "Terminating script."
            exit 1
        fi

        # Clone the AUR repo and build package
        cd "$HOME"
        git clone https://aur.archlinux.org/minecraft-launcher.git || { echo "Failed to clone AUR repository."; exit 1; }
        cd minecraft-launcher

        # Install build dependencies if not installed
        if ! pacman -Qi base-devel > /dev/null 2>&1; then
            echo "Installing build dependencies..."
            sudo pacman -S --noconfirm base-devel
        fi

        echo "Building and installing Minecraft Launcher..."
        makepkg -s -i || { echo "Failed to build or install package."; exit 1; }

        echo "Opening launcher..."
        minecraft-launcher
        echo "If successful, the Minecraft installation should be in the .minecraft folder in the user home directory."
        ;;
    3)
        echo "Other selected."

        # File URL and target directory
        FILE_URL="https://launcher.mojang.com/download/Minecraft.tar.gz"
        TARGET_DIR="$HOME/Downloads"

        # Download the tarball package
        wget -P "$TARGET_DIR" "$FILE_URL" || { echo "Failed to download tarball."; exit 1; }

        # Verify download
        if [[ ! -f "$TARGET_DIR/Minecraft.tar.gz" ]]; then
            echo "Error: Downloaded file not found."
            exit 1
        fi

        # Outputs message saying the file was downloaded
        echo "Minecraft Java tarball archive downloaded."

        # Extracts archive and outputs to home directory
        tar -xzvf "$TARGET_DIR/Minecraft.tar.gz" -C "$HOME" || { echo "Failed to extract tarball."; exit 1; }

        echo "Extracted to the user home directory."

        # Remove the tarball
        rm -f "$TARGET_DIR/Minecraft.tar.gz"
        echo "Tarball not needed anymore, removed."

        # Open the Minecraft launcher
        cd "$HOME/Minecraft" || { echo "Failed to change directory."; exit 1; }
        echo "Opening Minecraft launcher..."
        ./minecraft-launcher || { echo "Failed to run launcher."; exit 1; }

        echo "Minecraft installation should be located in the .minecraft folder in the user home directory."
        ;;
    *)
        echo "Invalid selection. Exiting script."
        exit 1
        ;;
esac

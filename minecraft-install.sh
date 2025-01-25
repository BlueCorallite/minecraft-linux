#!/bin/bash

# Update system (commented out for manual control)
# sudo dnf update -y

# Prompt user for continuation
read -p "If you are on a Debian/Ubuntu or Arch-based OS, the tarball package is not required. Official releases for those distros are provided by Mojang, which will also be installed by this script if you want. Otherwise, it's just a simple download and click. Would you like to continue? (y/n): " choice

if [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo "Terminating script."
    exit 1  # Exit the script
fi

# Ask the user to select their operating system
echo "Select the corresponding number for your OS, or what it's based on (e.g., Linux Mint is Ubuntu-based):"
echo "1. Debian/Ubuntu"
echo "2. Arch"
echo "3. tar.gz package for other OSes (can also work for Debian/Ubuntu and Arch, but official packages are recommended)"
read -p "Enter your choice: " distro_selection

case $distro_selection in
    1)
        echo "Debian/Ubuntu selected."
        sudo apt update -y
        sudo apt upgrade -y

        # Download and install Minecraft Debian package
        wget -P "$HOME/Downloads" "https://launcher.mojang.com/download/Minecraft.deb"

        cd "$HOME/Downloads"
        sudo apt install ./Minecraft.deb -y

        echo "Minecraft installed successfully!"
        exit 0
        ;;
    2)
        echo "Arch selected."
        echo "For Arch-based systems, Minecraft is available in the AUR. Please use an AUR helper like yay or manually install it."
        echo "Example command: yay -S minecraft-launcher"
        exit 0
        ;;
    3)
        echo "Other selected."

        # File URL and target directory
        FILE_URL="https://launcher.mojang.com/download/Minecraft.tar.gz"
        TARGET_DIR="$HOME/Downloads"

        # Download the tarball package
        wget -P "$TARGET_DIR" "$FILE_URL"

        # Outputs message saying the file was downloaded
        echo "Minecraft Java tarball archive downloaded."

        # Extracts archive and outputs to home directory
        cd "$TARGET_DIR"
        tar -xzvf Minecraft.tar.gz -C "$HOME"

        echo "Extracted to the user home directory."

        # Remove the tarball
        rm -f Minecraft.tar.gz
        echo "Tarball not needed anymore, removed."

        # Open the Minecraft launcher
        cd "$HOME/minecraft-launcher"
        echo "Opening Minecraft launcher..."
        ./minecraft-launcher

        echo "Minecraft installation should be located in the .minecraft folder in the user home directory."
        exit 0
        ;;
    *)
        echo "Invalid selection. Exiting script."
        exit 1
        ;;
esac

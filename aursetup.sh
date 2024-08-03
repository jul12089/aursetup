#!/bin/bash

# Function to check if a package is installed
is_installed() {
    pacman -Qi $1 &> /dev/null
}

# Function to install git if not installed
install_git() {
    if ! is_installed git; then
        echo "Git is not installed. Installing git..."
        sudo pacman -S --needed git
    else
        echo "Git is already installed."
    fi
}

# Function to install yay from AUR
install_yay() {
    echo "Cloning yay from AUR..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    echo "Building and installing yay..."
    makepkg -si
    cd ~
    echo "Cleaning up..."
    rm -rf /tmp/yay
}

# Function to install chaotic AUR
install_chaotic_aur() {
    echo "Adding chaotic AUR repository..."
    sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key FBA220DFC880C036
    sudo pacman -U --needed 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U --needed 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
    echo "Updating package database..."
    sudo pacman -Sy
}

# Main script execution
install_git
install_yay
install_chaotic_aur

echo "Installation completed successfully!"

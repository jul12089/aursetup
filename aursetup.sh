#!/bin/bash

# Function to display a progress bar
progress_bar() {
    local duration=$1
    local steps=$2
    local progress=0
    local step_size=$((duration / steps))
    
    printf "[%-${steps}s] " ""

    for ((i = 0; i < steps; i++)); do
        echo -ne "\033[1D#"
        sleep $step_size
    done
    
    echo -e "\033[1D(Done)"
}

echo "Start"

# Receive and sign Chaotic key
echo "Receiving and signing Chaotic key..."
{
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com &> /dev/null
    sudo pacman-key --lsign-key 3056513887B78AEB &> /dev/null
} &> /dev/null &

wait

# Install chaotic-keyring
echo "Installing chaotic-keyring..."
{
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' &> /dev/null
} &> /dev/null &

wait

# Install chaotic-mirrorlist
echo "Installing chaotic-mirrorlist..."
{
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' &> /dev/null
} &> /dev/null &

wait

# Add chaotic-aur to pacman.conf
echo "Adding chaotic-aur to pacman.conf..."
sudo sh -c 'echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf'

# Update pacman database
echo "Updating pacman database..."
{
    sudo pacman -Sy &> /dev/null
} &> /dev/null &
echo "Installing yay (an aur helper)..."
{
    sudo pacman -S yay &> /dev/null
} &> /dev/null &
wait

echo "Done!"

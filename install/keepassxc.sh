#!/bin/bash

# Install KeePassXC if not already installed
if ! pacman -Qi keepassxc &> /dev/null; then
    echo "Installing KeePassXC..."
    sudo pacman -S --noconfirm --needed keepassxc
else
    echo "KeePassXC already installed, skipping"
fi

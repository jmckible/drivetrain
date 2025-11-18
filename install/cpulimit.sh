#!/bin/bash

# Install cpulimit from AUR if not already installed
if ! pacman -Qi cpulimit &> /dev/null; then
    echo "Installing cpulimit from AUR..."
    yay -S --noconfirm --needed cpulimit
else
    echo "cpulimit already installed, skipping"
fi

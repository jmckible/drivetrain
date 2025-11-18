#!/bin/bash

# Check if MesloLGS Nerd Font is already installed
if pacman -Qi ttf-meslo-nerd &> /dev/null; then
    echo "MesloLGS Nerd Font already installed, skipping"
else
    echo "Installing MesloLGS Nerd Font..."
    sudo pacman -S --noconfirm --needed ttf-meslo-nerd
fi

# Set as default font via omarchy
echo "Setting MesloLGS Nerd Font Mono as default font..."
omarchy-font-set "MesloLGS Nerd Font Mono"

echo "Font installation complete!"

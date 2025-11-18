#!/bin/bash

# Install MesloLGS Nerd Font
echo "Installing MesloLGS Nerd Font..."
sudo pacman -S --noconfirm --needed ttf-meslo-nerd

# Set as default font via omarchy
echo "Setting MesloLGS Nerd Font Mono as default font..."
omarchy-font-set "MesloLGS Nerd Font Mono"

echo "Font installation complete!"

#!/bin/bash

# Install stow
yay -S --noconfirm --needed stow

STOW_DIR="$(pwd)/stow"

rm -rf ~/.config/nvim
stow -d "$STOW_DIR" -t ~ nvim

# Stow shared hypr configs (these are symlinked)
stow -d "$STOW_DIR" -t ~ hypr

# Copy machine-specific templates (these are local copies, not symlinked)
TEMPLATE_DIR="$(pwd)/templates/hypr"
cp "$TEMPLATE_DIR/monitors.conf" ~/.config/hypr/monitors.conf
cp "$TEMPLATE_DIR/input.conf" ~/.config/hypr/input.conf
cp "$TEMPLATE_DIR/looknfeel.conf" ~/.config/hypr/looknfeel.conf
cp "$TEMPLATE_DIR/envs.conf" ~/.config/hypr/envs.conf

hyprctl reload

echo ""
echo "========================================="
echo "MANUAL CONFIGURATION REQUIRED"
echo "========================================="
echo ""
echo "Edit the following files to uncomment settings for your machine:"
echo ""
echo "1. ~/.config/hypr/monitors.conf"
echo "   - Uncomment DESKTOP or LAPTOP monitor settings"
echo ""
echo "2. ~/.config/hypr/input.conf"
echo "   - Uncomment DESKTOP or LAPTOP sensitivity settings"
echo ""
echo "3. ~/.config/hypr/looknfeel.conf"
echo "   - Uncomment DESKTOP aspect ratio if on large screen"
echo ""
echo "4. ~/.config/hypr/envs.conf"
echo "   - Uncomment DESKTOP NVIDIA settings or LAPTOP settings"
echo ""
echo "After editing, reload Hyprland:"
echo "   hyprctl reload"
echo ""

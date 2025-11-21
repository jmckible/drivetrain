#!/bin/bash

# Remove unwanted packages that come with Omarchy by default

UNWANTED_PACKAGES=(
    "1password"
    "1password-beta"
    "1password-cli"
    "signal-desktop"
    "obs-studio"
)

for pkg in "${UNWANTED_PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &> /dev/null; then
        echo "Removing $pkg..."
        sudo pacman -Rns --noconfirm "$pkg" 2>/dev/null || echo "Could not remove $pkg (may have dependencies)"
    else
        echo "$pkg not installed, skipping"
    fi
done

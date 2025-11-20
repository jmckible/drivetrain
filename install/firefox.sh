#!/bin/bash

# Check if firefox is already installed
if ! pacman -Q firefox &>/dev/null; then
    # Install firefox from official repos
    sudo pacman -S --noconfirm --needed firefox
fi

# Set Firefox as default browser (suppress warnings if $BROWSER is already set)
xdg-settings set default-web-browser firefox.desktop 2>/dev/null || true

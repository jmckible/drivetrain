#!/bin/bash

# Install firefox from official repos
sudo pacman -S --noconfirm --needed firefox

# Set Firefox as default browser (suppress warnings if $BROWSER is already set)
xdg-settings set default-web-browser firefox.desktop 2>/dev/null || true

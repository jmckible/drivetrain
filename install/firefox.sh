#!/bin/bash

# Install firefox from official repos
sudo pacman -S --noconfirm --needed firefox

# Set Firefox as default browser
xdg-settings set default-web-browser firefox.desktop

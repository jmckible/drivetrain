#!/bin/bash

# Check if transmission-qt is already installed
if ! pacman -Q transmission-qt &>/dev/null; then
    echo -e "${BLUE}▸${RESET} Installing Transmission..."
    sudo pacman -S --noconfirm --needed transmission-qt
    echo -e "${GREEN}✓${RESET} Transmission installed"
else
    echo -e "${GREEN}✓${RESET} Transmission already installed"
fi

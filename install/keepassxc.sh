#!/bin/bash

# Install KeePassXC if not already installed
if ! pacman -Qi keepassxc &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing KeePassXC..."
    sudo pacman -S --noconfirm --needed keepassxc
    echo -e "${GREEN}✓${RESET} KeePassXC installed"
else
    echo -e "${GREEN}✓${RESET} KeePassXC already installed"
fi

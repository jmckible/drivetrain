#!/bin/bash

# Install cpulimit from AUR if not already installed
if ! pacman -Qi cpulimit &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing cpulimit from AUR..."
    yay -S --noconfirm --needed cpulimit
    echo -e "${GREEN}✓${RESET} cpulimit installed"
else
    echo -e "${GREEN}✓${RESET} cpulimit already installed"
fi

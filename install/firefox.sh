#!/bin/bash

# Check if firefox is already installed
if ! pacman -Q firefox &>/dev/null; then
    echo -e "${BLUE}▸${RESET} Installing Firefox..."
    sudo pacman -S --noconfirm --needed firefox
    echo -e "${GREEN}✓${RESET} Firefox installed"
else
    echo -e "${GREEN}✓${RESET} Firefox already installed"
fi

# Set Firefox as default browser (suppress warnings if $BROWSER is already set)
xdg-settings set default-web-browser firefox.desktop 2>/dev/null || true

#!/bin/bash

# Install sunwait for sunrise/sunset calculations
if ! command -v sunwait &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing sunwait..."
    yay -S --noconfirm sunwait
    echo -e "${GREEN}✓${RESET} sunwait installed"
else
    echo -e "${GREEN}✓${RESET} sunwait already installed"
fi

# Install magick Lua rock for image.nvim (Neovim uses LuaJIT/Lua 5.1)
if ! luarocks --lua-version 5.1 list | grep -q "^magick"; then
    echo -e "${BLUE}▸${RESET} Installing magick Lua rock..."
    luarocks --lua-version 5.1 --local install magick
    echo -e "${GREEN}✓${RESET} magick installed"
else
    echo -e "${GREEN}✓${RESET} magick already installed"
fi

# Install Ruby dev environment if not already installed
if ! command -v ruby &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing Ruby dev environment..."
    omarchy-install-dev-env ruby
    echo -e "${GREEN}✓${RESET} Ruby installed"
else
    echo -e "${GREEN}✓${RESET} Ruby already installed"
fi

# Install Node dev environment if not already installed
if ! command -v node &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing Node dev environment..."
    omarchy-install-dev-env node
    echo -e "${GREEN}✓${RESET} Node installed"
else
    echo -e "${GREEN}✓${RESET} Node already installed"
fi

# Install Dropbox if not already installed
if ! command -v dropbox &> /dev/null && ! pacman -Qi dropbox &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing Dropbox..."
    omarchy-install-dropbox
    echo -e "${GREEN}✓${RESET} Dropbox installed"
else
    echo -e "${GREEN}✓${RESET} Dropbox already installed"
fi

# Enable Dropbox auto-start
if systemctl --user is-enabled dropbox &>/dev/null; then
    echo -e "${GREEN}✓${RESET} Dropbox auto-start already enabled"
else
    echo -e "${BLUE}▸${RESET} Enabling Dropbox auto-start..."
    systemctl --user enable dropbox
    echo -e "${GREEN}✓${RESET} Dropbox will start automatically on boot"
fi

# Install Steam if not already installed (skip on laptop - no gaming on MacBook)
MACHINE_TYPE=""
if [[ -f /tmp/drivetrain-machine-type ]]; then
    MACHINE_TYPE=$(cat /tmp/drivetrain-machine-type)
fi

if [[ "$MACHINE_TYPE" == "laptop" ]]; then
    echo -e "${DIM}○ Skipping Steam (laptop)${RESET}"
elif ! pacman -Qi steam &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing Steam..."
    omarchy-install-steam
    echo -e "${GREEN}✓${RESET} Steam installed"
else
    echo -e "${GREEN}✓${RESET} Steam already installed"
fi

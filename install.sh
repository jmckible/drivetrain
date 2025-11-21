#!/bin/bash

# Usage: ./install.sh [desktop|laptop]
# If no argument provided, auto-detection will be used

MACHINE_TYPE="$1"

# Install SSH first as a backdoor in case something breaks
./install/ssh.sh

# Remove unwanted packages
./install/remove-unwanted.sh

# Install theme first, before stowing hyprland config that references it
./install/theme.sh

# Install font before stowing configs that reference it
# ./install/font.sh

./install/stow.sh "$MACHINE_TYPE"
./install/keyd.sh
./install/firefox.sh
./install/keepassxc.sh
./install/transmission.sh
./install/slack.sh
./install/cpulimit.sh
./install/omarchy-packages.sh
./install/claude-code.sh

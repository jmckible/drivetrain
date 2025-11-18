#!/bin/bash

# Install SSH first as a backdoor in case something breaks
./install/ssh.sh

# Install theme first, before stowing hyprland config that references it
./install/theme.sh

./install/stow.sh
./install/keyd.sh
./install/firefox.sh
./install/keepassxc.sh
./install/omarchy-packages.sh
./install/claude-code.sh

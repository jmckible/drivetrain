#!/bin/bash

# Usage: ./install.sh [desktop|laptop]
# If no argument provided, auto-detection will be used
# Note: "laptop" maps to macbookpro-2014 template directory

# Colors and formatting
export BOLD='\033[1m'
export DIM='\033[2m'
export RESET='\033[0m'
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export YELLOW='\033[0;33m'
export RED='\033[0;31m'

# Helper functions
header() {
    echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}${BLUE}  $1${RESET}"
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
}

step() {
    echo -e "${BOLD}${BLUE}▸${RESET} $1"
}

export -f header step

MACHINE_TYPE="$1"

# ASCII art header
echo -e "${BOLD}${CYAN}"
cat << "EOF"
██████████████████████████████████████████████████████
██████████████████████████████████████████████████████
████                     ████                     ████
████                     ████                     ████
████    █████████████████████         ████████    ████
████    █████████████████████         ████████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████████████                              ████    ████
████████████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ██████████████████████████████████████    ████
████    ██████████████████████████████████████    ████
████                     ████                     ████
████                     ████                     ████
█████████████████████████████     ████████████████████
█████████████████████████████     ████████████████████

██████╗ ██████╗ ██╗██╗   ██╗███████╗████████╗██████╗  █████╗ ██╗███╗   ██╗
██╔══██╗██╔══██╗██║██║   ██║██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██║████╗  ██║
██║  ██║██████╔╝██║██║   ██║█████╗     ██║   ██████╔╝███████║██║██╔██╗ ██║
██║  ██║██╔══██╗██║╚██╗ ██╔╝██╔══╝     ██║   ██╔══██╗██╔══██║██║██║╚██╗██║
██████╔╝██║  ██║██║ ╚████╔╝ ███████╗   ██║   ██║  ██║██║  ██║██║██║ ╚████║
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝

EOF
echo -e "${RESET}\n"

# Install SSH first as a backdoor in case something breaks
header "🔐 SSH Setup"
./install/ssh.sh

# Remove unwanted packages
header "🗑️  Cleanup"
./install/remove-unwanted.sh

# Install theme first, before stowing hyprland config that references it
header "🎨 Theme Installation"
./install/theme.sh

# Install font before stowing configs that reference it
# ./install/font.sh

header "📦 Configuration Deployment"
./install/stow.sh "$MACHINE_TYPE"

header "⌨️  Additional Components"
./install/keyd.sh
./install/omarchy-packages.sh
./install/helium.sh
./install/keepassxc.sh
./install/transmission.sh
./install/slack.sh
./install/cpulimit.sh
./install/claude-code.sh
./install/cloudflared.sh
./install/backups.sh

# Final summary
echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}${GREEN}✓ Installation Complete!${RESET}"
echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

#!/bin/bash

# Check if machine type was set (from stow.sh)
MACHINE_TYPE=""
if [[ -f /tmp/drivetrain-machine-type ]]; then
    MACHINE_TYPE=$(cat /tmp/drivetrain-machine-type)
fi

# Determine template directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../templates/keyd"
MACBOOKPRO_2014_TEMPLATE="$TEMPLATE_DIR/macbookpro-2014.conf"
DESKTOP_TEMPLATE="$TEMPLATE_DIR/desktop.conf"

# Use machine-specific template if available, otherwise use default
if [[ "$MACHINE_TYPE" == "laptop" ]] && [[ -f "$MACBOOKPRO_2014_TEMPLATE" ]]; then
    TEMPLATE="$MACBOOKPRO_2014_TEMPLATE"
elif [[ "$MACHINE_TYPE" == "desktop" ]] && [[ -f "$DESKTOP_TEMPLATE" ]]; then
    TEMPLATE="$DESKTOP_TEMPLATE"
else
    TEMPLATE="$TEMPLATE_DIR/default.conf"
fi

# Check if keyd or keyd-git is already installed
KEYD_INSTALLED=false
if pacman -Qq keyd &>/dev/null || pacman -Qq keyd-git &>/dev/null; then
    KEYD_INSTALLED=true
fi

# Install keyd if not present
if ! $KEYD_INSTALLED; then
    echo -e "${BLUE}▸${RESET} Installing keyd..."
    sudo pacman -S --noconfirm --needed keyd
    echo -e "${GREEN}✓${RESET} keyd installed"
else
    echo -e "${GREEN}✓${RESET} keyd already installed"
fi

# Update configuration if needed (ignore comment-only differences)
CONFIG_NEEDS_UPDATE=false
if [[ ! -f /etc/keyd/default.conf ]]; then
    CONFIG_NEEDS_UPDATE=true
else
    # Compare configs without comments
    CURRENT_NO_COMMENTS=$(grep -v '^#' /etc/keyd/default.conf | grep -v '^[[:space:]]*$')
    TEMPLATE_NO_COMMENTS=$(grep -v '^#' "$TEMPLATE" | grep -v '^[[:space:]]*$')
    if [[ "$CURRENT_NO_COMMENTS" != "$TEMPLATE_NO_COMMENTS" ]]; then
        CONFIG_NEEDS_UPDATE=true
    fi
fi

if $CONFIG_NEEDS_UPDATE; then
    echo -e "${DIM}  Updating configuration from template...${RESET}"
    sudo mkdir -p /etc/keyd
    sudo cp "$TEMPLATE" /etc/keyd/default.conf
    echo -e "${GREEN}✓${RESET} keyd configuration updated"
else
    echo -e "${GREEN}✓${RESET} keyd configuration already up to date"
fi

# Enable service if needed
if ! systemctl is-enabled keyd &>/dev/null; then
    echo -e "${DIM}  Enabling service...${RESET}"
    sudo systemctl enable --now keyd
    echo -e "${GREEN}✓${RESET} keyd service enabled"
else
    echo -e "${GREEN}✓${RESET} keyd service already enabled"
fi

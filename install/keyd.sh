#!/bin/bash

# Check if machine type was set (from stow.sh)
MACHINE_TYPE=""
if [[ -f /tmp/drivetrain-machine-type ]]; then
    MACHINE_TYPE=$(cat /tmp/drivetrain-machine-type)
fi

# Determine template directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../templates/keyd"
LAPTOP_TEMPLATE="$TEMPLATE_DIR/laptop.conf"
DESKTOP_TEMPLATE="$TEMPLATE_DIR/desktop.conf"

# Use machine-specific template if available, otherwise use default
if [[ "$MACHINE_TYPE" == "laptop" ]] && [[ -f "$LAPTOP_TEMPLATE" ]]; then
    TEMPLATE="$LAPTOP_TEMPLATE"
elif [[ "$MACHINE_TYPE" == "desktop" ]] && [[ -f "$DESKTOP_TEMPLATE" ]]; then
    TEMPLATE="$DESKTOP_TEMPLATE"
else
    TEMPLATE="$TEMPLATE_DIR/default.conf"
fi

# Check if keyd or keyd-git is already installed and configured
if pacman -Qq keyd &>/dev/null || pacman -Qq keyd-git &>/dev/null; then
    # Check if the configuration matches our template
    if [[ -f /etc/keyd/default.conf ]] && [[ -f "$TEMPLATE" ]]; then
        if diff -q /etc/keyd/default.conf "$TEMPLATE" &>/dev/null; then
            # Check if service is enabled
            if systemctl is-enabled keyd &>/dev/null; then
                echo -e "${GREEN}✓${RESET} keyd already configured"
                exit 0
            fi
        fi
    fi
fi

echo -e "${BLUE}▸${RESET} Installing keyd..."
sudo pacman -S --noconfirm --needed keyd

echo -e "${DIM}  Creating configuration from template...${RESET}"
sudo mkdir -p /etc/keyd
sudo cp "$TEMPLATE" /etc/keyd/default.conf

echo -e "${DIM}  Enabling service...${RESET}"
sudo systemctl enable --now keyd

echo -e "${GREEN}✓${RESET} keyd installed and configured"

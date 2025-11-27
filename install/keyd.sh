#!/bin/bash

# Check if machine type was set (from stow.sh)
MACHINE_TYPE=""
if [[ -f /tmp/drivetrain-machine-type ]]; then
    MACHINE_TYPE=$(cat /tmp/drivetrain-machine-type)
fi

# Only install on laptop (fixes MacBook Pro F12->7 mapping issue)
if [[ "$MACHINE_TYPE" != "laptop" ]]; then
    echo -e "${DIM}○ Skipping keyd (laptop only)${RESET}"
    exit 0
fi

# Check if keyd or keyd-git is already installed
if pacman -Qq keyd &>/dev/null || pacman -Qq keyd-git &>/dev/null; then
    # Check if the configuration is already correct
    if [[ -f /etc/keyd/default.conf ]] && grep -q "f12 = 7" /etc/keyd/default.conf; then
        # Check if service is enabled
        if systemctl is-enabled keyd &>/dev/null; then
            echo -e "${GREEN}✓${RESET} keyd already configured (F12→7)"
            exit 0
        fi
    fi
fi

echo -e "${BLUE}▸${RESET} Installing keyd (F12→7 mapping fix)..."
sudo pacman -S --noconfirm --needed keyd

echo -e "${DIM}  Creating configuration...${RESET}"
sudo mkdir -p /etc/keyd
sudo tee /etc/keyd/default.conf > /dev/null << 'EOF'
[ids]
*

[main]
f12 = 7
EOF

echo -e "${DIM}  Enabling service...${RESET}"
sudo systemctl enable --now keyd

echo -e "${GREEN}✓${RESET} keyd installed (F12→7)"

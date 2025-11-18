#!/bin/bash

# Check if machine type was set (from stow.sh)
MACHINE_TYPE=""
if [[ -f /tmp/drivetrain-machine-type ]]; then
    MACHINE_TYPE=$(cat /tmp/drivetrain-machine-type)
fi

# Only install on laptop (fixes MacBook Pro F12->7 mapping issue)
if [[ "$MACHINE_TYPE" != "laptop" ]]; then
    echo "Skipping keyd (laptop only)"
    exit 0
fi

echo "Laptop detected - installing keyd fix for F12->7 mapping"

# Check if keyd or keyd-git is already installed
if pacman -Qq keyd &>/dev/null || pacman -Qq keyd-git &>/dev/null; then
    # Check if the configuration is already correct
    if [[ -f /etc/keyd/default.conf ]] && grep -q "f12 = 7" /etc/keyd/default.conf; then
        # Check if service is enabled
        if systemctl is-enabled keyd &>/dev/null; then
            echo "keyd already installed and configured with F12->7 mapping, skipping"
            exit 0
        fi
    fi
fi

echo "Installing keyd..."
sudo pacman -S --noconfirm --needed keyd

echo "Creating keyd configuration..."
sudo mkdir -p /etc/keyd
sudo tee /etc/keyd/default.conf > /dev/null << 'EOF'
[ids]
*

[main]
f12 = 7
EOF

echo "Enabling and starting keyd service..."
sudo systemctl enable --now keyd

echo "keyd installation complete! F12 now mapped to 7"

#!/bin/bash

# Check if machine type was set (from stow.sh)
MACHINE_TYPE=""
if [[ -f /tmp/drivetrain-machine-type ]]; then
    MACHINE_TYPE=$(cat /tmp/drivetrain-machine-type)
fi

# If laptop was selected, install automatically
if [[ "$MACHINE_TYPE" == "2" ]]; then
    echo "Laptop detected - installing keyd fix for F12->7 mapping automatically"
else
    # Otherwise, ask if we should install the keyd fix
    read -p "Install keyd fix for F12->7 mapping? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping keyd installation"
        exit 0
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

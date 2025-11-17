#!/bin/bash

# Ask if we should install the keyd fix
read -p "Install keyd fix for F12->7 mapping? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping keyd installation"
    exit 0
fi

echo "Installing keyd..."
yay -S --noconfirm --needed keyd

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

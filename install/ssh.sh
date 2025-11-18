#!/bin/bash

# Check if SSH is already installed and running
if pacman -Qi openssh &> /dev/null && systemctl is-active --quiet sshd; then
    echo "SSH server already installed and running, skipping"
    exit 0
fi

echo "Installing and enabling SSH server for remote access..."

# Install OpenSSH server from official repos (not AUR variants)
sudo pacman -S --noconfirm --needed openssh

# Enable and start sshd service
sudo systemctl enable sshd
sudo systemctl start sshd

echo "SSH server installed and running"
echo "You can connect remotely via: ssh $(whoami)@<ip-address>"

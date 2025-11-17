#!/bin/bash

echo "Installing and enabling SSH server for remote access..."

# Install OpenSSH server from official repos (not AUR variants)
sudo pacman -S --noconfirm --needed openssh

# Enable and start sshd service
sudo systemctl enable sshd
sudo systemctl start sshd

echo "SSH server installed and running"
echo "You can connect remotely via: ssh $(whoami)@<ip-address>"

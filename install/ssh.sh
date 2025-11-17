#!/bin/bash

echo "Installing and enabling SSH server for remote access..."

# Install OpenSSH server
yay -S --noconfirm --needed openssh

# Enable and start sshd service
sudo systemctl enable sshd
sudo systemctl start sshd

echo "SSH server installed and running"
echo "You can connect remotely via: ssh $(whoami)@<ip-address>"

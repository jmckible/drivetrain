#!/bin/bash

# Check if SSH is already installed and running
if pacman -Qi openssh &> /dev/null && systemctl is-active --quiet sshd; then
    echo -e "${GREEN}✓${RESET} SSH server already installed and running"
    exit 0
fi

echo -e "${BLUE}▸${RESET} Installing and enabling SSH server..."

# Install OpenSSH server from official repos (not AUR variants)
sudo pacman -S --noconfirm --needed openssh

# Enable and start sshd service
sudo systemctl enable sshd
sudo systemctl start sshd

echo -e "${GREEN}✓${RESET} SSH server installed and running"
echo -e "${DIM}  Connect via: ssh $(whoami)@<ip-address>${RESET}"

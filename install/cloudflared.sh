#!/bin/bash

# Check if cloudflared is already installed and running
if pacman -Qi cloudflared &> /dev/null && systemctl is-active --quiet cloudflared; then
    echo -e "${GREEN}✓${RESET} cloudflared already installed and running"
    exit 0
fi

echo -e "${BLUE}▸${RESET} Installing cloudflared..."

if ! pacman -Qi cloudflared &> /dev/null; then
    sudo pacman -S --noconfirm --needed cloudflared
fi

# Deploy config from drivetrain
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$DIR/cloudflared/deploy.sh"

# Credentials file must exist (created by: cloudflared tunnel login && cloudflared tunnel create dell)
if [ ! -f "$HOME/.cloudflared/3b5096d3-3b68-49d9-b5d6-5b3ccd0432a4.json" ]; then
    echo -e "${YELLOW}⚠${RESET} Tunnel credentials not found. Run:"
    echo -e "${DIM}  cloudflared tunnel login${RESET}"
    echo -e "${DIM}  cloudflared tunnel create dell${RESET}"
    exit 1
fi

# Install and start systemd service
sudo cloudflared --config "$HOME/.cloudflared/config.yml" service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared

echo -e "${GREEN}✓${RESET} cloudflared tunnel running"
echo -e "${DIM}  Routing tumblepop.com + *.tumblepop.com → kamal-proxy${RESET}"

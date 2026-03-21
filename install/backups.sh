#!/bin/bash

# Install backup dependencies and configure systemd timer

# rclone
if ! command -v rclone &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing rclone..."
    sudo pacman -S --noconfirm --needed rclone
else
    echo -e "${GREEN}✓${RESET} rclone already installed"
fi

# Backup directory
mkdir -p "$HOME/backups" "$HOME/bin"

# Deploy backup script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$DIR/backups/backup-tumblepop.sh" "$HOME/bin/backup-tumblepop"
chmod +x "$HOME/bin/backup-tumblepop"

# Check rclone B2 config
if ! rclone listremotes 2>/dev/null | grep -q "^b2:"; then
    echo -e "${YELLOW}⚠${RESET} Backblaze B2 not configured in rclone. Run:"
    echo -e "${DIM}  rclone config${RESET}"
    echo -e "${DIM}  Choose: New remote → name: b2 → type: Backblaze B2 → enter key ID + app key${RESET}"
fi

# Check NAS connectivity
if ! ping -c 1 -W 2 nas &>/dev/null; then
    echo -e "${YELLOW}⚠${RESET} NAS not reachable. Ensure it's on Tailscale as 'nas'"
else
    ssh admin@nas "mkdir -p /share/backups/tumblepop" 2>/dev/null || true
fi

# Enable systemd timer (stow handles the unit files)
systemctl --user daemon-reload
systemctl --user enable backup-tumblepop.timer
systemctl --user start backup-tumblepop.timer

echo -e "${GREEN}✓${RESET} Backup timer enabled (every 6 hours)"
echo -e "${DIM}  Local: rsync to admin@nas:/share/backups/tumblepop${RESET}"
echo -e "${DIM}  Offsite: rclone to b2:tumblepop-backups${RESET}"
echo -e "${DIM}  Check status: systemctl --user status backup-tumblepop.timer${RESET}"

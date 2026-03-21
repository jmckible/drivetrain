#!/bin/bash

# Install backup dependencies and configure systemd timers

# rclone
if ! command -v rclone &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing rclone..."
    sudo pacman -S --noconfirm --needed rclone
else
    echo -e "${GREEN}✓${RESET} rclone already installed"
fi

# Backup directory
mkdir -p "$HOME/backups" "$HOME/bin"

# Deploy backup scripts
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for app in dashboard tumblepop stardate esophagus; do
    cp "$DIR/backups/backup-${app}.sh" "$HOME/bin/backup-${app}"
    chmod +x "$HOME/bin/backup-${app}"
done

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
    for app in dashboard tumblepop stardate esophagus; do
        ssh admin@nas "mkdir -p /share/backups/${app}" 2>/dev/null || true
    done
fi

# Enable systemd timers (stow handles the unit files)
systemctl --user daemon-reload
for app in dashboard tumblepop stardate esophagus; do
    systemctl --user enable "backup-${app}.timer"
    systemctl --user start "backup-${app}.timer"
done

echo -e "${GREEN}✓${RESET} Backup timers enabled (daily, staggered)"
echo -e "${DIM}  dashboard 00:00 · tumblepop 06:00 · stardate 12:00 · esophagus 18:00${RESET}"
echo -e "${DIM}  Retention: 7 days local, 30 days B2${RESET}"
echo -e "${DIM}  Check status: systemctl --user list-timers 'backup-*'${RESET}"

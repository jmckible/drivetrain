#!/bin/bash
set -euo pipefail

# Backup Stardate SQLite database
# Runs via systemd timer. Requires: rclone (with b2 remote configured), rsync

CONTAINER=$(docker ps --filter name=stardate-web --format '{{.Names}}' | head -1)
BACKUP_DIR="$HOME/backups/stardate/$(date +%Y-%m-%d_%H%M)"
NAS_DEST="admin@nas:/share/backups/stardate"
B2_DEST="b2:stardate-backups"

if [ -z "$CONTAINER" ]; then
  echo "ERROR: No stardate container running"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

# Primary database (run sqlite3 .backup inside the container, copy out)
docker exec "$CONTAINER" sqlite3 /rails/storage/production.sqlite3 ".backup '/rails/storage/production.sqlite3.bak'"
docker cp "$CONTAINER:/rails/storage/production.sqlite3.bak" "$BACKUP_DIR/production.sqlite3"
docker exec "$CONTAINER" rm /rails/storage/production.sqlite3.bak

# Sync to NAS (local, fast restore)
rsync -az --delete "$HOME/backups/stardate/" "$NAS_DEST/" 2>/dev/null || echo "WARNING: NAS sync failed"

# Sync to Backblaze B2 (offsite, disaster recovery)
rclone sync "$HOME/backups/stardate/" "$B2_DEST/" 2>/dev/null || echo "WARNING: B2 sync failed"

# Prune local backups older than 7 days
find "$HOME/backups/stardate" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} +

# Prune NAS backups older than 6 months
rclone delete --min-age 6M "$B2_DEST/" 2>/dev/null || echo "WARNING: B2 prune failed"
ssh admin@nas "find /share/backups/stardate -maxdepth 1 -type d -mtime +180 -exec rm -rf {} +" 2>/dev/null || echo "WARNING: NAS prune failed"

echo "$(date): Stardate backup complete → $BACKUP_DIR"

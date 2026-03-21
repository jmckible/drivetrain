#!/bin/bash
set -euo pipefail

# Backup Tumblepop SQLite databases + Active Storage files
# Runs via cron. Requires: rclone (with b2 remote configured), rsync
#
# Local backup: QNAP NAS via rsync over Tailscale
# Offsite backup: Backblaze B2 via rclone

CONTAINER=$(docker ps --filter name=tumblepop-web --format '{{.Names}}' | head -1)
BACKUP_DIR="$HOME/backups/tumblepop/$(date +%Y-%m-%d_%H%M)"
NAS_DEST="admin@nas:/share/backups/tumblepop"
B2_DEST="b2:tumblepop-backups"

if [ -z "$CONTAINER" ]; then
  echo "ERROR: No tumblepop container running"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

# Primary database (run sqlite3 .backup inside the container, copy out)
docker exec "$CONTAINER" sqlite3 /rails/storage/production.sqlite3 ".backup '/rails/storage/production.sqlite3.bak'"
docker cp "$CONTAINER:/rails/storage/production.sqlite3.bak" "$BACKUP_DIR/production.sqlite3"
docker exec "$CONTAINER" rm /rails/storage/production.sqlite3.bak

# Tenant databases
docker exec "$CONTAINER" find /rails/storage/tenants/production -name "main.sqlite3" 2>/dev/null | while read db; do
  rel=${db#/rails/storage/}
  mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
  docker exec "$CONTAINER" sqlite3 "$db" ".backup '${db}.bak'"
  docker cp "$CONTAINER:${db}.bak" "$BACKUP_DIR/$rel"
  docker exec "$CONTAINER" rm "${db}.bak"
done

# Active Storage files
docker cp "$CONTAINER:/rails/storage/files" "$BACKUP_DIR/files" 2>/dev/null || true

# Sync to NAS (local, fast restore)
rsync -az --delete "$HOME/backups/tumblepop/" "$NAS_DEST/" 2>/dev/null || echo "WARNING: NAS sync failed"

# Sync to Backblaze B2 (offsite, disaster recovery)
rclone sync "$HOME/backups/tumblepop/" "$B2_DEST/" 2>/dev/null || echo "WARNING: B2 sync failed"

# Prune local backups older than 7 days
find "$HOME/backups/tumblepop" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} +

# Prune NAS/B2 backups older than 6 months
rclone delete --min-age 6M "$B2_DEST/" 2>/dev/null || echo "WARNING: B2 prune failed"
ssh admin@nas "find /share/backups/tumblepop -maxdepth 1 -type d -mtime +180 -exec rm -rf {} +" 2>/dev/null || echo "WARNING: NAS prune failed"

echo "$(date): Tumblepop backup complete → $BACKUP_DIR"

#!/bin/bash
set -euo pipefail

# Bi-weekly account funding for Stardate (1st and 15th)
# Runs via systemd timer

CONTAINER=$(docker ps --filter name=stardate-web --format '{{.Names}}' | head -1)

if [ -z "$CONTAINER" ]; then
  echo "ERROR: No stardate container running"
  exit 1
fi

docker exec "$CONTAINER" bin/rails accounts:fund
echo "$(date): Stardate accounts:fund complete"

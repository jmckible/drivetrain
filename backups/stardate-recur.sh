#!/bin/bash
set -euo pipefail

# Daily recurring transactions for Stardate
# Runs via systemd timer

CONTAINER=$(docker ps --filter name=stardate-web --format '{{.Names}}' | head -1)

if [ -z "$CONTAINER" ]; then
  echo "ERROR: No stardate container running"
  exit 1
fi

docker exec "$CONTAINER" bin/rails recur
echo "$(date): Stardate recur complete"

#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.cloudflared"

mkdir -p "$TARGET"
cp "$DIR/config.yml" "$TARGET/config.yml"
echo "Deployed cloudflared config to $TARGET/config.yml"

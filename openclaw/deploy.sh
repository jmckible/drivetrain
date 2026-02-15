#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.openclaw"

mkdir -p "$TARGET"
cp "$DIR/openclaw.json" "$TARGET/openclaw.json"
echo "Deployed openclaw.json to $TARGET/openclaw.json"

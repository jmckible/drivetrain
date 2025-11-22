#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
REPO_THEME_DIR="$SCRIPT_DIR/../themes/one-dark-pro"
REPO_BACKGROUNDS="$REPO_THEME_DIR/backgrounds"
OMARCHY_THEMES_DIR="$HOME/.config/omarchy/themes"
THEME_DEST="$OMARCHY_THEMES_DIR/one-dark-pro"
BACKGROUNDS_DIR="$HOME/Wallpapers"

echo "Installing One Dark Pro theme for Omarchy..."

# Create themes directory if it doesn't exist
mkdir -p "$OMARCHY_THEMES_DIR"

# Remove existing theme if present
if [ -d "$THEME_DEST" ]; then
    echo "Removing existing One Dark Pro theme..."
    rm -rf "$THEME_DEST"
fi

# Copy theme from repo to omarchy themes directory
echo "Copying One Dark Pro theme from local repository..."
cp -r "$REPO_THEME_DIR" "$THEME_DEST"

# Always sync backgrounds to ensure they match the repo
echo "Syncing custom backgrounds..."
mkdir -p "$BACKGROUNDS_DIR"
cp "$REPO_BACKGROUNDS"/* "$BACKGROUNDS_DIR/"
echo "Custom backgrounds synced!"

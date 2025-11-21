#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
REPO_THEME_DIR="$SCRIPT_DIR/../themes/one-dark-pro"
OMARCHY_THEMES_DIR="$HOME/.config/omarchy/themes"
THEME_DEST="$OMARCHY_THEMES_DIR/one-dark-pro"

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

# Remove git directory if it was copied
if [ -d "$THEME_DEST/.git" ]; then
    rm -rf "$THEME_DEST/.git"
fi

echo "One Dark Pro theme installed successfully!"

# Set as current theme
omarchy-theme-set "one-dark-pro"
echo "One Dark Pro theme set as current!"

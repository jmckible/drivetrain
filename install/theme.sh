#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
REPO_THEME_DIR="$SCRIPT_DIR/../themes/one-dark-pro"
REPO_BACKGROUNDS="$REPO_THEME_DIR/backgrounds"
OMARCHY_THEMES_DIR="$HOME/.config/omarchy/themes"
THEME_DEST="$OMARCHY_THEMES_DIR/one-dark-pro"
BACKGROUNDS_DIR="$HOME/Wallpapers"

echo -e "${BLUE}▸${RESET} Installing One Dark Pro theme..."

# Create themes directory if it doesn't exist
mkdir -p "$OMARCHY_THEMES_DIR"

# Remove existing theme if present
if [ -d "$THEME_DEST" ]; then
    echo -e "${DIM}  Removing existing theme...${RESET}"
    rm -rf "$THEME_DEST"
fi

# Copy theme from repo to omarchy themes directory
echo -e "${DIM}  Copying theme files...${RESET}"
cp -r "$REPO_THEME_DIR" "$THEME_DEST"

# Always sync backgrounds to ensure they match the repo
echo -e "${BLUE}▸${RESET} Syncing wallpapers..."
mkdir -p "$BACKGROUNDS_DIR"
cp "$REPO_BACKGROUNDS"/* "$BACKGROUNDS_DIR/"
echo -e "${GREEN}✓${RESET} Theme and wallpapers installed"

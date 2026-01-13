#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
REPO_THEME_DIR="$SCRIPT_DIR/../themes/drivetrain"
REPO_BACKGROUNDS="$REPO_THEME_DIR/backgrounds"
OMARCHY_THEMES_DIR="$HOME/.config/omarchy/themes"
THEME_DEST="$OMARCHY_THEMES_DIR/drivetrain"
# Omarchy 3.3.0+ uses ~/.config/omarchy/backgrounds for user backgrounds
OMARCHY_BACKGROUNDS_DIR="$HOME/.config/omarchy/backgrounds"
# Legacy location (still used by some Omarchy versions)
LEGACY_BACKGROUNDS_DIR="$HOME/Wallpapers"

echo -e "${BLUE}▸${RESET} Installing Drivetrain theme..."

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

# Always sync backgrounds to both locations for compatibility
echo -e "${BLUE}▸${RESET} Syncing wallpapers..."
mkdir -p "$OMARCHY_BACKGROUNDS_DIR"
mkdir -p "$LEGACY_BACKGROUNDS_DIR"
cp -r "$REPO_BACKGROUNDS"/* "$OMARCHY_BACKGROUNDS_DIR/"
cp -r "$REPO_BACKGROUNDS"/* "$LEGACY_BACKGROUNDS_DIR/"
echo -e "${GREEN}✓${RESET} Theme and wallpapers installed"

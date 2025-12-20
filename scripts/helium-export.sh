#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'

HELIUM_PROFILE=~/.config/net.imput.helium
BOOKMARKS_FILE="$HELIUM_PROFILE/Default/Bookmarks"
DROPBOX_BOOKMARKS=~/Dropbox/helium-bookmarks.json

echo -e "${BLUE}Helium Bookmark Export${RESET}"
echo ""

# Check if Helium profile exists
if [ ! -d "$HELIUM_PROFILE" ]; then
    echo -e "${RED}✗${RESET} Helium profile not found at $HELIUM_PROFILE"
    echo -e "${YELLOW}⚠${RESET} Have you run Helium at least once?"
    exit 1
fi

# Check if bookmarks file exists
if [ ! -f "$BOOKMARKS_FILE" ]; then
    echo -e "${RED}✗${RESET} Bookmarks file not found at $BOOKMARKS_FILE"
    echo -e "${YELLOW}⚠${RESET} No bookmarks to export"
    exit 1
fi

# Check if Helium is currently running
if pgrep -x "helium-browser" > /dev/null; then
    echo -e "${YELLOW}⚠${RESET} Helium is currently running"
    echo -e "${BLUE}ℹ${RESET} For best results, close Helium before exporting"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}▸${RESET} Export cancelled"
        exit 0
    fi
fi

# Create Dropbox directory if it doesn't exist
mkdir -p "$(dirname "$DROPBOX_BOOKMARKS")"

# Copy bookmarks to Dropbox
echo -e "${BLUE}▸${RESET} Exporting bookmarks to Dropbox..."
cp "$BOOKMARKS_FILE" "$DROPBOX_BOOKMARKS"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${RESET} Bookmarks exported to $DROPBOX_BOOKMARKS"

    # Show bookmark count
    BOOKMARK_COUNT=$(grep -o '"type": "url"' "$DROPBOX_BOOKMARKS" | wc -l)
    echo -e "${BLUE}ℹ${RESET} Exported $BOOKMARK_COUNT bookmarks"
else
    echo -e "${RED}✗${RESET} Failed to export bookmarks"
    exit 1
fi

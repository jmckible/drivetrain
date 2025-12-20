#!/bin/bash

# Check if helium-browser is already installed
if ! pacman -Q helium-browser-bin &>/dev/null; then
    echo -e "${BLUE}▸${RESET} Installing Helium browser from AUR..."
    yay -S --noconfirm --needed helium-browser-bin
    echo -e "${GREEN}✓${RESET} Helium browser installed"
else
    echo -e "${GREEN}✓${RESET} Helium browser already installed"
fi

# Update Omarchy default browser setting
UWSM_DEFAULT=~/.config/uwsm/default
if [ -f "$UWSM_DEFAULT" ]; then
    echo -e "${BLUE}▸${RESET} Setting Helium as default browser in Omarchy..."

    # Replace BROWSER variable in uwsm/default
    if grep -q "^export BROWSER=" "$UWSM_DEFAULT"; then
        sed -i 's/^export BROWSER=.*/export BROWSER=helium-browser/' "$UWSM_DEFAULT"
        echo -e "${GREEN}✓${RESET} Updated BROWSER=helium-browser in $UWSM_DEFAULT"
    else
        echo "export BROWSER=helium-browser" >> "$UWSM_DEFAULT"
        echo -e "${GREEN}✓${RESET} Added BROWSER=helium-browser to $UWSM_DEFAULT"
    fi
else
    echo -e "${YELLOW}⚠${RESET} Could not find $UWSM_DEFAULT"
fi

# Import bookmarks from Dropbox if available
HELIUM_CONFIG=~/.config/net.imput.helium
DROPBOX_BOOKMARKS=~/Dropbox/helium-bookmarks.json
HELIUM_BOOKMARKS="$HELIUM_CONFIG/Default/Bookmarks"

# If there's a Dropbox symlink from old setup, remove it
if [ -L "$HELIUM_CONFIG" ]; then
    echo -e "${BLUE}▸${RESET} Removing old Dropbox symlink..."
    DROPBOX_PROFILE=$(readlink "$HELIUM_CONFIG")
    rm "$HELIUM_CONFIG"

    # If the Dropbox profile exists, copy it to local
    if [ -d "$DROPBOX_PROFILE" ]; then
        echo -e "${BLUE}▸${RESET} Migrating Dropbox profile to local..."
        cp -r "$DROPBOX_PROFILE" "$HELIUM_CONFIG"
        echo -e "${GREEN}✓${RESET} Profile migrated to local storage"
    fi
fi

# Import bookmarks from Dropbox if they exist
if [ -f "$DROPBOX_BOOKMARKS" ]; then
    # Create profile directory if it doesn't exist
    mkdir -p "$HELIUM_CONFIG/Default"

    # Import bookmarks
    echo -e "${BLUE}▸${RESET} Importing bookmarks from Dropbox..."
    cp "$DROPBOX_BOOKMARKS" "$HELIUM_BOOKMARKS"

    BOOKMARK_COUNT=$(grep -o '"type": "url"' "$HELIUM_BOOKMARKS" 2>/dev/null | wc -l)
    echo -e "${GREEN}✓${RESET} Imported $BOOKMARK_COUNT bookmarks from Dropbox"
else
    echo -e "${BLUE}ℹ${RESET} No bookmarks found in Dropbox (run scripts/helium-export.sh to create them)"
fi

echo -e "${BLUE}ℹ${RESET} Each machine uses a local profile (run scripts/helium-export.sh to sync bookmarks)"
echo -e "${BLUE}ℹ${RESET} Note: Restart Hyprland for the default browser change to take effect"

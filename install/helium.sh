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

echo -e "${BLUE}ℹ${RESET} Note: Restart Hyprland for the default browser change to take effect"

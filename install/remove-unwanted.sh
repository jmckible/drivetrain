#!/bin/bash

# Remove unwanted packages that come with Omarchy by default

UNWANTED_PACKAGES=(
    "signal-desktop"
    "obs-studio"
)

for pkg in "${UNWANTED_PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &> /dev/null; then
        echo -e "${YELLOW}▸${RESET} Removing ${pkg}..."
        sudo pacman -Rns --noconfirm "$pkg" 2>/dev/null || echo -e "${RED}✗${RESET} Could not remove ${pkg} (may have dependencies)"
    else
        echo -e "${DIM}○ ${pkg} not installed${RESET}"
    fi
done

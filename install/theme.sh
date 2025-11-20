#!/bin/bash

# Check if One Dark Pro theme is already installed
if omarchy-theme-list | grep -q "One Dark Pro"; then
    echo "One Dark Pro theme already installed, skipping"
else
    echo "Installing One Dark Pro theme for Omarchy..."
    # Install the theme from GitHub
    # omarchy-theme-install will clone the repo and automatically set it as current
    omarchy-theme-install https://github.com/sc0ttman/omarchy-one-dark-pro-theme
    echo "One Dark Pro theme installed and set as current!"
fi

# Copy custom backgrounds (after theme installation to override theme defaults)
BACKGROUNDS_DIR="$HOME/.config/omarchy/current/theme/backgrounds"
REPO_BACKGROUNDS="$(dirname "$0")/../backgrounds"

if [ -d "$BACKGROUNDS_DIR" ] && [ -z "$(ls -A "$BACKGROUNDS_DIR" 2>/dev/null | grep -E '\.(jpg|png)$')" ]; then
    echo "Copying custom backgrounds..."
    cp "$REPO_BACKGROUNDS"/* "$BACKGROUNDS_DIR/"
    echo "Custom backgrounds copied!"
elif [ ! -d "$BACKGROUNDS_DIR" ]; then
    echo "Backgrounds directory doesn't exist, creating and copying..."
    mkdir -p "$BACKGROUNDS_DIR"
    cp "$REPO_BACKGROUNDS"/* "$BACKGROUNDS_DIR/"
    echo "Custom backgrounds copied!"
else
    echo "Custom backgrounds already present, skipping"
fi

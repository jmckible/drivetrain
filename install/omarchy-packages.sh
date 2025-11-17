#!/bin/bash

# Install Ruby dev environment if not already installed
if ! command -v ruby &> /dev/null; then
    echo "Installing Ruby dev environment..."
    omarchy-install-dev-env ruby
else
    echo "Ruby already installed, skipping"
fi

# Install Node dev environment if not already installed
if ! command -v node &> /dev/null; then
    echo "Installing Node dev environment..."
    omarchy-install-dev-env node
else
    echo "Node already installed, skipping"
fi

# Install Dropbox if not already installed
if ! command -v dropbox &> /dev/null && ! pacman -Qi dropbox &> /dev/null; then
    echo "Installing Dropbox..."
    omarchy-install-dropbox
else
    echo "Dropbox already installed, skipping"
fi

# Install Steam if not already installed (skip on laptop - no gaming on MacBook)
MACHINE_TYPE=""
if [[ -f /tmp/drivetrain-machine-type ]]; then
    MACHINE_TYPE=$(cat /tmp/drivetrain-machine-type)
fi

if [[ "$MACHINE_TYPE" == "2" ]]; then
    echo "Laptop detected - skipping Steam installation"
elif ! pacman -Qi steam &> /dev/null; then
    echo "Installing Steam..."
    omarchy-install-steam
else
    echo "Steam already installed, skipping"
fi

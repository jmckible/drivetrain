#!/bin/bash

# Check if transmission-qt is already installed
if ! pacman -Q transmission-qt &>/dev/null; then
    # Install transmission-qt from official repos
    sudo pacman -S --noconfirm --needed transmission-qt
fi

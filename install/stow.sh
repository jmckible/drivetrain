#!/bin/bash

# Install stow
yay -S --noconfirm --needed stow

STOW_DIR="$(pwd)/stow"

rm -rf ~/.config/nvim
rm -rf ~/.config/hypr
stow -d "$STOW_DIR" -t ~ nvim
stow -d "$STOW_DIR" -t ~ hypr

#!/bin/bash

# Install stow
yay -S --noconfirm --needed stow

ORIGINAL_DIR=$(pwd)
STOW_DIR="$ORIGINAL_DIR/stow"

rm -rf ~/.config/nvim
cd $STOW_DIR
stow -t ~ nvim
cd "$ORIGINAL_DIR"

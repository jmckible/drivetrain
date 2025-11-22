#!/bin/bash

# macOS installation script for drivetrain dotfiles
# Usage: ./install-macos.sh

set -e

echo "Installing drivetrain dotfiles for macOS..."

# Install required tools via homebrew
echo "Installing required tools..."
REQUIRED_TOOLS="stow fd ripgrep"
for tool in $REQUIRED_TOOLS; do
    if ! command -v "$tool" &> /dev/null; then
        echo "Installing $tool..."
        brew install "$tool"
    else
        echo "$tool already installed"
    fi
done

STOW_DIR="$(pwd)/stow"

# Backup existing nvim config if it exists
if [[ -e ~/.config/nvim ]]; then
    BACKUP_DIR=~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
    echo "Backing up existing nvim config to $BACKUP_DIR"
    mv ~/.config/nvim "$BACKUP_DIR"
fi

# Copy nvim config instead of stowing (so we can make macOS-specific changes)
echo "Copying nvim config from drivetrain..."
# Use rsync to handle broken symlinks gracefully
rsync -av --exclude='lua/plugins/theme.lua' "$STOW_DIR/nvim/.config/nvim/" ~/.config/nvim/

# macOS-specific fixes (won't affect Linux config)
echo "Applying macOS-specific fixes..."

# Replace broken theme.lua symlink with a working theme file
rm -f ~/.config/nvim/lua/plugins/theme.lua
cat > ~/.config/nvim/lua/plugins/theme.lua << 'EOF'
-- macOS theme override (Linux uses Omarchy symlink)
return {
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
EOF

# Remove deprecated neo-tree extra from lazyvim.json
cat > ~/.config/nvim/lazyvim.json << 'EOF'
{
  "extras": [],
  "install_version": 8,
  "news": {
    "NEWS.md": "11866"
  },
  "version": 8
}
EOF

echo ""
echo "macOS setup complete!"
echo "Neovim config copied from drivetrain (with macOS-specific fixes)."
echo "Note: This is a copy, not a symlink - your Linux config is untouched."
echo ""

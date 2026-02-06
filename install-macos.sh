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

# Install yabai and skhd for tiling window management
echo "Installing yabai and skhd..."
if ! command -v yabai &> /dev/null; then
    echo "Installing yabai..."
    brew install koekeishiya/formulae/yabai
else
    echo "yabai already installed"
fi

if ! command -v skhd &> /dev/null; then
    echo "Installing skhd..."
    brew install koekeishiya/formulae/skhd
else
    echo "skhd already installed"
fi

# Install Ghostty terminal
if ! test -d /Applications/Ghostty.app; then
    echo "Installing Ghostty..."
    brew install --cask ghostty
else
    echo "Ghostty already installed"
fi

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

# Set up yabai configuration
echo "Setting up yabai configuration..."
if [[ -e ~/.config/yabai ]]; then
    BACKUP_DIR=~/.config/yabai.backup.$(date +%Y%m%d_%H%M%S)
    echo "Backing up existing yabai config to $BACKUP_DIR"
    mv ~/.config/yabai "$BACKUP_DIR"
fi
stow -d "$STOW_DIR" -t ~ yabai

# Set up skhd configuration
echo "Setting up skhd configuration..."
if [[ -e ~/.config/skhd ]]; then
    BACKUP_DIR=~/.config/skhd.backup.$(date +%Y%m%d_%H%M%S)
    echo "Backing up existing skhd config to $BACKUP_DIR"
    mv ~/.config/skhd "$BACKUP_DIR"
fi
stow -d "$STOW_DIR" -t ~ skhd

# Set up macOS-specific Ghostty configuration
echo "Setting up Ghostty configuration for macOS..."
if [[ -e ~/.config/ghostty/config ]]; then
    BACKUP_FILE=~/.config/ghostty/config.backup.$(date +%Y%m%d_%H%M%S)
    echo "Backing up existing ghostty config to $BACKUP_FILE"
    mv ~/.config/ghostty/config "$BACKUP_FILE"
fi
mkdir -p ~/.config/ghostty
cp "$STOW_DIR/ghostty/.config/ghostty/config.macos" ~/.config/ghostty/config

# Set up yabai sudoers file for scripting addition
echo "Setting up yabai sudoers file..."
if [[ -f /private/etc/sudoers.d/yabai ]]; then
    sudo rm /private/etc/sudoers.d/yabai
fi
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai

# Load yabai scripting addition (must be done before Dock restart)
echo "Loading yabai scripting addition..."
sudo yabai --load-sa

# Configure macOS animations for instant workspace switching
echo "Configuring system animations..."
defaults write com.apple.dock workspaces-swoosh-animation-off -bool YES
defaults write com.apple.dock expose-animation-duration -float 0.04
killall Dock

# Wait for Dock to restart
echo "Waiting for Dock to restart..."
sleep 3

# Re-load scripting addition after Dock restart
echo "Re-loading yabai scripting addition..."
sudo yabai --load-sa

# Start services
echo "Starting yabai and skhd services..."
yabai --start-service
skhd --start-service

echo ""
echo "macOS setup complete!"
echo ""
echo "Installed and configured:"
echo "  - Neovim (with macOS-specific fixes)"
echo "  - yabai (tiling window manager)"
echo "  - skhd (hotkey daemon)"
echo "  - Ghostty terminal"
echo ""
echo "Next steps:"
echo "  1. See docs/macos-setup.md for complete setup instructions"
echo "  2. Disable SIP partially (requires Recovery Mode - see README)"
echo "  3. Set boot argument if Apple Silicon (see README)"
echo "  4. Disable conflicting system shortcuts in System Settings"
echo "  5. Create multiple desktops/spaces in Mission Control"
echo "  6. Optional: Enable 'Reduce motion' in Accessibility settings"
echo ""
echo "Key bindings quick reference:"
echo "  - Option+h/j/k/l: Focus window (left/down/up/right)"
echo "  - Option+1-9: Switch to space 1-9"
echo "  - Option+Return: Open Ghostty terminal"
echo ""

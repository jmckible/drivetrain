#!/bin/bash

# Install stow from official repos
sudo pacman -S --noconfirm --needed stow

STOW_DIR="$(pwd)/stow"

rm -rf ~/.config/nvim
rm -rf ~/.config/waybar
rm -rf ~/.config/hypr
rm -rf ~/.config/alacritty
rm -rf ~/.local/bin
stow -d "$STOW_DIR" -t ~ nvim
stow -d "$STOW_DIR" -t ~ waybar
stow -d "$STOW_DIR" -t ~ bin

# Restart waybar to pick up new config
if command -v omarchy-restart-waybar &> /dev/null; then
    omarchy-restart-waybar
fi

# Create ~/.config/hypr directory as a real directory (not a symlink)
mkdir -p ~/.config/hypr

# Detect machine type (will be set later in the script)
# For now, just ensure the placeholder is ready
MACHINE_TYPE=""

# Restore Omarchy-managed bindings.conf if it doesn't exist
if [[ ! -f ~/.config/hypr/bindings.conf ]]; then
    if [[ -f ~/.local/share/omarchy/config/hypr/bindings.conf ]]; then
        cp ~/.local/share/omarchy/config/hypr/bindings.conf ~/.config/hypr/bindings.conf
    fi
fi

# Now stow shared hypr configs (these will be symlinked into the existing directory)
stow -d "$STOW_DIR" -t ~ hypr

# Accept optional command-line parameter (desktop or laptop)
MACHINE_TYPE_ARG="$1"

# Detect machine type based on hardware
DETECTED_TYPE=""
DETECTED_MSG=""

# Check if it's a laptop (battery present)
if [[ -d /sys/class/power_supply/BAT0 ]] || [[ -d /sys/class/power_supply/BAT1 ]]; then
    DETECTED_TYPE="laptop"
    DETECTED_MSG="(battery present)"
# Check for NVIDIA GPU (likely desktop)
elif lspci 2>/dev/null | grep -qi nvidia; then
    DETECTED_TYPE="desktop"
    DETECTED_MSG="(NVIDIA GPU found)"
# Check chassis type via hostnamectl
elif hostnamectl 2>/dev/null | grep -qi "Chassis:.*laptop\|Chassis:.*notebook\|Chassis:.*portable"; then
    DETECTED_TYPE="laptop"
    DETECTED_MSG="(chassis type)"
else
    DETECTED_TYPE="desktop"
    DETECTED_MSG="(default)"
fi

# Determine final machine type
if [[ "$MACHINE_TYPE_ARG" == "desktop" ]]; then
    MACHINE_TYPE="desktop"
    echo "Using machine type: desktop (from command-line argument)"
elif [[ "$MACHINE_TYPE_ARG" == "laptop" ]]; then
    MACHINE_TYPE="laptop"
    echo "Using machine type: laptop (from command-line argument)"
else
    MACHINE_TYPE="$DETECTED_TYPE"
    echo "Using machine type: $MACHINE_TYPE (auto-detected $DETECTED_MSG)"
fi

# Save machine type for other scripts to use
echo "$MACHINE_TYPE" > /tmp/drivetrain-machine-type

# Copy hardware-specific templates
if [[ $MACHINE_TYPE == "desktop" || $MACHINE_TYPE == "laptop" ]]; then
    echo "Configuring for $MACHINE_TYPE..."

    TEMPLATE_DIR="$(pwd)/templates/$MACHINE_TYPE"

    # Copy hypr configs
    cp "$TEMPLATE_DIR/hypr/monitors.conf" ~/.config/hypr/monitors.conf
    cp "$TEMPLATE_DIR/hypr/input.conf" ~/.config/hypr/input.conf
    cp "$TEMPLATE_DIR/hypr/looknfeel.conf" ~/.config/hypr/looknfeel.conf
    cp "$TEMPLATE_DIR/hypr/envs.conf" ~/.config/hypr/envs.conf

    # Copy alacritty config
    mkdir -p ~/.config/alacritty
    cp "$TEMPLATE_DIR/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
else
    echo "Invalid machine type. Please manually edit configs in ~/.config/hypr/"
fi

hyprctl reload

echo ""
echo "Hyprland configuration complete!"
echo ""

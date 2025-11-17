#!/bin/bash

# Install stow from official repos
sudo pacman -S --noconfirm --needed stow

STOW_DIR="$(pwd)/stow"

rm -rf ~/.config/nvim
stow -d "$STOW_DIR" -t ~ nvim

# Stow shared hypr configs (these are symlinked)
stow -d "$STOW_DIR" -t ~ hypr

# Detect machine type based on hardware
DETECTED_TYPE=""
DETECTED_MSG=""

# Check if it's a laptop (battery present)
if [[ -d /sys/class/power_supply/BAT0 ]] || [[ -d /sys/class/power_supply/BAT1 ]]; then
    DETECTED_TYPE="2"
    DETECTED_MSG="(laptop detected - battery present)"
# Check for NVIDIA GPU (likely desktop)
elif lspci 2>/dev/null | grep -qi nvidia; then
    DETECTED_TYPE="1"
    DETECTED_MSG="(desktop detected - NVIDIA GPU found)"
# Check chassis type via hostnamectl
elif hostnamectl 2>/dev/null | grep -qi "Chassis:.*laptop\|Chassis:.*notebook\|Chassis:.*portable"; then
    DETECTED_TYPE="2"
    DETECTED_MSG="(laptop detected)"
else
    DETECTED_TYPE="1"
    DETECTED_MSG="(defaulting to desktop)"
fi

# Ask for machine type with detected default
echo ""
echo "Select machine type:"
echo "1) Desktop (Dell 4K monitor, NVIDIA GPU)"
echo "2) Laptop (2012 MacBook Pro 15\")"
echo ""
echo "Auto-detected: Option $DETECTED_TYPE $DETECTED_MSG"
read -p "Enter 1 or 2 (or press Enter for detected default): " -n 1 -r MACHINE_TYPE
echo ""

# Use detected type if user just pressed Enter
if [[ -z "$MACHINE_TYPE" ]]; then
    MACHINE_TYPE="$DETECTED_TYPE"
    echo "Using auto-detected option: $MACHINE_TYPE"
fi

# Save machine type for other scripts to use
echo "$MACHINE_TYPE" > /tmp/drivetrain-machine-type

# Copy machine-specific templates
TEMPLATE_DIR="$(pwd)/templates/hypr"
cp "$TEMPLATE_DIR/monitors.conf" ~/.config/hypr/monitors.conf
cp "$TEMPLATE_DIR/input.conf" ~/.config/hypr/input.conf
cp "$TEMPLATE_DIR/looknfeel.conf" ~/.config/hypr/looknfeel.conf
cp "$TEMPLATE_DIR/envs.conf" ~/.config/hypr/envs.conf

# Uncomment appropriate settings based on machine type
if [[ $MACHINE_TYPE == "1" ]]; then
    echo "Configuring for Desktop..."

    # Uncomment Desktop monitor settings
    sed -i '/# DESKTOP - Dell/,/^$/ s/^# \(env =\|monitor =\)/\1/' ~/.config/hypr/monitors.conf

    # Uncomment Desktop sensitivity and scroll
    sed -i '/# DESKTOP - Lower sensitivity/,/^$/ s/^  # \(sensitivity =\|natural_scroll =\)/  \1/' ~/.config/hypr/input.conf

    # Uncomment Desktop aspect ratio
    sed -i '/# DESKTOP - Large screen/,/^$/ s/^    # \(single_window_aspect_ratio =\)/    \1/' ~/.config/hypr/looknfeel.conf

    # Uncomment Desktop NVIDIA settings
    sed -i '/# DESKTOP - NVIDIA/,/^$/ s/^# \(env =.*NVIDIA\)/\1/' ~/.config/hypr/envs.conf

elif [[ $MACHINE_TYPE == "2" ]]; then
    echo "Configuring for Laptop..."

    # Uncomment Laptop monitor settings
    sed -i '/# LAPTOP - 2012 MacBook/,/^$/ s/^# \(env =\|monitor =\)/\1/' ~/.config/hypr/monitors.conf

    # Uncomment Laptop sensitivity and scroll
    sed -i '/# LAPTOP - Traditional scroll/,/^$/ s/^  # \(sensitivity =\|natural_scroll =\)/  \1/' ~/.config/hypr/input.conf

    # looknfeel.conf - no changes needed for laptop (default behavior)
    # envs.conf - no changes needed for laptop (no GPU-specific settings)

else
    echo "Invalid selection. Please manually edit configs in ~/.config/hypr/"
fi

hyprctl reload

echo ""
echo "Hyprland configuration complete!"
echo ""

#!/bin/bash

# Install stow
yay -S --noconfirm --needed stow

STOW_DIR="$(pwd)/stow"

rm -rf ~/.config/nvim
stow -d "$STOW_DIR" -t ~ nvim

# Stow shared hypr configs (these are symlinked)
stow -d "$STOW_DIR" -t ~ hypr

# Ask for machine type
echo ""
echo "Select machine type:"
echo "1) Desktop (Dell 4K monitor, NVIDIA GPU)"
echo "2) Laptop (2012 MacBook Pro 15\")"
read -p "Enter 1 or 2: " -n 1 -r MACHINE_TYPE
echo ""

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

    # Uncomment Desktop sensitivity
    sed -i '/# DESKTOP - Lower sensitivity/,/^$/ s/^# \(sensitivity =\)/\1/' ~/.config/hypr/input.conf

    # Uncomment Desktop aspect ratio
    sed -i '/# DESKTOP - Large screen/,/^$/ s/^    # \(single_window_aspect_ratio =\)/    \1/' ~/.config/hypr/looknfeel.conf

    # Uncomment Desktop NVIDIA settings
    sed -i '/# DESKTOP - NVIDIA/,/^$/ s/^# \(env =.*NVIDIA\)/\1/' ~/.config/hypr/envs.conf

elif [[ $MACHINE_TYPE == "2" ]]; then
    echo "Configuring for Laptop..."

    # Uncomment Laptop monitor settings
    sed -i '/# LAPTOP - 2012 MacBook/,/^$/ s/^# \(env =\|monitor =\)/\1/' ~/.config/hypr/monitors.conf

    # Uncomment Laptop sensitivity
    sed -i '/# LAPTOP - Higher sensitivity/,/^$/ s/^# \(sensitivity =\)/\1/' ~/.config/hypr/input.conf

    # looknfeel.conf - no changes needed for laptop (default behavior)
    # envs.conf - no changes needed for laptop (no GPU-specific settings)

else
    echo "Invalid selection. Please manually edit configs in ~/.config/hypr/"
fi

hyprctl reload

echo ""
echo "Hyprland configuration complete!"
echo ""

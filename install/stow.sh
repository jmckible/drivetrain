#!/bin/bash

# Install stow from official repos if not already installed
if ! pacman -Qi stow &> /dev/null; then
    sudo pacman -S --noconfirm --needed stow
fi

STOW_DIR="$(pwd)/stow"

rm -rf ~/.config/nvim
rm -rf ~/.config/waybar
rm -rf ~/.config/hypr
rm -rf ~/.config/alacritty
rm -rf ~/.config/ghostty
rm -rf ~/.local/bin
rm -rf ~/.config/git
rm -f ~/.bashrc ~/.bash_profile ~/.bash_logout
stow -d "$STOW_DIR" -t ~ nvim
stow -d "$STOW_DIR" -t ~ waybar
stow -d "$STOW_DIR" -t ~ ghostty
stow -d "$STOW_DIR" -t ~ bin
stow -d "$STOW_DIR" -t ~ git
stow -d "$STOW_DIR" -t ~ bash

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
    echo -e "${BLUE}▸${RESET} Using machine type: ${BOLD}desktop${RESET} ${DIM}(from argument)${RESET}"
elif [[ "$MACHINE_TYPE_ARG" == "laptop" ]]; then
    MACHINE_TYPE="laptop"
    echo -e "${BLUE}▸${RESET} Using machine type: ${BOLD}laptop${RESET} ${DIM}(from argument)${RESET}"
else
    MACHINE_TYPE="$DETECTED_TYPE"
    echo -e "${BLUE}▸${RESET} Using machine type: ${BOLD}$MACHINE_TYPE${RESET} ${DIM}(auto-detected $DETECTED_MSG)${RESET}"
fi

# Save machine type for other scripts to use
echo "$MACHINE_TYPE" > /tmp/drivetrain-machine-type

# Copy hardware-specific templates
if [[ $MACHINE_TYPE == "desktop" || $MACHINE_TYPE == "laptop" ]]; then
    echo -e "${DIM}  Applying hardware-specific configs...${RESET}"

    TEMPLATE_DIR="$(pwd)/templates/$MACHINE_TYPE"

    # Copy hypr configs
    cp "$TEMPLATE_DIR/hypr/monitors.conf" ~/.config/hypr/monitors.conf
    cp "$TEMPLATE_DIR/hypr/input.conf" ~/.config/hypr/input.conf
    cp "$TEMPLATE_DIR/hypr/looknfeel.conf" ~/.config/hypr/looknfeel.conf
    cp "$TEMPLATE_DIR/hypr/envs.conf" ~/.config/hypr/envs.conf

    # Copy alacritty config
    mkdir -p ~/.config/alacritty
    cp "$TEMPLATE_DIR/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml

    # Copy ghostty hardware-specific config
    mkdir -p ~/.config/ghostty
    cp "$TEMPLATE_DIR/ghostty/config" ~/.config/ghostty/hardware.conf

    # Copy helium-browser flags if present
    if [[ -f "$TEMPLATE_DIR/helium/helium-browser-flags.conf" ]]; then
        cp "$TEMPLATE_DIR/helium/helium-browser-flags.conf" ~/.config/helium-browser-flags.conf
    fi
else
    echo "Invalid machine type. Please manually edit configs in ~/.config/hypr/"
fi

hyprctl reload

# Restart walker services (hyprctl reload breaks their connection)
pkill elephant
pkill -f "walker --gapplication-service"
sleep 1
uwsm-app -- elephant &>/dev/null &
uwsm-app -- walker --gapplication-service &>/dev/null &

echo -e "${GREEN}✓${RESET} Configuration deployed successfully"

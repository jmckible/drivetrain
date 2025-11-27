# macOS Tiling Window Manager Setup Guide

This guide documents how to set up a Hyprland-like tiling window manager experience on macOS using yabai and skhd.

## Overview

This setup provides:
- Automatic tiling window management
- Keyboard-driven workspace/space switching
- Vim-style window navigation
- Minimal animations for instant workspace transitions
- Integration with Ghostty terminal

## Prerequisites

- macOS (Apple Silicon or Intel)
- Homebrew installed
- Basic familiarity with terminal usage

## Quick Start

For automated installation of config files and tools:

```bash
./install-macos.sh
```

This script will:
- Install yabai, skhd, and ghostty via Homebrew
- Set up configuration files for yabai, skhd, and ghostty
- Configure system animations for instant workspace switching
- Set up the yabai sudoers file
- Start yabai and skhd services

**Important:** The automated script handles most setup, but you still need to manually:
1. Disable SIP partially (see Part 2 below)
2. Set boot argument on Apple Silicon (see Part 2 below)
3. Disable conflicting system shortcuts (see Part 6 below)
4. Set up multiple desktops/spaces (see Part 7 below)

## Part 1: Install Core Tools

The install script handles this automatically, but for manual installation:

### Install yabai and skhd

```bash
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
```

### Install Ghostty (Optional but Recommended)

Download from ghostty.org or:
```bash
brew install --cask ghostty
```

## Part 2: Disable System Integrity Protection (Partial)

**This step must be done manually** and is required for yabai to have full control over window management and space switching.

### Boot into Recovery Mode

**Apple Silicon:**
1. Shut down your Mac completely
2. Hold the power button until "Loading startup options..." appears
3. Click **Options**, then **Continue**
4. Select your user account and enter password if prompted

**Intel Mac:**
1. Restart your Mac
2. Immediately hold **Cmd+R**
3. Keep holding until Recovery Mode loads

### Disable SIP Partially

1. Once in Recovery Mode, open **Utilities** → **Terminal** from the menu bar
2. Run this command:

```bash
csrutil enable --without fs --without debug --without nvram
```

3. You should see: "Successfully enabled System Integrity Protection."
4. Restart your Mac from the Apple menu

### Verify SIP Status

After rebooting to normal macOS:

```bash
csrutil status
```

Should show:
```
System Integrity Protection status: enabled (Custom Configuration).

Configuration:
    Filesystem Protections: disabled
    Debugging Restrictions: disabled
    NVRAM Protections: disabled
```

### Set Required Boot Argument (Apple Silicon Only)

```bash
sudo nvram boot-args=-arm64e_preview_abi
```

Then **reboot your Mac** for this to take effect.

Verify after reboot:
```bash
nvram boot-args
```

## Part 3: Configure yabai

The install script creates `~/.config/yabai/yabairc` automatically. See the configuration in `stow/yabai/.config/yabai/yabairc`.

Key features:
- BSP (binary space partitioning) layout
- 8px padding and gaps
- Floating rules for System Settings, Calculator, Finder
- Auto-balance on window close

## Part 4: Configure skhd (Keybindings)

The install script creates `~/.config/skhd/skhdrc` automatically. See the configuration in `stow/skhd/.config/skhd/skhdrc`.

## Part 5: Minimize Animations

The install script handles this automatically by running:

```bash
defaults write com.apple.dock workspaces-swoosh-animation-off -bool YES
defaults write com.apple.dock expose-animation-duration -float 0.04
killall Dock
```

### Enable Reduce Motion (Optional but Recommended)

**This must be done manually:**
1. Open **System Settings**
2. Go to **Accessibility** → **Display**
3. Enable **Reduce motion**

This removes most system-wide animations for a more immediate feel.

## Part 6: Disable Conflicting System Shortcuts

**This must be done manually:**
1. Open **System Settings**
2. Go to **Keyboard** → **Keyboard Shortcuts** → **Mission Control**
3. **Disable** any shortcuts like "Switch to Desktop 1/2/3" that use Ctrl+numbers
   - These conflict with yabai's space switching

## Part 7: Set Up Multiple Desktops/Spaces

**This must be done manually:**
1. Open **Mission Control** (three-finger swipe up or F3)
2. Hover at the top of the screen
3. Click the **+** button to add new desktops
4. Add 5-10 spaces total for comfortable workflow

## Part 8: Configure Ghostty (Optional)

The install script creates `~/.config/ghostty/config` automatically. See the configuration in `stow/ghostty/.config/ghostty/config`.

## Usage Guide

### Key Bindings Reference

**Note:** `alt` = Option key (⌥) on macOS

**Window Navigation:**
- `Option+h/j/k/l` - Focus window (left/down/up/right)
- `Shift+Option+h/j/k/l` - Move window
- `Ctrl+Option+h/j/k/l` - Resize window

**Workspace/Space Management:**
- `Option+1-9` - Switch to space 1-9
- `Shift+Option+1-9` - Move current window to space 1-9

**Window Management:**
- `Shift+Option+Space` - Toggle float mode
- `Option+e` - Balance all windows in current space
- `Option+r` - Rotate window tree 90 degrees
- `Option+f` - Toggle fullscreen

**Terminal:**
- `Option+Return` - Open new Ghostty terminal

### Basic Workflow

1. **Open applications** - they automatically tile
2. **Navigate between windows** - `Option+h/j/k/l`
3. **Arrange windows** - `Shift+Option+h/j/k/l` to move
4. **Switch workspaces** - `Option+2` to go to space 2
5. **Move window to another workspace** - `Shift+Option+3` sends window to space 3
6. **Balance layout** - `Option+e` if things look uneven

## Maintenance

### After Homebrew Updates yabai

When yabai updates, the hash changes and you need to regenerate the sudoers file:

```bash
sudo rm /private/etc/sudoers.d/yabai
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
sudo yabai --load-sa
yabai --restart-service
```

### Restart Services

```bash
yabai --restart-service
skhd --restart-service
```

### Check Service Status

```bash
pgrep -fl yabai
pgrep -fl skhd
```

### View yabai Information

```bash
# List all windows
yabai -m query --windows

# List all spaces
yabai -m query --spaces

# Get yabai version
yabai --version
```

## Troubleshooting

### Space switching doesn't work

1. Verify SIP is partially disabled: `csrutil status`
2. Check boot arg is set (Apple Silicon): `nvram boot-args`
3. Verify scripting addition loaded: `sudo yabai --load-sa`
4. Check sudoers file exists: `cat /private/etc/sudoers.d/yabai`
5. Restart yabai: `yabai --restart-service`

### Keybindings not working

1. Verify skhd is running: `pgrep -fl skhd`
2. Check config file: `cat ~/.config/skhd/skhdrc`
3. Restart skhd: `skhd --restart-service`
4. Check for conflicting macOS shortcuts in System Settings

### Windows not tiling

1. Some apps (System Settings, Calculator) are configured to float by default
2. Check yabai config: `cat ~/.config/yabai/yabairc`
3. Manually tile a floating window: `Shift+Option+Space` (toggles float)

### Animations still present

1. Verify animation settings: `defaults read com.apple.dock expose-animation-duration`
2. Check Reduce Motion is enabled in System Settings → Accessibility → Display
3. Restart Dock: `killall Dock`

## Reverting Changes

### Re-enable Full SIP

1. Boot into Recovery Mode (same process as disabling)
2. Open Terminal from Utilities menu
3. Run: `csrutil enable`
4. Reboot

### Remove Boot Argument (Apple Silicon)

```bash
sudo nvram -d boot-args
```

Then reboot.

### Uninstall

```bash
yabai --stop-service
skhd --stop-service
brew uninstall yabai skhd
rm -rf ~/.config/yabai ~/.config/skhd ~/.config/ghostty
sudo rm /private/etc/sudoers.d/yabai
```

## Resources

- [yabai documentation](https://github.com/koekeishiya/yabai)
- [skhd documentation](https://github.com/koekeishiya/skhd)
- [Ghostty documentation](https://ghostty.org)

## Version Information

This guide was written for:
- yabai v7.1.16
- macOS with partial SIP disabled
- Apple Silicon and Intel Macs

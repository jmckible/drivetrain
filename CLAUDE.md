# AGENTS.md

## What This Is

Dotfiles deployment system for personal Omarchy (Arch Linux) setup, with secondary macOS support. This is NOT a build system - it's a configuration management system using GNU stow for symlinks. **Critical: This extends Omarchy defaults, never replaces them.** The three-tier architecture separates shared configs (stow/), machine-specific configs (templates/), and Omarchy-managed configs (don't touch).

## Commands

### Deployment

```bash
# Full install (auto-detects desktop vs laptop)
./install.sh

# Force specific machine type
./install.sh desktop
./install.sh laptop  # Maps to macbookpro-2014 templates

# macOS install
./install-macos.sh

# Update dotfiles only (skip package installation)
./install/stow.sh [desktop|laptop]

# Individual components
./install/theme.sh
./install/ssh.sh
./install/helium.sh
# ... see install/ directory for all scripts
```

### Reload Services

```bash
hyprctl reload                                          # Hyprland window manager
omarchy-restart-waybar                                  # Status bar
systemctl --user restart omarchy-wallpaper-auto.timer  # Wallpaper rotation
```

### Validation (No Unit Tests)

```bash
# Run install script, check for errors
./install/stow.sh

# Verify symlinks
ls -la ~/.config/nvim  # Should show -> stow/nvim/...

# Check machine detection
cat /tmp/drivetrain-machine-type

# Test app reload
nvim  # Check theme applies correctly
```

## File Architecture

### stow/ - Symlinked Configs (Shared Across Machines)

Location: `stow/appname/.config/appname/`
Usage: Configs identical across all machines
Examples: `nvim/`, `waybar/`, `git/`, `bash/`, `hypr/bindings-custom.conf`
Reference: `install/stow.sh:18-46`

Pattern:
```
stow/nvim/.config/nvim/lua/plugins/theme.lua
     └─> Symlinked to ~/.config/nvim/lua/plugins/theme.lua
```

### templates/ - Copied Configs (Machine-Specific)

Location: `templates/desktop/` or `templates/macbookpro-2014/`
Usage: Hardware-specific settings (monitors, GPU, input sensitivity)
Examples: `hypr/monitors.conf`, `hypr/envs.conf`, `alacritty/alacritty.toml`
Reference: `install/stow.sh:89-123`

Copied during install based on detected/specified machine type:
- Desktop: NVIDIA GPU, 4K monitor, desktop mouse sensitivity
- Laptop: Battery-based detection, integrated GPU, trackpad settings

### themes/ - Local Theme Storage

Location: `themes/drivetrain/`
Usage: Customized theme with Omarchy compatibility fixes
DO NOT pull from upstream - local version has critical fixes for hot reload
Reference: README.md "Theme Management" section

### Omarchy-Managed Configs (HANDS OFF)

Location: `~/.local/share/omarchy/default/`
Behavior: Managed by Omarchy, overwritten on updates
Strategy: Source these first, then layer our overrides on top
Reference: `stow/hypr/.config/hypr/hyprland.conf:3-13`

Source order (Omarchy defaults → our overrides):
```
source = ~/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf
source = ~/.config/hypr/bindings-custom.conf  # Our overrides
```

## Code Style

### Bash Scripts

Reference: `install/helium.sh` (full pattern), `install/theme.sh` (simple pattern)

Idempotent install pattern:
```bash
#!/bin/bash

if ! pacman -Qi packagename &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing packagename..."
    sudo pacman -S --noconfirm --needed packagename
    echo -e "${GREEN}✓${RESET} Package installed"
else
    echo -e "${GREEN}✓${RESET} Package already installed"
fi
```

**Rules:**
- Always check before install (must support re-running)
- Use exported color vars: `$BLUE`, `$GREEN`, `$YELLOW`, `$RED`, `$RESET`, `$BOLD`, `$DIM`
- Use `step "message"` helper for actions (defined in `install.sh`)
- Suppress command output: `&> /dev/null`
- Check command exists: `command -v tool &> /dev/null`
- Make executable: `chmod +x install/name.sh`
- NO `set -e` (allow graceful continuation)

### Lua (Neovim - LazyVim)

Reference: `stow/nvim/.config/nvim/lua/plugins/lspconfig.lua`, `themes/drivetrain/neovim.lua`

**Hot reload pattern (REQUIRED for theme switching):**
```lua
return {
  "plugin/name",
  opts = {
    -- config here
  },
}
```

**DO NOT use (breaks hot reload):**
```lua
config = function()
  require("plugin").setup({...})
end
```

**Rules:**
- Return plugin tables
- Use `opts` not `config` for hot reload compatibility
- Follow LazyVim conventions
- 2-space indent

### Config Files

- **Hyprland**: `.conf` format, `key = value`
- **Waybar**: `.jsonc` (JSON with comments)
- **Alacritty/Ghostty**: `.toml`
- **Starship**: `.toml`
- Match existing file style exactly

### Naming Conventions

- Install scripts: `install/packagename.sh`
- Machine templates: `templates/desktop/`, `templates/macbookpro-2014/`
- Stow directories: `stow/appname/` (match application name)

## Common Operations

### Add Stowed Config (Shared Across Machines)

```bash
# 1. Create directory structure
mkdir -p stow/appname/.config/appname
cp ~/.config/appname/config stow/appname/.config/appname/

# 2. Edit install/stow.sh, add before line 46:
rm -rf ~/.config/appname
stow -d "$STOW_DIR" -t ~ appname

# 3. Test
./install/stow.sh
```

### Add Pacman Package

```bash
# 1. Create install/packagename.sh (copy pattern from install/keepassxc.sh)
cat > install/packagename.sh << 'SCRIPT'
#!/bin/bash
if ! pacman -Qi packagename &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing packagename..."
    sudo pacman -S --noconfirm --needed packagename
    echo -e "${GREEN}✓${RESET} Package installed"
else
    echo -e "${GREEN}✓${RESET} Package already installed"
fi
SCRIPT

# 2. Make executable
chmod +x install/packagename.sh

# 3. Edit install.sh, add around line 90-98:
./install/packagename.sh

# 4. Test
./install/packagename.sh
```

### Add Machine-Specific Config

```bash
# 1. Add template to both machine types
cp some.conf templates/desktop/app/some.conf
cp some.conf templates/macbookpro-2014/app/some.conf
# Edit each for machine-specific values (resolution, sensitivity, etc.)

# 2. Add copy command to install/stow.sh around line 96-123:
cp "$TEMPLATE_DIR/app/some.conf" ~/.config/app/some.conf

# 3. Add to .gitignore so it doesn't get committed:
stow/app/.config/app/some.conf

# 4. Test both machine types
./install/stow.sh desktop
./install/stow.sh laptop
```

### Modify Theme

```bash
# 1. Edit files in themes/drivetrain/
vim themes/drivetrain/waybar.css

# 2. Reinstall theme
./install/theme.sh

# 3. Activate changes
omarchy-theme-set drivetrain

# 4. Reload affected services
omarchy-restart-waybar
hyprctl reload
# Neovim hot-reloads automatically
```

### Add Wallpapers

```bash
# 1. Copy images to backgrounds directory
cp ~/Downloads/new-wallpaper.jpg themes/drivetrain/backgrounds/

# 2. Edit backgrounds.conf to assign to time/weather categories
vim themes/drivetrain/backgrounds.conf
# Add filename to appropriate sections:
# - CLEAR/CLOUDY: Weather-based (morning/afternoon when weather available)
# - MORNING/AFTERNOON/DUSK/NIGHT: Time-based fallbacks
# Images can appear in multiple categories

# 3. Reinstall theme and activate
./install/theme.sh
omarchy-theme-set drivetrain

# 4. Test wallpaper cycling
# Super + Ctrl + Space cycles within current period
```

### Add New Machine

```bash
# 1. Copy existing template
cp -r templates/macbookpro-2014 templates/newmachine-2025

# 2. Edit all configs for new hardware
vim templates/newmachine-2025/hypr/monitors.conf
vim templates/newmachine-2025/hypr/input.conf
vim templates/newmachine-2025/hypr/envs.conf
vim templates/newmachine-2025/alacritty/alacritty.toml

# 3. Update machine type mapping in install/stow.sh lines 89-93:
if [[ $MACHINE_TYPE == "laptop" ]]; then
    TEMPLATE_NAME="newmachine-2025"  # Update this
else
    TEMPLATE_NAME="$MACHINE_TYPE"
fi

# 4. Update README.md with new machine specs

# 5. Test
./install.sh laptop
```

## What NOT to Do

**NEVER:**

1. **Commit machine-specific configs to stow/**
   - Files like `stow/hypr/.config/hypr/monitors.conf` belong in `templates/`
   - `.gitignore` guards these: `monitors.conf`, `input.conf`, `looknfeel.conf`, `envs.conf`, `bindings.conf`, `hardware.conf`
   - If git shows these as modified, you did it wrong - remove them

2. **Modify Omarchy-managed files**
   - Never edit `~/.local/share/omarchy/default/` directly
   - These are overwritten on Omarchy updates
   - Layer your changes on top via source order

3. **Use `config = function()` in Neovim plugins**
   - Breaks hot reload
   - Use `opts = {}` instead
   - Reference: `themes/drivetrain/neovim.lua` for correct pattern

4. **Skip idempotency checks in install scripts**
   - Always check if package/config already exists
   - Scripts must support re-running without errors
   - Reference: `install/helium.sh:3-9`

5. **Hardcode machine-specific values in stow/ files**
   - Monitor resolution, GPU settings, input sensitivity → `templates/`
   - Shared keybindings, themes, app configs → `stow/`

6. **Break Omarchy compatibility**
   - We extend/layer on top, never replace core functionality
   - Test changes don't conflict with Omarchy defaults
   - Use Omarchy commands: `omarchy-theme-set`, `omarchy-restart-waybar`, etc.

7. **Use `set -e` in install scripts**
   - We want graceful continuation, not hard stops
   - Check individual commands with `if !` pattern

8. **Add packages without checking if installed**
   - Always: `if ! pacman -Qi pkg &> /dev/null; then`
   - Prevents errors on re-runs

## Omarchy Compatibility

**CRITICAL: This repo extends Omarchy, never replaces it.**

### Source Order Matters

Omarchy defaults load first, our configs override. See `stow/hypr/.config/hypr/hyprland.conf:3-23`:

```bash
# Omarchy defaults (don't edit these)
source = ~/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf

# Our overrides (edit these)
source = ~/.config/hypr/bindings-custom.conf
```

### Layer, Don't Replace

- Use `bindings-custom.conf` to add/override keybindings
- Don't edit `bindings.conf` directly (Omarchy-managed)
- When Omarchy updates, your overrides persist

### Respect Omarchy Commands

Use Omarchy's tools, don't reinvent:
- `omarchy-theme-set drivetrain` - Set theme
- `omarchy-restart-waybar` - Reload waybar
- `omarchy-font-set` - Change font
- `omarchy-refresh-config` - Pull Omarchy updates

### Theme Integration Requirements

Themes must include all Omarchy-required files (reference: `themes/drivetrain/`):
- `preview.png` - Theme picker preview
- `neovim.lua` - Must use `opts` pattern for hot reload
- `ghostty.conf`, `kitty.conf` - Terminal themes
- `waybar.css`, `hyprland.conf`, `hyprlock.conf` - UI themes

### Check Before Breaking Changes

If Omarchy provides functionality:
1. Check if you can extend it (preferred)
2. Only override if necessary
3. Test that Omarchy updates don't break your changes
4. Document why you're overriding in comments

## References

- **Full install flow**: `install.sh`
- **Machine detection logic**: `install/stow.sh:52-82`
- **Package install pattern**: `install/helium.sh`
- **Neovim plugin patterns**: `stow/nvim/.config/nvim/lua/plugins/`
- **Theme hot reload fix**: `themes/drivetrain/neovim.lua`
- **Architecture details**: `README.md`
- **macOS setup**: `README-MACOS.md`

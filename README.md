# Drivetrain

Personal dotfiles and system configuration for Omarchy on Arch Linux.

## Quick Start

On a fresh Omarchy installation:

```bash
git clone <this-repo> ~/dev/drivetrain
cd ~/dev/drivetrain
./install.sh           # Auto-detect machine type
# or
./install.sh desktop   # Force desktop configuration
./install.sh laptop    # Force laptop configuration (uses macbookpro-2014 templates)
```

The script will:
1. Auto-detect your machine type (Desktop/Laptop) or use provided argument
2. Install SSH for remote access
3. Install and configure the One Dark Pro theme
4. Install MesloLGS Nerd Font Mono and set as default
5. Deploy your dotfiles via stow
6. Configure Hyprland for your specific hardware
7. Install applications (Firefox, KeePassXC, etc.)
8. Install Claude Code CLI

## Architecture

### Three Types of Config Files

**1. Stowed Configs (Symlinked)**
- Location: `stow/*/`
- Behavior: Symlinked to `~/` via GNU stow
- Use for: Configs you want identical across all machines
- Examples: `nvim/`, `waybar/config.jsonc`, `hypr/bindings-custom.conf`

**2. Template Configs (Copied)**
- Location: `templates/hypr/`
- Behavior: Copied to `~/.config/hypr/` during install, then modified based on machine type
- Use for: Machine-specific settings (monitor resolution, GPU, trackpad sensitivity)
- Examples: `monitors.conf`, `input.conf`, `envs.conf`, `looknfeel.conf`

**3. Omarchy-Managed Configs (External)**
- Location: `~/.local/share/omarchy/config/`
- Behavior: Managed by Omarchy, can be refreshed via `omarchy-refresh-config`
- Don't stow these: They'll be overwritten by Omarchy updates
- Example: `hypr/bindings.conf` (base bindings, we override in `bindings-custom.conf`)

### Directory Structure

```
drivetrain/
├── install.sh              # Main install script (accepts desktop/laptop param)
├── install/                # Individual install scripts
│   ├── ssh.sh             # Pacman: openssh
│   ├── theme.sh           # Install One Dark Pro theme from themes/
│   ├── font.sh            # Pacman: ttf-meslo-nerd + omarchy-font-set
│   ├── stow.sh            # Deploys configs + machine detection
│   ├── keyd.sh            # Pacman: F12->7 mapping (laptop only)
│   ├── firefox.sh         # Pacman: firefox + set as default
│   ├── keepassxc.sh       # Pacman: keepassxc
│   ├── omarchy-packages.sh # Omarchy: ruby, node, dropbox, steam
│   └── claude-code.sh     # NPM: @anthropic-ai/claude-code
├── themes/                 # Custom theme (installed locally)
│   └── one-dark-pro/      # Complete One Dark Pro theme
│       ├── neovim.lua     # Neovim colorscheme (fixed for hot reload)
│       ├── ghostty.conf   # Ghostty terminal theme
│       ├── kitty.conf     # Kitty terminal theme
│       ├── alacritty.toml # Alacritty terminal theme
│       ├── vscode.json    # VSCode theme integration
│       ├── waybar.css     # Waybar styling
│       ├── hyprland.conf  # Hyprland window manager colors
│       ├── hyprlock.conf  # Lock screen colors
│       ├── mako.ini       # Notification daemon colors
│       ├── walker.css     # App launcher styling
│       ├── btop.theme     # System monitor theme
│       ├── preview.png    # Theme picker preview image
│       └── backgrounds/   # Custom wallpapers (9 images)
├── stow/                   # Stowed configs (symlinked)
│   ├── nvim/
│   │   └── .config/nvim/
│   │       └── lua/plugins/
│   │           ├── all-themes.lua # Pre-loads themes for hot reload
│   │           └── theme.lua      # Symlinked to theme's neovim.lua
│   ├── waybar/
│   └── hypr/
│       └── .config/hypr/
│           ├── hyprland.conf        # Main config (sources everything)
│           ├── bindings-custom.conf # Your custom keybindings
│           ├── autostart.conf
│           ├── hypridle.conf
│           ├── hyprlock.conf
│           └── windowrules.conf
└── templates/              # Template configs (copied)
    ├── hypr/
    │   ├── monitors.conf   # Display settings per machine
    │   ├── input.conf      # Mouse/trackpad sensitivity
    │   ├── looknfeel.conf  # Window aspect ratio (desktop only)
    │   └── envs.conf       # GPU env vars (NVIDIA on desktop)
    └── alacritty/
        └── alacritty.toml  # Terminal font size per machine
```

## Machine-Specific Configuration

### Desktop (Auto-detected: NVIDIA GPU present)
- Dell S2722QC 27" 4K monitor @ 2x scaling
- NVIDIA GPU with EGL configuration
- Lower mouse sensitivity (-0.55)
- 7:8 single window aspect ratio
- Natural scroll enabled
- Alacritty font size 6.5
- Steam installed

### MacBook Pro 2014 (Auto-detected: Battery present)
- MacBookPro11,2 - Mid-2014 15" Retina @ 1.5x scaling
- Integrated graphics (no NVIDIA)
- Higher trackpad sensitivity (0.1)
- Traditional scroll (non-natural)
- Default window aspect ratio
- Alacritty font size 10
- F12 key remapped to 7 (broken key workaround)
- Steam skipped

## Adding a New Machine

When you get a new laptop or desktop with different hardware specs:

1. **Create a new template directory**:
   ```bash
   cp -r templates/macbookpro-2014 templates/newmachine-2025
   # Edit the configs in templates/newmachine-2025/ for your new hardware
   ```

2. **Update the machine type mapping** in `install/stow.sh`:
   ```bash
   # Map machine type to specific template directory
   if [[ $MACHINE_TYPE == "laptop" ]]; then
       # Update this line to point to your new template:
       TEMPLATE_NAME="newmachine-2025"
   else
       TEMPLATE_NAME="$MACHINE_TYPE"
   fi
   ```

3. **Update keyd config** if needed:
   ```bash
   cp templates/keyd/macbookpro-2014.conf templates/keyd/newmachine-2025.conf
   # Edit as needed, then update install/keyd.sh
   ```

4. **Update this README** with the new machine's specs

This approach keeps machine-specific configs identifiable while maintaining generic auto-detection.

## Theme Management

This repo includes a customized **One Dark Pro** theme that's managed locally instead of from the upstream GitHub repository. The theme is stored in `themes/one-dark-pro/` and includes fixes for proper Omarchy integration.

### Why Local Theme?

The official One Dark Pro theme from GitHub was missing several files and had configuration issues that prevented proper integration with Omarchy:
- **Missing `preview.png`** - Theme picker had no preview image
- **Missing terminal configs** - No `ghostty.conf`, `kitty.conf`, or `vscode.json`
- **Broken hot reload** - Neovim config didn't follow Omarchy's pattern, causing hot reloads to fail

### Theme Structure

The local theme includes all required Omarchy theme files:

```
themes/one-dark-pro/
├── neovim.lua          # Fixed for hot reload support
├── preview.png         # Theme picker preview (required)
├── ghostty.conf        # Ghostty terminal (Omarchy 3.2.0 default)
├── kitty.conf          # Kitty terminal
├── alacritty.toml      # Alacritty terminal
├── vscode.json         # VSCode extension integration
├── waybar.css          # Status bar styling
├── hyprland.conf       # Window manager colors
├── hyprlock.conf       # Lock screen
├── mako.ini            # Notifications
├── walker.css          # App launcher
├── swayosd.css         # OSD styling
├── btop.theme          # System monitor
├── chromium.theme      # Browser theme
├── icons.theme         # Icon pack reference
├── starship.toml       # Shell prompt
└── backgrounds/        # 9 custom wallpapers
```

### How Theme Installation Works

When you run `./install.sh` or `./install/theme.sh`:

1. **Copy theme to Omarchy**: `themes/one-dark-pro/` → `~/.config/omarchy/themes/one-dark-pro/`
2. **Set as current**: Runs `omarchy-theme-set one-dark-pro`
3. **Symlink to active theme**: Omarchy creates `~/.config/omarchy/current/theme/` → theme files
4. **Neovim picks it up**: `stow/nvim/.config/nvim/lua/plugins/theme.lua` symlinks to the theme's `neovim.lua`

### Modifying the Theme

**To change theme colors or styling:**

1. Edit files in `themes/one-dark-pro/`
2. Reinstall the theme:
   ```bash
   ./install/theme.sh
   ```
3. Reload applications as needed:
   ```bash
   omarchy-restart-waybar
   hyprctl reload
   # Neovim will hot-reload automatically
   ```

**To add custom wallpapers:**

1. Add images to `themes/one-dark-pro/backgrounds/`
2. Reinstall theme: `./install/theme.sh`
3. Select new wallpaper via `Super + W` or wallpaper picker

**To update from upstream:**

The upstream theme is at: https://github.com/sc0ttman/omarchy-one-dark-pro-theme

If you want to pull updates:
```bash
cd /tmp
git clone https://github.com/sc0ttman/omarchy-one-dark-pro-theme
cd omarchy-one-dark-pro-theme
# Manually copy desired files to ~/dev/drivetrain/themes/one-dark-pro/
# DO NOT overwrite neovim.lua, ghostty.conf, kitty.conf, vscode.json, or preview.png
# These have been fixed/added locally
```

### Neovim Hot Reload Fix

The local `neovim.lua` was modified to support hot reload via `omarchy-theme-set`.

**Upstream version (doesn't work with hot reload):**
```lua
config = function()
  require("onedarkpro").setup({...})
  vim.cmd("colorscheme onedark")  -- Sets theme directly
end
```

**Fixed version (works with hot reload):**
```lua
{
  "olimorris/onedarkpro.nvim",
  opts = {...},  -- Uses opts instead of config
},
{
  "LazyVim/LazyVim",
  opts = { colorscheme = "onedark" },  -- LazyVim controls theme
}
```

The fixed version allows `omarchy-theme-hotreload.lua` to detect and apply theme changes automatically.

**Additionally**, `olimorris/onedarkpro.nvim` was added to `stow/nvim/.config/nvim/lua/plugins/all-themes.lua` so the plugin is pre-loaded for instant hot reloading.

## Adding New Configurations

### Add a new stowed config (shared across machines)

1. Create directory structure:
   ```bash
   mkdir -p stow/appname/.config/appname
   cp ~/.config/appname/config.file stow/appname/.config/appname/
   ```

2. Add to `install/stow.sh`:
   ```bash
   rm -rf ~/.config/appname
   stow -d "$STOW_DIR" -t ~ appname
   ```

### Add a new pacman package

1. Create `install/packagename.sh`:
   ```bash
   #!/bin/bash
   if ! pacman -Qi packagename &> /dev/null; then
       echo "Installing packagename..."
       sudo pacman -S --noconfirm --needed packagename
   else
       echo "packagename already installed, skipping"
   fi
   ```

2. Make executable and add to `install.sh`:
   ```bash
   chmod +x install/packagename.sh
   # Add: ./install/packagename.sh
   ```

### Add a new Omarchy package

Add to `install/omarchy-packages.sh` with appropriate checks.

### Add machine-specific config

1. Add template to `templates/hypr/filename.conf`
2. Add copy command to `install/stow.sh` (before stowing)
3. Add sed commands for Desktop/Laptop sections
4. Add to `.gitignore`: `stow/hypr/.config/hypr/filename.conf`

## Updating Existing Machines

### Update dotfiles only
```bash
cd ~/dev/drivetrain
git pull
./install/stow.sh           # Auto-detect and update symlinks
# or
./install/stow.sh desktop   # Force desktop configuration
./install/stow.sh laptop    # Force laptop configuration (uses macbookpro-2014 templates)
```

### Full reinstall
```bash
cd ~/dev/drivetrain
git pull
./install.sh           # Auto-detect and run everything
# or
./install.sh desktop   # Force desktop configuration
./install.sh laptop    # Force laptop configuration (uses macbookpro-2014 templates)
```

### Merge Omarchy updates

When Omarchy updates `bindings.conf` or other managed files:
```bash
cd ~/dev/omarchy
git pull
diff config/hypr/bindings.conf ~/.config/hypr/bindings.conf
# Review changes, manually merge if desired
```

Your `bindings-custom.conf` overrides will persist.

## Troubleshooting

### Hyprland won't start after install
- Press `Ctrl+Alt+F2` for TTY
- Check `~/.config/hypr/envs.conf` - ensure NVIDIA settings are commented out on laptop
- Run `hyprctl reload` or restart Hyprland

### Git shows unstaged changes in stow/hypr/
- Those files shouldn't be there - they belong in `templates/`
- Remove them: `rm stow/hypr/.config/hypr/{monitors,input,looknfeel,envs,bindings}.conf`
- They're in `.gitignore` to prevent this

### Waybar not updating after config change
```bash
omarchy-restart-waybar
```

### SSH not working after install
```bash
sudo systemctl enable --now sshd
ip addr  # Get your IP for remote connection
```

## Customization Guide

### Change browser
Edit `stow/hypr/.config/hypr/bindings-custom.conf`:
```bash
$browser = uwsm app -- firefox  # Change to your preferred browser
```

### Add custom keybinding
Add to `stow/hypr/.config/hypr/bindings-custom.conf`:
```bash
bindd = SUPER SHIFT, X, Description, exec, command-to-run
```

### Customize waybar
Edit `stow/waybar/.config/waybar/config.jsonc` - your changes sync across machines.

## Notes

- **Omarchy updates**: May replace `bindings.conf`, check backups in `~/.config/hypr/bindings.conf.bak.*`
- **Theme**: Managed locally in `themes/one-dark-pro/` - see [Theme Management](#theme-management) section
- **Lazy-lock.json**: Included in stow for reproducible Neovim plugin versions
- **SSH**: Installed first as a "backdoor" in case something breaks during setup

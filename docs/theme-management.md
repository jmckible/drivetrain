# Theme Management

This repo includes a custom **Drivetrain** theme that's managed locally. The theme is stored in `themes/drivetrain/` and includes fixes for proper Omarchy integration.

## Why Local Theme?

The theme is based on One Dark Pro colors, with fixes for Omarchy integration:
- **Missing `preview.png`** - Theme picker had no preview image
- **Missing terminal configs** - No `ghostty.conf`, `kitty.conf`, or `vscode.json`
- **Broken hot reload** - Neovim config didn't follow Omarchy's pattern, causing hot reloads to fail

## Theme Structure

The local theme includes all required Omarchy theme files:

```
themes/drivetrain/
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
└── backgrounds/        # Custom wallpapers
```

## How Theme Installation Works

When you run `./install.sh` or `./install/theme.sh`:

1. **Copy theme to Omarchy**: `themes/drivetrain/` → `~/.config/omarchy/themes/drivetrain/`
2. **Set as current**: Runs `omarchy-theme-set drivetrain`
3. **Symlink to active theme**: Omarchy creates `~/.config/omarchy/current/theme/` → theme files
4. **Neovim picks it up**: `stow/nvim/.config/nvim/lua/plugins/theme.lua` symlinks to the theme's `neovim.lua`

## Modifying the Theme

### Change theme colors or styling

1. Edit files in `themes/drivetrain/`
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

### Add custom wallpapers

1. Add images to `themes/drivetrain/backgrounds/`
2. Edit `themes/drivetrain/backgrounds.conf` to assign wallpapers to time periods and weather:
   - `CLEAR` / `CLOUDY` - Weather-based (used during MORNING/AFTERNOON when weather available)
   - `MORNING` / `AFTERNOON` / `DUSK` / `NIGHT` - Time-based fallbacks
   - Images can appear in multiple categories
3. Reinstall theme: `./install/theme.sh`
4. Activate changes: `omarchy-theme-set drivetrain`
5. Test with `Super + Ctrl + Space` to cycle wallpapers in current period

### Update from upstream

The upstream theme is at: https://github.com/sc0ttman/omarchy-one-dark-pro-theme

If you want to pull updates:
```bash
cd /tmp
git clone https://github.com/sc0ttman/omarchy-one-dark-pro-theme
cd omarchy-one-dark-pro-theme
# Manually copy desired files to ~/dev/drivetrain/themes/drivetrain/
# DO NOT overwrite neovim.lua, ghostty.conf, kitty.conf, vscode.json, or preview.png
# These have been fixed/added locally
```

## Neovim Hot Reload Fix

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

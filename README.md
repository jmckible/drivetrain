# Drivetrain

Personal dotfiles for Arch Linux (Omarchy) and macOS tiling window management.

## Features

### Drivetrain Theme

Customized One Dark Pro color scheme. Included wallpapers rotate automatically based on time of day (sunrise/sunset) and weather conditions.

### Platform Support

- **Hyprland** tiling window manager (Linux/Omarchy)
- **yabai/skhd** tiling setup mirroring Hyprland keybindings (macOS)

### Other Features

- **Machine auto-detection** - NVIDIA GPU → desktop, battery → laptop
- **GNU stow** dotfile deployment with machine-specific templates
- **Neovim** (LazyVim) with hot-reload theme support
- **Helium browser** with Widevine DRM for Apple Music, Spotify
- **Keyd** keyboard remapping - Super+W → Ctrl+W for browser tab close

## Quick Start

### Linux (Omarchy)

```bash
git clone <this-repo> ~/dev/drivetrain
cd ~/dev/drivetrain
./install.sh           # Auto-detect machine type
# or
./install.sh desktop   # Force desktop
./install.sh laptop    # Force laptop
```

The script installs SSH, deploys dotfiles via stow, configures Hyprland for your hardware, installs applications, and sets up Claude Code.

### macOS

```bash
git clone <this-repo> ~/dev/drivetrain
cd ~/dev/drivetrain
./install-macos.sh
```

Installs yabai, skhd, and Ghostty. **Requires manual steps** for SIP and system shortcuts.

See [docs/macos-setup.md](docs/macos-setup.md) for full setup guide.

## Architecture

```
drivetrain/
├── stow/           # Symlinked configs (shared across machines)
│   ├── nvim/       # Neovim/LazyVim
│   ├── waybar/     # Status bar
│   ├── hypr/       # Hyprland (bindings-custom.conf, etc.)
│   ├── yabai/      # macOS window manager
│   └── skhd/       # macOS hotkeys
├── templates/      # Machine-specific configs (copied during install)
│   ├── desktop/    # NVIDIA GPU, 4K monitor
│   └── macbookpro-2014/
├── themes/
│   └── drivetrain/ # Custom Omarchy theme
└── install/        # Individual install scripts
```

### Config Types

| Type | Location | Behavior |
|------|----------|----------|
| **Stowed** | `stow/*/` | Symlinked to `~/` via GNU stow |
| **Templates** | `templates/*/` | Copied and modified per machine |
| **Omarchy-managed** | `~/.local/share/omarchy/` | External, don't edit directly |

## Machine Support

| Machine | Key Specs | Detection |
|---------|-----------|-----------|
| **Desktop** | Dell 27" 4K @ 2x, NVIDIA GPU | NVIDIA GPU present |
| **MacBook Pro 2014** | 15" Retina @ 1.5x, trackpad | Battery present |
| **macOS** | yabai/skhd tiling | Manual install |

## Customization

### Change browser
Edit `stow/hypr/.config/hypr/bindings-custom.conf`:
```bash
$browser = uwsm app -- helium-browser
```

### Add custom keybinding
Add to `stow/hypr/.config/hypr/bindings-custom.conf`:
```bash
bindd = SUPER SHIFT, X, Description, exec, command-to-run
```

### Customize waybar
Edit `stow/waybar/.config/waybar/config.jsonc`.

## Documentation

| Guide | Description |
|-------|-------------|
| [Theme Management](docs/theme-management.md) | Customizing colors, wallpapers, Neovim hot reload |
| [Adding Configs](docs/adding-configs.md) | How to add new packages, stow configs, machines |
| [Troubleshooting](docs/troubleshooting.md) | Common issues and fixes |
| [macOS Setup](docs/macos-setup.md) | Full yabai/skhd installation guide |
| [macOS Uninstall](docs/macos-uninstall.md) | Complete removal instructions |
| [Keybindings](docs/keybindings.md) | Hyprland vs macOS comparison |
| [Helium Widevine](docs/helium-widevine.md) | DRM setup for Netflix, Spotify |

## Notes

- **Omarchy updates** may replace `bindings.conf` - your `bindings-custom.conf` overrides persist
- **Theme** is managed locally in `themes/drivetrain/`
- **SSH** is installed first as a recovery backdoor
- **lazy-lock.json** is stowed for reproducible Neovim plugin versions

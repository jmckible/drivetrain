# Drivetrain

Personal dotfiles and system configuration for Omarchy on Arch Linux.

## Quick Start

On a fresh Omarchy installation:

```bash
git clone <this-repo> ~/dev/drivetrain
cd ~/dev/drivetrain
./install.sh
```

The script will:
1. Auto-detect your machine type (Desktop/Laptop)
2. Install SSH for remote access
3. Install and configure the One Dark Pro theme
4. Deploy your dotfiles via stow
5. Configure Hyprland for your specific hardware
6. Install applications (Firefox, KeePassXC, etc.)

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
├── install.sh              # Main install script
├── install/                # Individual install scripts
│   ├── ssh.sh             # Pacman: openssh
│   ├── theme.sh           # Omarchy: one-dark-pro theme
│   ├── stow.sh            # Deploys configs + machine detection
│   ├── keyd.sh            # Pacman: F12->7 mapping (laptop only)
│   ├── firefox.sh         # Pacman: firefox + set as default
│   ├── keepassxc.sh       # Pacman: keepassxc
│   └── omarchy-packages.sh # Omarchy: ruby, node, dropbox, steam
├── stow/                   # Stowed configs (symlinked)
│   ├── nvim/
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
    └── hypr/
        ├── monitors.conf   # Display settings per machine
        ├── input.conf      # Mouse/trackpad sensitivity
        ├── looknfeel.conf  # Window aspect ratio (desktop only)
        └── envs.conf       # GPU env vars (NVIDIA on desktop)
```

## Machine-Specific Configuration

### Desktop (Auto-detected: NVIDIA GPU present)
- Dell S2722QC 27" 4K monitor @ 2x scaling
- NVIDIA GPU with EGL configuration
- Lower mouse sensitivity (-0.55)
- 7:8 single window aspect ratio
- Natural scroll enabled
- Steam installed

### Laptop (Auto-detected: Battery present)
- 2012 MacBook Pro 15" Retina @ 2x scaling
- Integrated graphics (no NVIDIA)
- Higher trackpad sensitivity (0.1)
- Traditional scroll (non-natural)
- Default window aspect ratio
- F12 key remapped to 7 (broken key workaround)
- Steam skipped

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
./install/stow.sh  # Re-run to update symlinks
```

### Full reinstall
```bash
cd ~/dev/drivetrain
git pull
./install.sh  # Runs everything
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
- **Theme**: Managed via `omarchy-theme-install` and `omarchy-theme-set`
- **Lazy-lock.json**: Included in stow for reproducible Neovim plugin versions
- **SSH**: Installed first as a "backdoor" in case something breaks during setup

# Troubleshooting

## Linux (Omarchy/Hyprland)

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

### Theme not applying correctly
```bash
./install/theme.sh
omarchy-theme-set drivetrain
hyprctl reload
omarchy-restart-waybar
```

## macOS

See [macos-setup.md](macos-setup.md#troubleshooting) for macOS-specific troubleshooting.

## Updating Dotfiles

### Update dotfiles only
```bash
cd ~/dev/drivetrain
git pull
./install/stow.sh           # Auto-detect and update symlinks
# or
./install/stow.sh desktop   # Force desktop configuration
./install/stow.sh laptop    # Force laptop configuration
```

### Full reinstall
```bash
cd ~/dev/drivetrain
git pull
./install.sh           # Auto-detect and run everything
# or
./install.sh desktop   # Force desktop configuration
./install.sh laptop    # Force laptop configuration
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

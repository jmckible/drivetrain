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

### Waybar pegging a CPU core (fan spinning)

Misconfigured `custom/*` modules can silently pin a core 24/7 (screensaver/idle does
not stop it). Two distinct failure modes, both hit here once:

**Respawn storm** — a `custom/*` module with `exec` but no `interval` *and* no
`signal` is treated as a persistent script; if the script exits immediately, waybar
re-forks it thousands of times/sec. Stock Omarchy's `custom/voxtype` triggers this
when the `voxtype` binary isn't installed — its status script falls to an
`echo`-once-and-exit branch. Symptom: a fork storm of `bash`/`jq`/`omarchy-cmd-present`
children under waybar.
- Fix: `omarchy-voxtype-install` so the module's persistent `voxtype status --follow`
  path blocks instead of exiting (voxtype is now installed, so a re-merged stock
  config is safe), or drop the module.

**Internal spin** — `"interval": 0` on a signal-driven module makes waybar busy-poll
the closed pipe: high CPU with *no* child processes. Our `custom/color-mode` had this.
- Fix: use `"interval": "once"` — the `signal` already handles refresh.

Diagnose: `systemctl --user status 'app-Hyprland-waybar-*.scope'` shows the whole
subtree's CPU. Fast-forking children → respawn storm; none → internal spin.

Configs live in `stow/waybar/.config/waybar/config.jsonc`. On Omarchy merges, re-check
any stock `custom/*` module for a missing `interval`/`signal` or `"interval": 0`.

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

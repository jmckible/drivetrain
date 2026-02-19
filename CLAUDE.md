# Drivetrain

Dotfiles deployment using GNU stow. Extends Omarchy (Arch Linux), never replaces it.

## Commands

```bash
./install.sh              # Full install (auto-detects desktop vs laptop)
./install.sh desktop      # Force machine type
./install/stow.sh         # Update dotfiles only
./install/theme.sh        # Reinstall theme

hyprctl reload            # Reload Hyprland
omarchy-restart-waybar    # Reload status bar
omarchy-theme-set drivetrain  # Apply theme
```

## Architecture

Three-tier system:

| Location | Purpose | Example |
|----------|---------|---------|
| `stow/` | Shared configs (symlinked) | `nvim/`, `git/`, `waybar/` |
| `templates/` | Machine-specific (copied) | `monitors.conf`, `envs.conf` |
| `~/.local/share/omarchy/default/` | Omarchy-managed (hands off) | Core bindings, defaults |

**Stow pattern:** `stow/appname/.config/appname/` → symlinked to `~/.config/appname/`

**Omarchy layering:** Source Omarchy defaults first, then our overrides:
```
source = ~/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf
source = ~/.config/hypr/bindings-custom.conf  # Our overrides
```

## Patterns

### Bash Install Scripts

Idempotent with color output (reference: `install/helium.sh`):

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

No `set -e`. Always check before install. Suppress output with `&> /dev/null`.

### Neovim Plugins (LazyVim)

Use `opts` for hot reload compatibility:

```lua
return {
  "plugin/name",
  opts = { },  -- Good: hot reload works
}
```

Never use `config = function()` - breaks theme hot reload.

### Config Formats

- **Hyprland**: `.conf`, `key = value`
- **Waybar**: `.jsonc`
- **Alacritty/Ghostty/Starship**: `.toml`

## Apple Music PWA Integration

Album links on the Dashboard web app open in the local Apple Music PWA (chromium `--app` window) instead of a browser tab. The local machine runs an HTTP listener that the Dashboard server relays requests to via Tailscale Funnel.

**Components:**
- `stow/bin/.local/bin/apple-music-listener` — HTTP server on port 9111. Receives album URLs, triggers `apple-music-open`. Runs as a systemd user service.
- `stow/bin/.local/bin/apple-music-open` — Closes existing PWA window via `hyprctl`, launches `chromium --app=<url>`.
- `stow/bin/.local/share/applications/apple-music.desktop` — XDG handler for `music-pwa://` scheme (used internally between listener and opener).
- `stow/systemd/.config/systemd/user/apple-music-listener.service` — Keeps the listener running.

**Request flow:** Dashboard server → `https://dell.hummingbird-ostrich.ts.net/music/` (Tailscale Funnel) → `http://127.0.0.1:9111` (listener) → `apple-music-open` → chromium PWA.

**Tailscale Funnel** must be configured: `tailscale funnel --bg --set-path /music 9111`. This exposes the listener publicly so the Dashboard server can reach it. The listener only accepts `music.apple.com` URLs.

## Critical Rules

1. **Never modify `~/.local/share/omarchy/default/`** - overwritten on Omarchy updates. Layer overrides via source order instead.

2. **Machine-specific values go in `templates/`, not `stow/`** - monitors, GPU settings, input sensitivity. The `.gitignore` guards these files.

3. **Install scripts must be idempotent** - always check if package/config exists before acting.

4. **Use Omarchy commands** - `omarchy-theme-set`, `omarchy-restart-waybar`, `omarchy-font-set`. Don't reinvent.

5. **Theme files require `opts` pattern** - `themes/drivetrain/neovim.lua` must not use `config = function()`.

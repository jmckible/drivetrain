# Uninstalling macOS Tiling Window Manager Setup

This guide covers how to completely remove yabai, skhd, and all associated configurations, returning your macOS to its default state.

## Quick Uninstall (Complete Removal)

If you want to remove everything immediately:

```bash
# Stop services
yabai --stop-service
skhd --stop-service

# Uninstall via Homebrew
brew uninstall yabai skhd

# Remove configuration files
rm -rf ~/.config/yabai
rm -rf ~/.config/skhd

# Remove sudoers file
sudo rm /private/etc/sudoers.d/yabai

# Remove boot argument (Apple Silicon only)
sudo nvram -d boot-args

# Revert animation settings
defaults delete com.apple.dock workspaces-swoosh-animation-off
defaults delete com.apple.dock expose-animation-duration
killall Dock
```

Then follow the "Re-enable System Integrity Protection" section below to fully restore SIP.

## Step-by-Step Uninstall

### 1. Stop Running Services

```bash
yabai --stop-service
skhd --stop-service
```

Verify they've stopped:
```bash
pgrep -fl yabai
pgrep -fl skhd
```

These should return nothing.

### 2. Uninstall Applications

```bash
brew uninstall yabai
brew uninstall skhd
```

### 3. Remove Configuration Files

```bash
# Remove yabai config
rm -rf ~/.config/yabai

# Remove skhd config
rm -rf ~/.config/skhd

# Remove Ghostty config (optional - only if you want to remove it)
rm -rf ~/.config/ghostty
```

### 4. Remove Sudoers Entry

```bash
sudo rm /private/etc/sudoers.d/yabai
```

### 5. Remove Boot Argument (Apple Silicon Only)

If you're on Apple Silicon and set the boot argument:

```bash
# Check current boot args
nvram boot-args

# Remove the boot argument
sudo nvram -d boot-args
```

Then **reboot your Mac** for this to take effect.

### 6. Re-enable System Integrity Protection

This is the most important step to fully restore your system's default security posture.

#### Boot into Recovery Mode

**Apple Silicon:**
1. Shut down your Mac completely
2. Hold the power button until "Loading startup options..." appears
3. Click **Options**, then **Continue**
4. Select your user account and enter password if prompted

**Intel Mac:**
1. Restart your Mac
2. Immediately hold **Cmd+R**
3. Keep holding until Recovery Mode loads

#### Re-enable Full SIP

1. Once in Recovery Mode, open **Utilities** → **Terminal** from the menu bar
2. Run this command:

```bash
csrutil enable
```

3. You should see: "Successfully enabled System Integrity Protection."
4. Restart your Mac from the Apple menu

#### Verify SIP is Fully Enabled

After rebooting to normal macOS:

```bash
csrutil status
```

Should show:
```
System Integrity Protection status: enabled.
```

All protections should be enabled now.

### 7. Restore macOS Animation Settings

```bash
# Remove custom animation settings
defaults delete com.apple.dock workspaces-swoosh-animation-off
defaults delete com.apple.dock expose-animation-duration

# Restart Dock to apply changes
killall Dock
```

### 8. Disable Reduce Motion (Optional)

If you enabled Reduce Motion and want to restore animations:

1. Open **System Settings**
2. Go to **Accessibility** → **Display**
3. **Disable** "Reduce motion"

### 9. Re-enable Mission Control Shortcuts (Optional)

If you disabled Mission Control keyboard shortcuts:

1. Open **System Settings**
2. Go to **Keyboard** → **Keyboard Shortcuts** → **Mission Control**
3. **Enable** shortcuts like "Switch to Desktop 1/2/3" if you want them

### 10. Clean Up Extra Desktops (Optional)

If you created many extra desktops/spaces:

1. Open **Mission Control** (three-finger swipe up or F3)
2. Hover over each extra desktop at the top
3. Click the **X** button to remove desktops you don't need

## Partial Uninstall Options

### Keep yabai but Remove Scripting Addition

If you want to keep yabai in limited mode without SIP disabled:

```bash
# Remove sudoers entry
sudo rm /private/etc/sudoers.d/yabai

# Remove boot argument (Apple Silicon)
sudo nvram -d boot-args

# Re-enable SIP (follow instructions above)

# Restart yabai
yabai --restart-service
```

yabai will continue to work but without the ability to control spaces directly.

### Keep Configurations but Disable Services

If you want to keep configs but stop services temporarily:

```bash
yabai --stop-service
skhd --stop-service
```

To restart later:
```bash
yabai --start-service
skhd --start-service
```

### Remove Only skhd (Keep yabai)

```bash
skhd --stop-service
brew uninstall skhd
rm -rf ~/.config/skhd
```

yabai will still tile windows but you'll have no keyboard shortcuts.

## Verification Checklist

After uninstalling, verify everything is cleaned up:

- [ ] yabai service not running: `pgrep -fl yabai` returns nothing
- [ ] skhd service not running: `pgrep -fl skhd` returns nothing
- [ ] Applications uninstalled: `brew list | grep -E "(yabai|skhd)"` returns nothing
- [ ] Config directories removed: `ls ~/.config/yabai ~/.config/skhd` both show "No such file or directory"
- [ ] Sudoers file removed: `sudo cat /private/etc/sudoers.d/yabai` shows "No such file or directory"
- [ ] Boot argument removed (Apple Silicon): `nvram boot-args` shows nothing or default values
- [ ] SIP fully enabled: `csrutil status` shows "enabled" with no custom configuration
- [ ] Animations restored: Desktop switching has normal animation
- [ ] Windows behave normally: Opening apps doesn't auto-tile them

## Troubleshooting Uninstall Issues

### Services Won't Stop

If `yabai --stop-service` or `skhd --stop-service` don't work:

```bash
# Force kill the processes
pkill -9 yabai
pkill -9 skhd

# Check they're gone
pgrep -fl yabai
pgrep -fl skhd
```

### Can't Remove Sudoers File

```bash
# Check if file exists
ls -la /private/etc/sudoers.d/

# Remove with full path
sudo rm -f /private/etc/sudoers.d/yabai

# Verify removal
ls -la /private/etc/sudoers.d/
```

### Boot Argument Won't Delete (Apple Silicon)

```bash
# Try resetting NVRAM completely (use with caution)
sudo nvram -c

# Or set it to empty string
sudo nvram boot-args=""

# Verify
nvram boot-args
```

Then reboot.

### SIP Won't Re-enable

If you get errors when trying to re-enable SIP in Recovery Mode:

1. Make sure you're actually in Recovery Mode (not just a Terminal)
2. Try the command again: `csrutil enable`
3. If it says "Operation not permitted", you may need to authenticate
4. Some Macs require selecting the boot volume first: `csrutil enable --volume /System/Volumes/Data`

### Animations Still Disabled

```bash
# Check current settings
defaults read com.apple.dock expose-animation-duration
defaults read com.apple.dock workspaces-swoosh-animation-off

# Force remove all dock preferences (nuclear option)
defaults delete com.apple.dock
killall Dock

# The Dock will recreate default settings
```

### Homebrew Says "Not Installed"

If you get "No such keg" when trying to uninstall:

```bash
# List all installed formulae
brew list

# If yabai/skhd aren't listed, they're already uninstalled
# Just clean up config files manually
rm -rf ~/.config/yabai ~/.config/skhd
```

## What Gets Left Behind

After uninstalling, these things remain but are harmless:

- **Ghostty application** - Only if you installed it, uninstall separately with: `brew uninstall --cask ghostty`
- **Homebrew tap** - The koekeishiya tap remains but is inactive: `brew untap koekeishiya/formulae` to remove
- **Extra desktops** - Any additional spaces/desktops you created remain until you manually remove them
- **Neovim configs** - Your LazyVim setup is unchanged

## Confirming Complete Removal

Run this verification script:

```bash
#!/bin/bash

echo "=== Verifying yabai/skhd Removal ==="
echo ""

echo "Services running:"
pgrep -fl yabai && echo "  ❌ yabai is still running" || echo "  ✓ yabai not running"
pgrep -fl skhd && echo "  ❌ skhd is still running" || echo "  ✓ skhd not running"
echo ""

echo "Applications installed:"
brew list | grep -q yabai && echo "  ❌ yabai still installed" || echo "  ✓ yabai not installed"
brew list | grep -q skhd && echo "  ❌ skhd still installed" || echo "  ✓ skhd not installed"
echo ""

echo "Config files:"
[ -d ~/.config/yabai ] && echo "  ❌ yabai config exists" || echo "  ✓ yabai config removed"
[ -d ~/.config/skhd ] && echo "  ❌ skhd config exists" || echo "  ✓ skhd config removed"
echo ""

echo "Sudoers file:"
[ -f /private/etc/sudoers.d/yabai ] && echo "  ❌ sudoers file exists" || echo "  ✓ sudoers file removed"
echo ""

echo "SIP status:"
csrutil status | grep -q "enabled.$" && echo "  ✓ SIP fully enabled" || echo "  ❌ SIP has custom configuration"
echo ""

echo "Boot args (Apple Silicon):"
nvram boot-args 2>/dev/null | grep -q "arm64e_preview_abi" && echo "  ❌ Boot arg still set" || echo "  ✓ Boot arg not set"
```

Save this as `verify-uninstall.sh`, make it executable with `chmod +x verify-uninstall.sh`, and run it with `./verify-uninstall.sh`.

All items should show ✓ for a complete uninstall.

## Need Help?

If you encounter issues during uninstallation:

1. Check the Troubleshooting section above
2. Review yabai documentation: https://github.com/koekeishiya/yabai/wiki
3. Make sure you're following steps in order, especially the SIP re-enable step

## Re-installing Later

If you want to reinstall yabai/skhd after uninstalling:

1. Follow the main setup guide from the beginning
2. All the same steps apply (SIP, boot args, configs)
3. Your old configuration files will be gone, so you'll need to recreate them

Consider backing up your configs before uninstalling:

```bash
# Backup before uninstalling
mkdir -p ~/dotfiles-backup
cp -r ~/.config/yabai ~/dotfiles-backup/
cp -r ~/.config/skhd ~/dotfiles-backup/

# Restore later if needed
cp -r ~/dotfiles-backup/yabai ~/.config/
cp -r ~/dotfiles-backup/skhd ~/.config/
```

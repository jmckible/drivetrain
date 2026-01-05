# Helium Widevine DRM Setup

Helium browser supports Widevine DRM but doesn't include it by default. This enables Netflix, Spotify, and other DRM-protected content.

## Automatic Setup

Widevine is installed automatically when you run:

```bash
cd ~/dev/drivetrain
./install/helium.sh
```

This is also included in the main `./install.sh` script.

## What It Does

1. **Installs Widevine CDM** to `/usr/lib/chromium/WidevineCdm` from Mozilla's official source
2. **Configures Helium** to use the system-wide Widevine installation via `~/.config/net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm`

## Manual Setup

If you prefer to do it manually:

```bash
# Install Widevine (requires sudo)
curl -fsSL https://raw.githubusercontent.com/cryptic-noodle/configs/main/helium/widevine-chromium-installer.sh | sudo bash

# Configure Helium to use it
mkdir -p ~/.config/net.imput.helium/WidevineCdm
echo -n '{"Path":"/usr/lib/chromium/WidevineCdm"}' > ~/.config/net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm
```

Restart Helium.

## Verification

1. Open Helium and go to `chrome://components`
2. You should see "Widevine Content Decryption Module" listed
3. Test DRM playback at https://bitmovin.com/demos/drm or Netflix

## Technical Details

- **Widevine Location**: `/usr/lib/chromium/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so`
- **Config File**: `~/.config/net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm`
- **Format**: JSON with full path: `{"Path":"/usr/lib/chromium/WidevineCdm"}`
- **Source**: Mozilla Firefox's Widevine distribution (verified via SHA-512)

## Troubleshooting

**Widevine not showing in chrome://components**
- Verify the config file exists and has correct JSON format
- Ensure `/usr/lib/chromium/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so` exists
- Restart Helium completely (kill all processes: `pkill -9 helium; pkill -9 chrome`)

**Permission errors during installation**
- The installer script requires sudo to write to `/usr/lib/chromium/`
- User config at `~/.config/net.imput.helium/` doesn't require sudo

## Uninstall

```bash
# Run the installer with --uninstall flag
curl -fsSL https://raw.githubusercontent.com/cryptic-noodle/configs/main/helium/widevine-chromium-installer.sh | sudo bash -s -- --uninstall

# Remove Helium config
rm -rf ~/.config/net.imput.helium/WidevineCdm
```

## Credits

- Solution from: https://github.com/imputnet/helium/issues/116
- Installer by: https://github.com/cryptic-noodle
- Widevine source: Mozilla Firefox's official distribution

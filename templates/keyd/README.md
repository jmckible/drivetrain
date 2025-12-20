# keyd Configuration

This directory contains the keyd configuration for low-level key remapping.

## Templates

- **default.conf**: Base configuration (SUPER-W → CTRL-W)
- **desktop.conf**: Desktop-specific configuration (same as default)
- **macbookpro-2014.conf**: MacBook Pro 2014-specific configuration (SUPER-W → CTRL-W + F12 → 7 fix)

## Installation

The install script (`install/keyd.sh`) automatically installs keyd and deploys the appropriate template based on your machine type.

Manual installation:
```bash
# Install keyd
sudo pacman -S keyd

# Copy appropriate config
sudo cp desktop.conf /etc/keyd/default.conf  # or macbookpro-2014.conf

# Enable and start service
sudo systemctl enable keyd
sudo systemctl restart keyd
```

## Current Remappings

- **SUPER-W** → **CTRL-W**: Close browser tabs (works globally)
- **F12** → **7**: Laptop only - fixes MacBook Pro F12 key mapping issue

# Adding New Configurations

## Add a new stowed config (shared across machines)

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

## Add a new pacman package

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

## Add a new Omarchy package

Add to `install/omarchy-packages.sh` with appropriate checks.

## Add machine-specific config

1. Add template to `templates/hypr/filename.conf`
2. Add copy command to `install/stow.sh` (before stowing)
3. Add sed commands for Desktop/Laptop sections
4. Add to `.gitignore`: `stow/hypr/.config/hypr/filename.conf`

## Add a new machine

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

4. **Update the README** with the new machine's specs

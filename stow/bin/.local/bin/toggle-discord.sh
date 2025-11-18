#!/bin/bash
# ~/.local/bin/toggle-discord-with-placeholder

# Check if Discord window exists by its unique class
discord_window=$(hyprctl clients -j | jq -r '.[] | select(.class | startswith("chrome-discord.com")) | .address')

if [ -n "$discord_window" ]; then
    # Discord is running - replace it with terminal
    current=$(hyprctl activewindow -j | jq -r '.address')

    # Launch terminal
    alacritty &
    sleep 0.8

    # Close Discord window
    hyprctl dispatch closewindow address:$discord_window

    # Return focus if we weren't on Discord
    if [ "$current" != "$discord_window" ]; then
        hyprctl dispatch focuswindow address:$current
    fi
else
    # Terminal is placeholder - replace with Discord
    current=$(hyprctl activewindow -j | jq -r '.address')

    # Launch Discord PWA
    omarchy-launch-webapp "https://discord.com/channels/@me"
    sleep 0.8  # PWAs can take a moment to open

    # Close the placeholder terminal
    hyprctl dispatch focuswindow address:$current
    hyprctl dispatch killactive
fi

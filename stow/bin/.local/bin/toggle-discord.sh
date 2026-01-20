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
    current=$(hyprctl activewindow -j)
    current_addr=$(echo "$current" | jq -r '.address')
    current_class=$(echo "$current" | jq -r '.class')
    current_title=$(echo "$current" | jq -r '.title')

    # Launch Discord PWA
    omarchy-launch-webapp "https://discord.com/channels/@me"
    sleep 0.8  # PWAs can take a moment to open

    # Only close if current window was an idle terminal
    if [[ "${current_class,,}" =~ (alacritty|kitty|ghostty) ]]; then
        # Skip if terminal is running an interactive program
        if [[ ! "${current_title,,}" =~ (n?vim|nano|emacs|ssh|htop|top|less|man|tmux|claude) ]]; then
            hyprctl dispatch closewindow address:$current_addr
        fi
    fi
fi

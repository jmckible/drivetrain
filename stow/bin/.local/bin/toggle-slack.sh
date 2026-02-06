#!/bin/bash
# ~/.local/bin/toggle-slack-with-placeholder

# Check if Slack window exists by its unique class
slack_window=$(hyprctl clients -j | jq -r '.[] | select(.class | startswith("chrome-app.slack.com")) | .address')

if [ -n "$slack_window" ]; then
    # Slack is running - replace it with terminal
    current=$(hyprctl activewindow -j | jq -r '.address')

    # Launch terminal
    alacritty &
    sleep 0.8

    # Close Slack window
    hyprctl dispatch closewindow address:$slack_window

    # Return focus if we weren't on Slack
    if [ "$current" != "$slack_window" ]; then
        hyprctl dispatch focuswindow address:$current
    fi
else
    # Terminal is placeholder - replace with Slack
    current=$(hyprctl activewindow -j)
    current_addr=$(echo "$current" | jq -r '.address')
    current_class=$(echo "$current" | jq -r '.class')
    current_title=$(echo "$current" | jq -r '.title')

    # Launch Slack PWA
    omarchy-launch-webapp "https://app.slack.com/client/TH2RWF337/CH2CRC89H"
    sleep 0.8  # PWAs can take a moment to open

    # Only close if current window was an idle terminal
    if [[ "${current_class,,}" =~ (alacritty|kitty|ghostty) ]]; then
        # Skip if terminal is running an interactive program
        if [[ ! "${current_title,,}" =~ (n?vim|nano|emacs|ssh|htop|top|less|man|tmux|claude) ]]; then
            hyprctl dispatch closewindow address:$current_addr
        fi
    fi
fi

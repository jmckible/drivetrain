#!/bin/bash

# Install Slack as a webapp using omarchy-webapp-install
# The Slack workspace ID is embedded in the URL

SLACK_WORKSPACE_URL="https://app.slack.com/client/TH2RWF337/CH2CRC89H"
SLACK_ICON_URL="https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/slack.png"

if [[ ! -f ~/.local/share/applications/Slack.desktop ]]; then
    echo -e "${BLUE}▸${RESET} Installing Slack webapp..."
    omarchy-webapp-install "Slack" "$SLACK_WORKSPACE_URL" "$SLACK_ICON_URL"
    echo -e "${GREEN}✓${RESET} Slack webapp installed"
else
    echo -e "${GREEN}✓${RESET} Slack webapp already installed"
fi

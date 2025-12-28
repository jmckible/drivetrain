#!/bin/bash

# Install Claude Code CLI if not already installed
if ! command -v claude &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code
    echo -e "${GREEN}✓${RESET} Claude Code CLI installed"
else
    echo -e "${GREEN}✓${RESET} Claude Code CLI already installed"
fi

# Install OpenCode if not already installed
if ! command -v opencode &> /dev/null; then
    echo -e "${BLUE}▸${RESET} Installing OpenCode..."
    curl -fsSL https://opencode.ai/install | bash
    echo -e "${GREEN}✓${RESET} OpenCode installed"
else
    echo -e "${GREEN}✓${RESET} OpenCode already installed"
fi

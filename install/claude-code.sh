#!/bin/bash

# Install Claude Code CLI if not already installed
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code
else
    echo "Claude Code CLI already installed, skipping"
fi

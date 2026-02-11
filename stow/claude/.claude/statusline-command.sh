#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
model_id=$(echo "$input" | jq -r '.model.id // empty')
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
context_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')
mcp_servers=$(echo "$input" | jq -r '.mcp.servers // empty' 2>/dev/null)
mcp_count=$(echo "$input" | jq -r '.mcp.servers | length // 0' 2>/dev/null)

# Replace home directory with ~
cwd="${cwd/#$HOME/\~}"

# ANSI color codes using printf (Drivetrain palette)
yellow_bg=$(printf '\033[48;2;210;155;64m')
aqua_bg=$(printf '\033[48;2;104;157;106m')
blue_bg=$(printf '\033[48;2;97;175;239m')
bg3_bg=$(printf '\033[48;2;62;68;81m')
bg1_bg=$(printf '\033[48;2;40;44;52m')
white_fg=$(printf '\033[38;2;255;255;255m')
green_fg=$(printf '\033[38;2;43;186;197m')
reset=$(printf '\033[0m')

# Build the status line (left side)
output=""

# Segment 1: Directory (yellow background)
output+="${yellow_bg}${white_fg} ${cwd} ${reset}"

# Segment 2: Git branch and status (aqua background)
if git rev-parse --git-dir > /dev/null 2>&1; then
  export GIT_OPTIONAL_LOCKS=0
  branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  output+="${aqua_bg}${white_fg}  ${branch} "

  # Git status indicators
  git_status=""
  if ! git diff --quiet 2>/dev/null; then
    git_status+=" "
  fi
  if ! git diff --cached --quiet 2>/dev/null; then
    git_status+=""
  fi
  if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
    git_status+="? "
  fi

  [ -n "$git_status" ] && output+="${git_status}"
  output+="${reset}"
fi

# Segment 3: Model name (only if NOT claude-opus-4-6) (blue background)
if [ -n "$model_id" ] && [[ ! "$model_id" =~ claude-opus-4-6 ]]; then
  output+="${blue_bg}${white_fg}  ${model_name} ${reset}"
fi

# Segment 4: Agent name (when present) (bg3 background)
if [ -n "$agent_name" ]; then
  output+="${bg3_bg}${white_fg}  ${agent_name} ${reset}"
fi

# Segment 5: Context remaining (bg3 background)
if [ -n "$context_remaining" ]; then
  output+="${bg3_bg}${white_fg}  ${context_remaining}% remaining ${reset}"
fi

# Segment 6: MCP servers (bg3 background)
if [ -n "$mcp_count" ] && [ "$mcp_count" -gt 0 ]; then
  output+="${bg3_bg}${white_fg}  MCP: ${mcp_count} ${reset}"
fi

# Add fixed spacing before time
output+="     "

# Segment 7: Time (bg1 background)
current_time=$(date +"%-I:%M %p")
output+="${bg1_bg}${white_fg}   ${current_time} ${reset}"

# Line break and character prompt
output+=$'\n'

# Vim mode indicator or default character
if [ "$vim_mode" = "NORMAL" ]; then
  output+="${green_fg}${reset}"
else
  output+="${green_fg}${reset}"
fi

echo -n "$output"

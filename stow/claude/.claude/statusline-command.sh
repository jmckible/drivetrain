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

# ANSI color codes using printf (Drivetrain palette — text only)
yellow_fg=$(printf '\033[38;2;210;155;64m')
aqua_fg=$(printf '\033[38;2;104;157;106m')
blue_fg=$(printf '\033[38;2;97;175;239m')
dim_fg=$(printf '\033[38;2;100;100;110m')
red_fg=$(printf '\033[38;2;204;36;29m')
green_fg=$(printf '\033[38;2;43;186;197m')
reset=$(printf '\033[0m')

# Separator
sep=" ${dim_fg}│${reset} "

# Build the status line (left side)
output=""

# Segment 1: Directory
folder_icon=$(printf '\uf07b')
output+="${yellow_fg}${folder_icon} ${cwd}${reset}"

# Segment 2: Git branch and status
if git rev-parse --git-dir > /dev/null 2>&1; then
  export GIT_OPTIONAL_LOCKS=0
  branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  git_icon=$(printf '\ue0a0')
  output+="${sep}${aqua_fg}${git_icon} ${branch}"

  # Git status indicators
  git_status=""
  if ! git diff --quiet 2>/dev/null; then
    git_status+=" "
  fi
  if ! git diff --cached --quiet 2>/dev/null; then
    git_status+=""
  fi
  if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
    git_status+="?"
  fi

  [ -n "$git_status" ] && output+=" ${yellow_fg}${git_status}"
  output+="${reset}"
fi

# Segment 3: Model name (only if NOT claude-opus-4-6)
if [ -n "$model_id" ] && [[ ! "$model_id" =~ claude-opus-4-6 ]]; then
  output+="${sep}${blue_fg} ${model_name}${reset}"
fi

# Segment 4: Agent name (when present)
if [ -n "$agent_name" ]; then
  output+="${sep}${blue_fg} ${agent_name}${reset}"
fi

# Segment 5: Context remaining (hidden above 30%, color shifts as it depletes)
if [ -n "$context_remaining" ]; then
  ctx=${context_remaining%.*}
  if [ "$ctx" -le 10 ] 2>/dev/null; then
    output+="${sep}${red_fg} ${ctx}%${reset}"
  elif [ "$ctx" -le 30 ] 2>/dev/null; then
    output+="${sep}${yellow_fg} ${ctx}%${reset}"
  fi
fi

# Segment 6: MCP servers
if [ -n "$mcp_count" ] && [ "$mcp_count" -gt 0 ]; then
  output+="${sep}${dim_fg} MCP: ${mcp_count}${reset}"
fi

# Line break and character prompt
output+=$'\n'

# Vim mode indicator or default character
if [ "$vim_mode" = "NORMAL" ]; then
  output+="${green_fg}${reset}"
else
  output+="${green_fg}${reset}"
fi

echo -n "$output"

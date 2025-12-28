# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# Custom functions
function home() {
    cd ~ && clear
}
alias h='home'
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=/home/jmckible/.opencode/bin:$PATH


# New worktree
ga() {
  if [[ -z $1 ]]; then
    echo "Usage: ga [branch name]"
    return 1
  fi

  local branch="$1"
  local base="$(basename "$PWD")"
  local path="../${base}--${branch}"

  git worktree add -b "$branch" "$path"
  mise trust "$path"
  cd "$path"
}

# Remove worktree
gd() {
  if gum confirm "Remove worktree and branch?"; then
    local cwd base branch root

    cwd="$(pwd)"
    worktree="$(basename "$cwd")"

    # split on first `--`
    root="${worktree%%--*}"
    branch="${worktree#*--}"

    # Protect non-worktree
    if [[ $root != $worktree ]]; then
      cd "../$root"
      git worktree remove "$worktree" --force
      git branch -D "$branch"
    fi
  fi
}

alias c='opencode'

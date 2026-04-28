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

# Navigate to ~/dev directories with smart matching
function dev-dir() {
    local dev_dir="$HOME/dev"

    # No argument: cd to ~/dev
    if [[ -z "$1" ]]; then
        cd "$dev_dir"
        return 0
    fi

    # Find matching directories (prefix match)
    local matches=()
    while IFS= read -r dir; do
        matches+=("$dir")
    done < <(find "$dev_dir" -maxdepth 1 -type d -name "$1*" -printf "%f\n" 2>/dev/null | sort)

    # Fall back to subsequence match if no prefix matches
    if [[ ${#matches[@]} -eq 0 ]]; then
        # Build regex: "vv" -> "v.*v", "abc" -> "a.*b.*c"
        local pattern=""
        for (( i=0; i<${#1}; i++ )); do
            [[ -n "$pattern" ]] && pattern+=".*"
            pattern+="${1:$i:1}"
        done

        while IFS= read -r dir; do
            if [[ "$dir" =~ $pattern ]]; then
                matches+=("$dir")
            fi
        done < <(find "$dev_dir" -maxdepth 1 -type d -printf "%f\n" 2>/dev/null | sort)
    fi

    case ${#matches[@]} in
        0)
            echo "No directory matching '$1' found in ~/dev" >&2
            return 1
            ;;
        1)
            # Single match: switch immediately
            cd "$dev_dir/${matches[0]}"
            ;;
        *)
            # Multiple matches: use zoxide score to pick best
            local best_dir=""
            local best_score=0

            for dir in "${matches[@]}"; do
                local full_path="$dev_dir/$dir"
                local score=$(zoxide query --score "$full_path" 2>/dev/null | awk '{print $1}')

                # Default to 0 if no score exists
                score=${score:-0}

                # Compare scores using awk (more portable than bc)
                if awk "BEGIN {exit !($score > $best_score)}"; then
                    best_score=$score
                    best_dir=$dir
                fi
            done

            # If no zoxide scores exist, pick first alphabetically
            if [[ -z "$best_dir" ]]; then
                best_dir="${matches[0]}"
            fi

            cd "$dev_dir/$best_dir"
            ;;
    esac
}

# Bash completion for dev-dir
_dev_dir_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local dev_dir="$HOME/dev"

    if [[ -d "$dev_dir" ]]; then
        COMPREPLY=( $(compgen -W "$(find "$dev_dir" -maxdepth 1 -type d -printf "%f\n" 2>/dev/null | grep -v '^dev$')" -- "$cur") )
    fi
}

complete -F _dev_dir_completion dev-dir
complete -F _dev_dir_completion d

# Alias for quick access
alias d='dev-dir'

export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=/home/jmckible/.opencode/bin:$PATH

alias c='claude'
alias cc='CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=true claude'
pcc() { if [ -f .env.production ]; then source .env.production && cc; else cc; fi; }

# Tmux Claude layout: top split (cc left, shell right), terminal bottom
tdc() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdc."; return 1; }

  local current_dir="${PWD}"
  local top_pane="$TMUX_PANE"

  tmux rename-window -t "$top_pane" "$(basename "$current_dir")"

  # Split bottom 15%
  tmux split-window -v -p 15 -t "$top_pane" -c "$current_dir"

  # Split top pane horizontally - right 50%
  local right_pane=$(tmux split-window -h -p 50 -t "$top_pane" -c "$current_dir" -P -F '#{pane_id}')

  # Run cc in the left (original) pane
  tmux send-keys -t "$top_pane" "cc" C-m

  # Focus the left pane
  tmux select-pane -t "$top_pane"
}

# Vocal worktree functions (always available)
[[ -f ~/dev/vocal/bin/worktree-functions.sh ]] && source ~/dev/vocal/bin/worktree-functions.sh

# Parallel test shortcuts
alias pspec="PARALLEL_TEST_PROCESSORS=4 bundle exec rake parallel:spec"

# OpenClaw — see ~/.local/bin/oc


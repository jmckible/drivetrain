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

alias c='opencode'

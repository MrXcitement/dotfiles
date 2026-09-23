# chezmoi.sh --- Configure the chezmoi dotfile management system
# Mike Barker <mike@thebarkers.com>
# Created: September 23rd, 2026
# Updated:

# Description:
# Configure the chezmoi command
# https://www.chezmoi.io/

# Code:
alias cm=chezmoi

# Is the shell interactive?
if [[ $- == *i* ]]; then
    chezmoi update >/dev/null
    # Are there any chezmoi changes?
    if [[ $(chezmoi status) ]]; then
        # Show the chezmoi status
        echo "Chezmoi status:"
        chezmoi status
    fi
fi

# eza.sh --- Configure the eza command, a replacement for 'ls'
# Mike Barker <mike@thebarkers.com>
# Created: September 23rd, 2026
# Updated:

# Description:
# Configure aliases to eza including replacing the ls command.
# https://github.com/eza-community/eza

# Code:
alias l='eza --git-ignore'
alias la='eza -lbhHigUmuSa'
alias ls='eza'
alias ll='eza --all --header --long'
alias llm='eza --all --header --long --sort=modified'
alias lt='eza --tree'
alias lx='eza -lbhHigUmuSa@'
alias tree='eza --tree'

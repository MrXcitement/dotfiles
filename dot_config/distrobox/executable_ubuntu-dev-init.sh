#!/bin/bash
set -e

# Update package list
sudo apt update
sudo apt upgrade -y

# Install base development tools
sudo apt install -y build-essential

# Version control and utilities
sudo apt install -y git tmux htop

# Modern CLI replacements
sudo apt install -y bat eza fzf ripgrep zoxide

# Network tools
sudo apt install -y curl jq httpie wget

# Text editors and IDEs
sudo apt install -y neovim

# Help manage the apt repositories you install software from
# needed for add-apt-repository command
sudo apt install -y software-properties-common

# mise-en-place
# https://mise.jdx.dev/installing-mise.html
sudo add-apt-repository -y ppa:jdxcode/mise
sudo apt update
sudo apt install -y mise

# Shell setup
sudo apt install -y starship zsh
sudo chsh -s $(which zsh) mike

# Mise, install global tools
mise use -g bat chezmoi gh glab uv

#!/bin/bash
set -e

# Update package list
sudo pacman -Syu

# Install base development tools
sudo pacman -S --needed --noconfirm base-devel

# Version control and utilities
sudo pacman -S --needed --noconfirm git tmux htop ripgrep fd bat fzf eza zoxide

# Network tools
sudo pacman -S --needed --noconfirm curl wget jq httpie

# Text editors and IDEs
sudo pacman -S --needed --noconfirm neovim
sudo pacman -S --needed --noconfirm emacs-wayland

# Dev environment tools
sudo pacman -S --needed --noconfirm mise

# Shell setup
sudo pacman -S --needed --noconfirm zsh starship
sudo chsh -s $(which zsh) mike

# Chezmoi and my dotfiles
#sudo pacman -S --needed --noconfirm chezmoi

# Setup mise global tools
mise use -g bat chezmoi gh glab uv

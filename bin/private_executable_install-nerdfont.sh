#!/usr/bin/env bash
# install-nerdfont --- Install a specified nerd font

# Mike Barker <mike@thebarkers.com>
# Created: December 5th, 2025

if [ "$#" -ne 1 ]; then
    echo "Usage: $(basename "$0") <Font Name> [Font Version]"
    exit 1
fi

font_name="$1"
font_ver="${2:-v3.4.0}"

wget -P "$HOME/Downloads" "https://github.com/ryanoasis/nerd-fonts/releases/download/${font_ver}/${font_name}.tar.xz"

mkdir -p "$HOME/Downloads/${font_name}"
tar -xvf "$HOME/Downloads/${font_name}.tar.xz" -C "$HOME/Downloads/${font_name}"

mkdir -p "$HOME/.local/share/fonts"
cp -v "$HOME/Downloads/${font_name}/"*.ttf "$HOME/.local/share/fonts/"

fc-cache -vf "$HOME/.local/share/fonts/"


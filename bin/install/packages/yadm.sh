#!/bin/bash
pkg="yadm"
if omarchy-pkg-missing $pkg; then
    echo "Installing YADM (Yet Another Dotfiles Manager)..."
    pacman -S --noconfirm $pkg
fi

#!/bin/bash
pkg="yarn"
if omarchy-pkg-missing $pkg; then
    echo "Installing Yarn package manager..."
    sudo pacman -S --noconfirm $pkg
fi

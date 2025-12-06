#!/bin/bash
pkg="pandoc"
if omarchy-pkg-missing $pkg; then
    echo "Installing Pandoc document converter..."
    sudo pacman -S --noconfirm $pkg
fi
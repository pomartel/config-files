#!/bin/bash
pkg="man-pages-fr"
if omarchy-pkg-missing $pkg; then
    echo "Installing Man Pages French translation..."
    sudo pacman -S --noconfirm $pkg
fi

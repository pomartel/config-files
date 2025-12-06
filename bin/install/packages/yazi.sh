#!/bin/bash
pkg="yazi"
if omarchy-pkg-missing $pkg; then
    echo "Installing Yazi file mananger..."
    pacman -S --noconfirm $pkg
fi

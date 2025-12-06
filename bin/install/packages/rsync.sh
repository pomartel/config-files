#!/bin/bash
pkg="rsync"
if omarchy-pkg-missing $pkg; then
    echo "Installing rsync file synchronization tool..."
    pacman -S --noconfirm $pkg
fi

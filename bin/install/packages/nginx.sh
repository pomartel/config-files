#!/bin/bash
pkg="nginx mailcap"
if omarchy-pkg-missing $pkg; then
    echo "Installing Nginx web server..."
    sudo pacman -S --noconfirm $pkg
    sudo systemctl enable --now nginx
fi
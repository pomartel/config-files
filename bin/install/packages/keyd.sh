#!/bin/bash
pkg="keyd"
if omarchy-pkg-missing $pkg; then
    echo "Installing keyd keyboard remapper..."
    sudo pacman -S --noconfirm $pkg
    sudo rm /etc/keyd/default.conf
    sudo ln -s ~/.config/keyd/default.conf /etc/keyd/default.conf
    sudo systemctl enable --now keyd
fi
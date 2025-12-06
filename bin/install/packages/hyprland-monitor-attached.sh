#!/bin/bash
pkg="hyprland-monitor-attached"
if omarchy-pkg-missing $pkg; then
    echo "Installing Hyprland monitor attached..."
    yay -S --noconfirm $pkg
fi

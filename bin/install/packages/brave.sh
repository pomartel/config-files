#!/bin/bash
pkg="brave-bin"
if omarchy-pkg-missing $pkg; then
    echo "Installing Brave browser..."
    yay -S --noconfirm $pkg
fi
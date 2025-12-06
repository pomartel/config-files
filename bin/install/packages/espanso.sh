#!/bin/bash
pkg="espanso-wayland"
if omarchy-pkg-missing $pkg; then
    echo "Installing Espanso text expander..."
    yay -S --noconfirm $pkg
    espanso service register
    espanso start
fi
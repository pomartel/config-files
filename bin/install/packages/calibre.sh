#!/bin/bash
pkg="calibre-bin"
if omarchy-pkg-missing $pkg; then
    echo "Installing Calibre eBook management software..."
    yay -S --noconfirm $pkg
fi
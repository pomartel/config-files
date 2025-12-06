#!/bin/bash
pkg="mkcert nss"
if omarchy-pkg-missing $pkg; then
    echo "Installing mkcert for local SSL certificate generation..."
    # Used to create a local SSL certificate for development purposes
    sudo pacman -S --noconfirm $pkg
fi
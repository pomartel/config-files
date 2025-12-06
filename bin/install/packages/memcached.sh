#!/bin/bash
pkg="memcached"
if omarchy-pkg-missing $pkg; then
    echo "Installing Memcached..."
    pacman -S --noconfirm $pkg
fi

#!/bin/bash
pkg="pandoc"
if omarchy-pkg-missing $pkg; then
    echo "Installing PostgreSQL database server..."
    pacman -S --noconfirm $pkg
    sudo -iu postgres initdb -D /var/lib/postgres/data
    sudo systemctl enable --now postgresql
    sudo -iu postgres createuser --superuser po
fi

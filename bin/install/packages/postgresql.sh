#!/bin/bash
echo "Installing PostgreSQL database server..."

pacman -S --noconfirm postgresql

sudo -iu postgres initdb -D /var/lib/postgres/data
sudo systemctl enable --now postgresql
sudo -iu postgres createuser --superuser po

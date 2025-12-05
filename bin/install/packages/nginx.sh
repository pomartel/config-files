#!/bin/bash
echo "Installing Nginx web server..."

sudo pacman -S --noconfirm nginx
sudo pacman -S mailcap

sudo systemctl enable --now nginx


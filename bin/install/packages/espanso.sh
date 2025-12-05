#!/bin/bash
echo "Installing Espanso text expander..."

yay -S --noconfirm espanso-wayland
espanso service register
espanso start

#!/bin/bash

SUDOERS_CONFIG_FILE="$HOME/.config/sudoers.d/sudo-po"
SUDOERS_CONFIG_SYMLINK="/etc/sudoers.d/sudo-po"

if [ ! -f "$SUDOERS_CONFIG_FILE" ]; then
    echo "Sudoers config $SUDOERS_CONFIG_FILE not found; cannot set up symlink." >&2
    exit 1
fi

echo "Setting up symlink for sudoers rules..."

sudo ln -sfn "$SUDOERS_CONFIG_FILE" "$SUDOERS_CONFIG_SYMLINK"
#!/bin/bash
if omarchy-pkg-missing keyd; then
    echo "keyd is not installed; cannot set up symlink." >&2
    exit 1
fi

KEYD_CONFIG_FILE="$HOME/.config/keyd/default.conf"
KEYD_CONFIG_SYMLINK="/etc/keyd/default.conf"

if [ ! -f "$KEYD_CONFIG_FILE" ]; then
    echo "keyd config $KEYD_CONFIG_FILE not found; cannot set up symlink." >&2
    exit 1
fi

echo "Setting up symlink for keyd config..."

sudo rm "$KEYD_CONFIG_SYMLINK"
sudo ln -sfn "$KEYD_CONFIG_FILE" "$KEYD_CONFIG_SYMLINK"
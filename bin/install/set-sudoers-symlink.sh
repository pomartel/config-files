#!/bin/bash
if [ ! -f "$HOME/.config/sudoers.d/sudo-po" ]; then
    echo "Sudoers config $HOME/.config/sudoers.d/sudo-po not found; cannot set up symlink." >&2
    exit 1
fi

echo "Setting up symlink for sudoers rules..."

sudo ln -sfn "$HOME/.config/sudoers.d/sudo-po" /etc/sudoers.d/sudo-po
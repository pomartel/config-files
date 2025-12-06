#!/bin/bash
if omarchy-pkg-missing keyd; then
    echo "keyd is not installed; cannot set up symlink." >&2
    exit 1
fi

if [ ! -f "$HOME/.config/keyd/default.conf" ]; then
    echo "keyd config $HOME/.config/keyd/default.conf not found; cannot set up symlink." >&2
    exit 1
fi

echo "Setting up symlink for keyd config..."
sudo rm /etc/keyd/default.conf
sudo ln -sfn "$HOME/.config/keyd/default.conf" /etc/keyd/default.conf
sudo systemctl restart keyd
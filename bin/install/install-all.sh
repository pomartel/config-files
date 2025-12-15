#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <install-target>" >&2
    echo "Where <install-target> is 'home' or 'school'." >&2
    exit 1
fi

export INSTALL_TARGET="$1"

if [ "$INSTALL_TARGET" != "home" ] && [ "$INSTALL_TARGET" != "school" ]; then
    echo "ERROR: Invalid install target: $INSTALL_TARGET" >&2
    exit 1
fi

# Verify SSH keys exist in ~/.ssh before proceeding
shopt -s nullglob
ssh_keys=("$HOME/.ssh"/id_*)
if [ ${#ssh_keys[@]} -eq 0 ]; then
    echo "ERROR: No SSH keys found in $HOME/.ssh." >&2
    exit 1
fi

./set-locale.sh
./install-packages.sh
./init-postgresql.sh
./set-keyd-symlink.sh
./copy-sudoers-rules.sh
./clone-git-projects.sh
./remove-default-apps.sh
./set-theme-and-font.sh
./set-power-profile-rule.sh

./configure-hibernation-swap-file.sh
./configure-hibernation-rules.sh

echo "All install scripts completed."

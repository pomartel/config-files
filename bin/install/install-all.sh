#!/usr/bin/env bash

# If the computer name is omarchy-home, set the INSTALL_TARGET to home. if set to omarchy-school, set to school. Otherwise, exit with an error.
if [ "$HOSTNAME" == "home-omarchy" ]; then
    INSTALL_TARGET="home"
elif [ "$HOSTNAME" == "school-omarchy" ]; then
    INSTALL_TARGET="school"
else
    echo "ERROR: Unknown hostname '$HOSTNAME'. Cannot determine INSTALL_TARGET." >&2
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
./set-default-font.sh
./configure-tlp.sh
./configure-networking.sh

./configure-hibernation-swap-file.sh
./configure-hibernation-rules.sh

echo "All install scripts completed."

#!/usr/bin/env bash

# Verify SSH keys exist in ~/.ssh before proceeding
shopt -s nullglob
ssh_keys=("$HOME/.ssh"/id_*)
if [ ${#ssh_keys[@]} -eq 0 ]; then
	echo "ERROR: No SSH keys found in $HOME/.ssh." >&2
	exit 1
fi

# Prompt for installation target (home or school)
read -p "Install target (home/school) : " INSTALL_TARGET
if [ "$INSTALL_TARGET" != "home" ] && [ "$INSTALL_TARGET" != "school" ]; then
	echo "ERROR: Invalid install target: $INSTALL_TARGET" >&2
	exit 1
fi

export INSTALL_TARGET
echo "Installation target set to: $INSTALL_TARGET"

./set-locale.sh
./install-packages.sh
./init-yadm.sh
./init-postgresql.sh
./set-keyd-symlink.sh
./set-sudoers-symlink.sh
./clone-git-projects.sh
./remove-default-apps.sh

echo "All install scripts completed."


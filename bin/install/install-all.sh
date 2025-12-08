#!/usr/bin/env bash

# Verify SSH keys exist in ~/.ssh before proceeding
shopt -s nullglob
ssh_keys=("$HOME/.ssh"/id_* "$HOME/.ssh"/*.pem "$HOME/.ssh"/*.key "$HOME/.ssh"/*.pub)
shopt -u nullglob
if [ ${#ssh_keys[@]} -eq 0 ]; then
	echo "ERROR: No SSH keys found in $HOME/.ssh. Please add your private key (e.g. id_rsa or id_ed25519) and try again." >&2
	exit 1
fi

# Prompt for installation target (home or school)
read -p "Install target (home/school) : " INSTALL_TARGET
if [ -z "$INSTALL_TARGET" ]; then
	INSTALL_TARGET=home
fi

export INSTALL_TARGET
echo "Installation target set to: $INSTALL_TARGET"

./set-locale.sh
./install-packages.sh
./init-yadm.sh
./init-postgresql.sh
./set-keyd-symlink.sh
./clone-git-projects.sh
./remove-default-apps.sh

echo "All install scripts completed."


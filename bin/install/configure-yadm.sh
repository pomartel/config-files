#!/usr/bin/env bash
set -euo pipefail

# Usage: configure-yadm.sh <git-repo-url>
# This script will clone the given git repo and use yadm (preferred)
# to install dotfiles, forcing replacement of existing files.
# It creates a small backup of common config files before replacing.

REPO="${1:-}"
if [ -z "$REPO" ]; then
	echo "Usage: $0 <git-repo-url>" >&2
	exit 1
fi

BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "Backing up existing common config files to $BACKUP_DIR"
for f in .bashrc .zshrc .profile .config .vimrc .gitconfig; do
	if [ -e "$HOME/$f" ]; then
		mv "$HOME/$f" "$BACKUP_DIR/" || true
	fi
done

if command -v yadm >/dev/null 2>&1; then
	echo "yadm found — attempting to clone and force checkout"
	# Prefer yadm clone if it supports --force; otherwise use a bare git checkout
	if yadm clone --help 2>&1 | grep -q -- "--force"; then
		yadm clone --force "$REPO"
	else
		# Fallback: perform a bare git clone and force checkout into $HOME
		tmprepo=$(mktemp -d)
		git clone --bare "$REPO" "$tmprepo"
		git --git-dir="$tmprepo" --work-tree="$HOME" checkout -f || true
		git --git-dir="$tmprepo" --work-tree="$HOME" reset --hard || true
		rm -rf "$tmprepo"
	fi
else
	echo "yadm not found — using bare git checkout as fallback"
	tmprepo=$(mktemp -d)
	git clone --bare "$REPO" "$tmprepo"
	git --git-dir="$tmprepo" --work-tree="$HOME" checkout -f || true
	git --git-dir="$tmprepo" --work-tree="$HOME" reset --hard || true
	rm -rf "$tmprepo"
fi

echo "Dotfiles deployment complete. Backed up files are in: $BACKUP_DIR"


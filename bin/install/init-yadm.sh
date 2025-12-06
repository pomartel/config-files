#!/usr/bin/env bash
#
# init-yadm
#
# Clone a yadm repo and force local dotfiles to match it.
# All conflicting local files will be discarded.
#
# Usage:
#   init-yadm <repo_url>

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: init-yadm <repo_url>" >&2
  exit 1
fi

REPO_URL="$1"

if ! command -v yadm >/dev/null 2>&1; then
  echo "ERROR: yadm is not installed." >&2
  exit 1
fi

REPO_DIR="$HOME/.local/share/yadm/repo.git"

# Remove any existing yadm Git repo so clone starts clean
if [[ -d "$REPO_DIR" ]]; then
  echo "Removing existing yadm repository at $REPO_DIR"
  rm -rf "$REPO_DIR"
fi

echo "Cloning yadm repository: $REPO_URL"
yadm clone "$REPO_URL"

echo "Force-resetting work-tree (discarding local conflicting files)..."
yadm reset --hard

echo "Done. Local dotfiles now exactly match the yadm repo."

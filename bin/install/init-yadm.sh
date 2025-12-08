#!/usr/bin/bash

REPO_URL="git@github.com:pomartel/config-files.git"

if ! command -v yadm >/dev/null 2>&1; then
  echo "ERROR: yadm is not installed." >&2
  exit 1
fi

REPO_DIR="$HOME/.local/share/yadm/repo.git"

# Only clone if the repo directory doesn't already exist
if [[ ! -d "$REPO_DIR" ]]; then
  echo "Cloning yadm repository: $REPO_URL"
  yadm clone "$REPO_URL"

  echo "Force-resetting work-tree (discarding local conflicting files)..."
  yadm reset --hard

  echo "Done. Local dotfiles now exactly match the yadm repo."
else
  echo "Yadm repository already exists at $REPO_DIR. Skipping clone."
fi
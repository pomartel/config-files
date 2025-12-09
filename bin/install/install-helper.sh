#!/bin/bash
#
# install-helper.sh
# Provides common installation utilities for package scripts.
#

# install-pkg <package_name> <description> [post_install_command]
# Installs a package if it's missing using omarchy-pkg-missing check.
# If post_install_command is provided, it will be executed after installation.
install-pkg() {
  local pkg="$1"
  local description="${2:-Package}"
  local post_install="${3:-}"

  if omarchy-pkg-missing $pkg; then
    echo "Installing $description..."
    sudo pacman -S --noconfirm $pkg

    if [ -n "$post_install" ]; then
      eval "$post_install"
    fi
  fi
}

# install-pkg-yay <package_name> <description> [post_install_command]
# Installs a package using yay if it's missing.
install-pkg-yay() {
  local pkg="$1"
  local description="${2:-Package}"
  local post_install="${3:-}"

  if omarchy-pkg-missing $pkg; then
    echo "Installing $description..."
    yay -S --noconfirm $pkg

    if [ -n "$post_install" ]; then
      eval "$post_install"
    fi
  fi
}

webapp-missing() {
  local app_name="$1"
  local app_dir="$HOME/.local/share/applications/$app_name.desktop"
  [ ! -e "$app_dir" ]
}


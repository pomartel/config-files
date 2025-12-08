#!/bin/bash
source ./install-helper.sh

remove-webapp-if-exists() {
    local app_name="$1"
    if ! webapp-missing "$app_name"; then
        omarchy-webapp-remove "$app_name"
    fi
}

remove-webapp-if-exists "HEY"
remove-webapp-if-exists "Basecamp"
remove-webapp-if-exists "Google Photos"
remove-webapp-if-exists "Google Messages"
remove-webapp-if-exists "X"
remove-webapp-if-exists "Figma"
remove-webapp-if-exists "Discord"
remove-webapp-if-exists "Zoom"
remove-webapp-if-exists "Fizzy"

omarchy-pkg-drop "signal-desktop"

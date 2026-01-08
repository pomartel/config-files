#!/bin/bash
source ./install-helper.sh

if pacman -Q | grep -q power-profiles-daemon; then
    omarchy-pkg-drop "power-profiles-daemon"
fi

install-pkg "tlp" "TLP Power Management" "sudo systemctl enable tlp.service"
install-pkg "tlp-pd" "TLP Power Management - Power Profiles Daemon" "sudo systemctl enable --now tlp-pd.service"

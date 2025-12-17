#!/bin/bash
source ./install-helper.sh
install-pkg "networkmanager network-manager-applet nm-connection-editor" "NetworkManager daemon" "sudo systemctl enable --now NetworkManager.service"

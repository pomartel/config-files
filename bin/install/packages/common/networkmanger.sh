#!/bin/bash
source ./install-helper.sh
install-pkg "networkmanager" "NetworkManager daemon" "sudo systemctl enable --now NetworkManager.service"

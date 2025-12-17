#!/bin/bash
source ./install-helper.sh
install-pkg "tlp" "TLP Power Management" "sudo systemctl enable tlp.service"
install-pkg "tlp-pd" "TLP Power Management - Power Profiles Daemon" "sudo systemctl enable --now tlp-pd.service"

#!/bin/bash
source ./install-helper.sh
install-pkg "keyd" "keyd keyboard remapper" "sudo systemctl enable --now keyd"
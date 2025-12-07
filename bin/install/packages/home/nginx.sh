#!/bin/bash
source ./install-helper.sh
install-pkg "nginx mailcap" "Nginx web server" "sudo systemctl enable --now nginx"
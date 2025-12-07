#!/bin/bash
source ./install-helper.sh
install-pkg "postgresql" "PostgreSQL database server" "sudo systemctl enable --now postgresql"

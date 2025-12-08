#!/bin/bash
if [[ "$(locale | grep LANG=)" != "LANG=fr_CA.UTF-8" ]]; then
    echo "Setting system locale to fr_CA.UTF-8..."
    sudo localectl set-locale LANG=fr_CA.UTF-8
fi
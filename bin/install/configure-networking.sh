#!/bin/bash

# Only add the conf if the file doesn't already exist
wifi_backend_conf="/etc/NetworkManager/conf.d/wifi_backend.conf"
if [ ! -f "$wifi_backend_conf" ]; then
    echo "Configuring NetworkManager to use iwd as the Wi-Fi backend..."
    printf "[device]\nwifi.backend=iwd\n" | sudo tee "$wifi_backend_conf" >/dev/null
fi

if systemctl is-active --quiet systemd-networkd; then
    echo "Disabling systemd-networkd to avoid conflicts with NetworkManager..."
    systemctl disable --now systemd-networkd
fi

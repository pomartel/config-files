#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME="disable-acpi-wakeup.service"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}"

SERVICE_CONTENT='[Unit]
Description=Disable unwanted ACPI wakeup sources
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "\
echo XHCI > /proc/acpi/wakeup; \
echo RP05 > /proc/acpi/wakeup; \
echo TXHC > /proc/acpi/wakeup; \
echo TDM0 > /proc/acpi/wakeup; \
echo TDM1 > /proc/acpi/wakeup; \
echo TRP0 > /proc/acpi/wakeup; \
echo TRP2 > /proc/acpi/wakeup \
"

[Install]
WantedBy=multi-user.target
'

# Create or update service file only if needed
if ! sudo test -f "$SERVICE_PATH"; then
    echo "$SERVICE_CONTENT" | sudo tee "$SERVICE_PATH" >/dev/null
    sudo systemctl daemon-reload
fi

# Enable service if not already enabled
if ! systemctl is-enabled --quiet "$SERVICE_NAME"; then
    sudo systemctl enable "$SERVICE_NAME" >/dev/null

    # Apply immediately
    sudo systemctl start "$SERVICE_NAME"
fi

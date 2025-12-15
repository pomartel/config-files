#!/usr/bin/env bash

RULES_DIR="/etc/udev/rules.d"
RULE_FILE="$RULES_DIR/99-power-profile.rules"

RULE_CONTENT='SUBSYSTEM=="power_supply", KERNEL=="AC*", ACTION=="change", RUN+="/home/po/bin/power-profile-ac-bat.sh"'

# Exit if rule already exists with same content
if [[ -f "$RULE_FILE" ]] && sudo grep -Fxq "$RULE_CONTENT" "$RULE_FILE"; then
    exit 0
fi

# Create rules directory if needed
sudo mkdir -p "$RULES_DIR"

# Write rule file
echo "$RULE_CONTENT" | sudo tee "$RULE_FILE" >/dev/null

# Reload udev rules and trigger
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=power_supply

echo "Udev rule installed at $RULE_FILE"

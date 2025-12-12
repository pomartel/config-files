#!/bin/bash

set -e

# --- logind (lid switch) ---
LOGIND_CONF_DIR="/etc/systemd/logind.conf.d"
LOGIND_CONF_FILE="$LOGIND_CONF_DIR/suspend-then-hibernate.conf"

if [[ ! -f "$LOGIND_CONF_FILE" ]]; then
    sudo mkdir -p "$LOGIND_CONF_DIR"

    sudo tee "$LOGIND_CONF_FILE" >/dev/null <<'EOF'
[Login]
HandleLidSwitch=suspend-then-hibernate
EOF

    sudo systemctl restart systemd-logind
    echo "Created $LOGIND_CONF_FILE and restarted systemd-logind"
fi

# --- sleep (hibernate delay) ---
SLEEP_CONF_DIR="/etc/systemd/sleep.conf.d"
SLEEP_CONF_FILE="$SLEEP_CONF_DIR/suspend-then-hibernate.conf"

if [[ ! -f "$SLEEP_CONF_FILE" ]]; then
    sudo mkdir -p "$SLEEP_CONF_DIR"

    sudo tee "$SLEEP_CONF_FILE" >/dev/null <<'EOF'
[Sleep]
AllowSuspendThenHibernate=yes
HibernateDelaySec=24h
EOF

    echo "Created $SLEEP_CONF_FILE"
fi

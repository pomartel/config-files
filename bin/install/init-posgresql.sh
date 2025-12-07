#!/bin/bash

if ! omarchy-pkg-missing "postgresql"; then
    echo "Initializing PostgreSQL database and creating superuser 'po'..."
    sudo -iu postgres initdb -D /var/lib/postgres/data
    sudo -iu postgres createuser --superuser po
fi
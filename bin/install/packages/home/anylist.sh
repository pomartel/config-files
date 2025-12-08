#!/bin/bash
source ./install-helper.sh
if webapp-missing "Anylist"; then
    echo "Installing AnyList webapp..."
    omarchy-webapp-install Anylist https://anylist.com/web https://www.anylist.com/static/img/favicon@2x.png
fi
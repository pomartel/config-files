#!/usr/bin/env bash

LAPTOP="eDP-1"
HDMI_RES="1920x1080@60"

if hyprctl monitors | grep -q "monitor mirrors"; then
    hyprctl keyword monitor "$LAPTOP,$HDMI_RES,auto,2"
fi

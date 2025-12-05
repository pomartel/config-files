#!/usr/bin/env bash

LAPTOP="eDP-1"
HDMI="HDMI-A-1"
HDMI_RES="1920x1080@60"

if hyprctl monitors | grep -q "monitor mirrors"; then
    hyprctl keyword monitor "$HDMI,disable"
    hyprctl keyword monitor "$LAPTOP,highr,auto,2"
elif hyprctl monitors all | grep -q "$HDMI"; then
    hyprctl keyword monitor "$HDMI,enable"
    hyprctl keyword monitor "$HDMI,preferred,auto,auto,mirror,$LAPTOP"
    hyprctl keyword monitor "$LAPTOP,$HDMI_RES,auto,2"
else
    notify-send "No HDMI monitor detected"
fi

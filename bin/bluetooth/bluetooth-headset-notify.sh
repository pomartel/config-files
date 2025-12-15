#!/usr/bin/env bash

# Monitor udev input events directly
udevadm monitor --udev --subsystem-match=input --property | while read -r line; do

    # 1. Capture the action from the 'UDEV' header line
    if [[ "$line" =~ ^UDEV.*\ ([[:alpha:]]+)\ .*/devices/ ]]; then
        action="${BASH_REMATCH[1]}"

    # 2. Capture the device name, filtering specifically for AVRCP devices
    #    Regex matches: NAME="<captured_group> (AVRCP)"
    elif [[ "$line" =~ ^NAME=\"(.*)[[:space:]]*\(AVRCP\)\"$ ]]; then
        device_name="${BASH_REMATCH[1]}"

        # Map action to state
        case "$action" in
        add) state="Connected" ;;
        remove) state="Disconnected" ;;
        *) continue ;; # Skip other actions (change, etc.)
        esac

        notify-send "󰋋  $device_name" "$state"
    fi
done

#!/bin/bash
set -e

# Adjust AC name if needed (AC, ACAD, AC0, ADP0)
AC_PATH="/sys/class/power_supply/AC/online"

if [[ -f "$AC_PATH" ]] && [[ "$(cat "$AC_PATH")" -eq 1 ]]; then
    /usr/bin/powerprofilesctl set performance
else
    /usr/bin/powerprofilesctl set balanced
fi

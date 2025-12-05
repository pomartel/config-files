#!/bin/sh

# called from : /etc/acpi/events/lid-open
# Install acpid
# sudo pacman -S acpid
# sudo systemctl enable --now acpid.service

# Force the GPU to reinitialize its pipeline
# state=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')

# if [ "$state" = "open" ]; then
  chvt 3
  sleep 0.7
  chvt 1
# fi

notify-send "screen reset"

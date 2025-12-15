#!/bin/bash

# Creates a swap file in the btrfs subvolume, adds the swap file to /etc/fstab, and adds a resume hook to mkinitcpio.

SWAP_SUBVOLUME="/swap"
if ! sudo btrfs subvolume show $SWAP_SUBVOLUME &>/dev/null; then
    echo 'Creating Btrfs subvolume'
    sudo btrfs subvolume create "$SWAP_SUBVOLUME"
fi

SWAP_FILE="$SWAP_SUBVOLUME/swapfile"
if ! sudo swaplabel "$SWAP_FILE" &>/dev/null; then
    echo 'Creating swapfile in Btrfs subvolume'
    MEM_TOTAL_KB="$(grep MemTotal /proc/meminfo | awk '{print $2}')k"
    sudo btrfs filesystem mkswapfile -s "$MEM_TOTAL_KB" "$SWAP_FILE"
fi

if ! grep -Fq "$SWAP_FILE" /etc/fstab; then
    echo "Adding swapfile to /etc/fstab"
    sudo cp -a /etc/fstab "/etc/fstab.$(date +%Y%m%d%H%M%S).back"
    printf "\n# Btrfs swapfile for system hibernation\n%s none swap defaults,pri=0 0 0\n" "$SWAP_FILE" | sudo tee -a /etc/fstab >/dev/null
fi

MKINITCPIO_CONF="/etc/mkinitcpio.conf.d/omarchy_resume.conf"
HOOKS_LINE='HOOKS+=(resume)'

if [ ! -f "$MKINITCPIO_CONF" ] || ! grep -q "^${HOOKS_LINE}$" "$MKINITCPIO_CONF"; then
    echo "Enabling swap on $SWAP_FILE with priority 0"
    sudo swapon -p 0 "$SWAP_FILE"

    sudo mkdir -p /etc/mkinitcpio.conf.d

    echo "Adding resume hooks to $MKINITCPIO_CONF"
    echo "$HOOKS_LINE" | sudo tee -a "$MKINITCPIO_CONF" >/dev/null

    echo "Regenerating initramfs..."
    sudo limine-mkinitcpio
    echo "Hibernation enabled"
fi

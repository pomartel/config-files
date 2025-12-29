# Remove power-profiles-daemon if installed in favor of TLP
if systemctl is-enabled power-profiles-daemon.service &>/dev/null; then
    sudo systemctl stop power-profiles-daemon.service
    sudo systemctl disable power-profiles-daemon.service
    omarchy-pkg-drop power-profiles-deamon
fi

# Check if the systemd-rfkill service and socket are already masked
if systemctl is-enabled systemd-rfkill.service &>/dev/null; then
    echo "Masking systemd-rfkill service and socket..."
    sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
fi

# Check if the symbolic link exists before creating it
if [ ! -L /usr/local/bin/powerprofilesctl ]; then
    echo "Creating symbolic link for powerprofilesctl..."
    sudo ln -s /usr/bin/tlpctl /usr/local/bin/powerprofilesctl
fi

# Set symlinks for all files in ~/.config/tlp/*.conf to /etc/tlp.d/ only if the symlink doesn't already exist
for config_file in "$HOME/.config/tlp/"*.conf; do
    config_filename=$(basename "$config_file")
    symlink_path="/etc/tlp.d/$config_filename"
    if [ ! -L "$symlink_path" ]; then
        echo "Creating symlink for $config_filename in /etc/tlp.d/..."
        sudo ln -s "$config_file" "$symlink_path"
    fi
done

# Start TLP only if it is not already active
if ! systemctl is-active tlp &>/dev/null; then
    echo "Starting TLP..."
    sudo tlp start
fi

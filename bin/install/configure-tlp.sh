# Remove power-profiles-daemon if installed in favor of TLP
if systemctl is-enabled power-profiles-daemon.service &>/dev/null; then
    sudo systemctl stop power-profiles-daemon.service
    sudo systemctl disable power-profiles-daemon.service
    omarchy-pkg-drop power-profiles-daemon
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

# Start TLP only if it is not already active
if ! systemctl is-active tlp &>/dev/null; then
    echo "Starting TLP..."
    sudo tlp start
fi

if omarchy-cmd-present voxtype && ! systemctl --user is-active --quiet voxtype; then
    voxtype setup --no-post-install
    sudo voxtype setup gpu --enable
    voxtype setup systemd
    voxtype setup model

    omarchy-restart-waybar
fi

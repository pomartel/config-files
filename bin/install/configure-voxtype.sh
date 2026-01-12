if omarchy-cmd-present voxtype && ! systemctl --user is-active --quiet voxtype; then
    voxtype setup --no-post-install
    voxtype setup systemd
    voxtype setup --download --model large-v3-turbo --quiet
    sudo voxtype setup gpu --enable

    omarchy-restart-waybar
fi

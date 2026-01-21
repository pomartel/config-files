omarchy-pkg-aur-add onedrive-abraunegg

if ! systemctl is-active --quiet --user onedrive; then
    systemctl enable --now --user onedrive
fi

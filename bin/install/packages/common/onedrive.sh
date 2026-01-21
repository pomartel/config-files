omarchy-pkg-aur-add onedrive-abraunegg

if ! systemctl is-active --quiet --user onedrive; then
    sudo systemctl enable --now onedrive
fi
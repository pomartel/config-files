sudo systemctl stop tlp.service tlp-pd.service
sudo systemctl disable tlp.service tlp-pd.service

sudo pacman -Rns tlp tlp-pd

sudo rm -rf /etc/tlp.d /etc/default/tlp
sudo rm -f /usr/local/bin/powerprofilesctl

sudo pacman -S power-profiles-daemon
sudo systemctl enable --now power-profiles-daemon.service

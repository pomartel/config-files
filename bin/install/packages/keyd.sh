sudo pacman -S --noconfirm keyd
sudo rm /etc/keyd/default.conf
sudo ln -s ~/.config/keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd


pacman -Syu --noconfirm

# Install packages from officiel repositories
pacman -S --noconfirm yay fish nano wget curl rsync jq unzip git pacman-contrib
  \ spotify discord code firefox
  \ kdecoration qt5-declarative qt5-x11extras cmake extra-cmake-modules kvantum-manjaro

# Install packages from AUR
yay -S --noconfirm sierrabreeze-kwin-decoration-git

# Install packages with script
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# Set fish as default shell 
chsh -s /usr/local/bin/fish

cd ~/Downloads
git clone https://github.com/psifidotos/applet-window-buttons.git && sh applet-window-buttons/install.sh
rm -rf *
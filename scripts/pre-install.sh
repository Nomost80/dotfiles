sudo pacman -Syu --noconfirm

# Install packages from official repositories
sudo pacman -S --noconfirm base-devel yay git curl kcoreaddons kdeclarative plasma-framework kdecoration qt5-declarative qt5-x11extras extra-cmake-modules kvantum-manjaro

# Install packages from AUR
yay -S --noconfirm sierrabreeze-kwin-decoration-git

cd ~/Downloads
# Install window buttons widget
git clone https://github.com/psifidotos/applet-window-buttons.git && cd applet-window-buttons 
sh install.sh

# Clean
cd ~/Downloads
rm -rf applet-window-buttons
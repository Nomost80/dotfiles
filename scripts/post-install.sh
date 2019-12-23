sudo pacman -Syu --noconfirm

# Install packages from official repositories
sudo pacman -S --noconfirm fish nano wget curl rsync jq unzip git spotify discord code firefox

# Install packages from AUR
yay -S --noconfirm bitwarden balena-etcher gtkhash

# Install fisher package manager
cd ~/Downloads
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# Set fish as default shell 
sudo chsh -s /usr/bin/fish
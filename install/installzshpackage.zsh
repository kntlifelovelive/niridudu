#!/bin/bash
# Zsh Setup Script

# 1. Install core packages
sudo pacman -S --needed zsh git curl wget base-devel fzf fd bat eza zoxide ffmpeg yt-dlp exiftool mediainfo jq nvm nodejs npm aria2 hyprland

# 2. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 3. Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/kutsan/zsh-system-clipboard ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-system-clipboard

# 4. Install Yay AUR helper
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd ..

# 5. Install AUR packages
yay -S --needed oh-my-zsh-git ttf-nerd-fonts-symbols ttf-jetbrains-mono-nerd fast-cli

# 6. Install global NPM packages
npm install -g fast-cli

# 7. Clone your Zsh config
git clone https://github.com/yourusername/zsh-config ~/.config/zsh
ln -sf ~/.config/zsh/.zshrc ~/.zshrc
ln -sf ~/.config/zsh/.zshenv ~/.zshenv

# 8. Set Zsh as default shell
chsh -s $(which zsh)

echo "✅ Setup complete! Restart your terminal."

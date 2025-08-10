# Install linux packages
sudo apt install zsh
sudo apt install build-essential -y
sudo apt install fzf -y # fuzzy finder
sudo apt install jq yq -y
sudo apt install lsd -y
sudo apt install bat -y
sudo apt install lazygit -y

echo "Install lsd manually from here https://github.com/lsd-rs/lsd/releases"
echo "Install bat https://github.com/sharkdp/bat/releases/tag/v0.24.0"

sleep 2
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

printf "\nLinux packages where installed"

cd "$HOME" || exit
git clone https://github.com/StefanFanaru/dotfiles.git

echo "Creating symlinks for dotfiles"
sleep 2

sudo ln -s ~/dotfiles/lsd ~/.config/lsd
sudo ln -s ~/dotfiles/zsh/.profile ~/.profile
sudo ln -s ~/dotfiles/zsh/.zshenv ~/.zshenv
sudo ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc
sudo ln -s ~/dotfiles/bat ~/.config/bat
sudo ln -s ~/dotfiles/lazygitconfig ~/.config/lazygit

# Ask user if ghostty zsh should be setup
read -p "Do you want to setup ghostty zsh? (y/n): " setup_ghostty
if [[ "$setup_ghostty" == "y" || "$setup_ghostty" == "Y" ]]; then
    echo "Setting up ghostty zsh..."
    # add a line to .zshenv to source ~/dotfiles/zsh/.zshenvghostty
    echo "source ~/dotfiles/zsh/.zshenvghostty" >>~/.zshenv
    echo "Ghostty zsh setup complete."
else
    echo "Skipping ghostty zsh setup."
fi

echo "SCRIPT IS DONE!"

# Install linux packages
sudo apt install zsh -y
sudo apt install git -y
sudo apt install fzf -y # fuzzy finder
sudo apt install jq yq -y
sudo apt install lsd -y
sudo apt install bat -y

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

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

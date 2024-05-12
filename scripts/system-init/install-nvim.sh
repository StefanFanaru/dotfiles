cd ~/Downloads
rm -f nvim-linux64.tar.gz
rm -rf ~/Downloads/nvim-linux64

echo "Downloading nvim"
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz

printf "\n\nVersion before update:\n$(/opt/nvim-linux64/bin/nvim --version)\n"
sudo rm -rf /opt/nvim-linux64-previous-previous
sudo mv /opt/nvim-linux64-previous /opt/nvim-linux64-previous-previous
sudo mv /opt/nvim-linux64 /opt/nvim-linux64-previous
sudo mv ~/Downloads/nvim-linux64 /opt/nvim-linux64
printf "\n\nVersion after update:\n$(/opt/nvim-linux64/bin/nvim --version)\n"


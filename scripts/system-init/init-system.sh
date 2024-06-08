# Install linux packages
sudo apt install zsh
sudo apt install build-essential -y
sudo apt install fswatch -y
sudo apt install shellcheck -y
sudo apt install fd -y
sudo apt install xclip -y   # to make system clipboard work in nvim
sudo apt install fzf -y     # fuzzy finder
sudo apt install ripgrep -y # multi threaded grepping
sudo apt install feh compton diodon flameshot -y
sudo apt install jq yq gpick -y

echo "Install lsd manually from here https://github.com/lsd-rs/lsd/releases"
echo "Install bat https://github.com/sharkdp/bat/releases/tag/v0.24.0"

printf "\nLinux packages where installed"

# Install hadolint for Dockerfile linting
wget https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64
sudo mv hadolint-Linux-x86_64 /usr/local/bin/hadolint
sudo chmod +x /usr/local/bin/hadolint

# Install terraform linting tflint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh

# Install nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
if [ -f ~/.zshrc ]; then
	echo 'export NVM_DIR="$HOME/.nvm"' >>~/.zshrc
	echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >>~/.zshrc
	echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >>~/.zshrc
	echo "Added NVM configuration to ~/.zshrc"
	source ~/.zshrc
	nvm install 20
	nvm install 16
	nvm use 20
else
	echo "Error: ~/.zshrc file not found"
fi

# Install global npm packages
npm install -g eslint_d markdownlint-cli typescript @fsouza/prettierd jsonlint

# Install dotnet
./dotnet-install.sh --version latest
./dotnet-install.sh --channel 6.0
./dotnet-install.sh --channel 3.1

echo 'export DOTNET_ROOT=$HOME/.dotnet' >>~/.zshrc
echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >>~/.zshrc
source ~/.zshrc
dotnet --list-sdks
echo 'dotnet was installed'

# Make LSP happy
cp /etc/sysctl.conf /tmp/
echo 'fs.inotify.max_user_watches=200000' >>/tmp/sysctl.conf
echo 'fs.inotify.max_queued_events=200000' >>/tmp/sysctl.conf
sudo cp /tmp/sysctl.conf /etc/

echo "SCRIPT IS DONE!"

# DCONF settings - GNOME only
# gsettings set org.gnome.nm-applet disable-disconnected-notifications "true"
# gsettings set org.gnome.nm-applet disable-connected-notifications "true"

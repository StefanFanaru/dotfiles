# Install linux packages
sudo apt install zsh
sudo apt install build-essential -y
sudo apt install fswatch -y
sudo apt install shellcheck -y
sudo apt install fd
sudo apt install xclip   # to make system cliboard work in nvim
sudo apt install fzf     # fuzzy finder
sudo apt install ripgrep # multi threaded grepping
echo "Install lsd manually from here https://github.com/lsd-rs/lsd/releases"

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
npm install -g eslind_d markdownlint-cli typescript @fsouza/prettierd jsonlint

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
echo 'fs.inotify.max_user_watches=200000' >>  /tmp/sysctl.conf
echo 'fs.inotify.max_queued_events=200000' >>  /tmp/sysctl.conf
sudo cp /tmp/sysctl.conf /etc/

echo "SCRIP IS DONE!"

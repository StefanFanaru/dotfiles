mkdir ~/Software
cd ~/Software || exit

# git clone https://github.com/alacritty/alacritty.git
cd alacritty

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# source "$HOME/.cargo/env"
# source "~/.zshrc"
# rustup override set stable
# rustup update stable
#
# sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y
#
#
# cargo build --release --no-default-features --features=x11

sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

infocmp alacritty

sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database


mkdir -p ${ZDOTDIR:-~}/.zsh_functions
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc

cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty

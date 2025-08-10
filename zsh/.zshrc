# export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/home/stefanaru/.local/bin
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export PATH="$PATH:$HOME/nvim-macos-arm64/bin"
export PATH="$PATH:~/.local/bin"
export PATH="$PATH:$HOME/dotfiles/scripts/external/bin"
export PATH=$PATH:/opt/gradle/gradle-8.7/bin
export PATH=$PATH:/usr/local/bin/netcoredbg
export PATH=$PATH:/usr/local/go/bin

export LANG=en_US.UTF-8
export ZSH=$HOME/.oh-my-zsh
export DOTNET_ROOT=$HOME/.dotnet

export DOT_FILES="$HOME/dotfiles"
if [ ! -d "$DOT_FILES" ]; then
    export DOT_FILES="$HOME/.dotfiles"
fi

# Disable ugly colors for folders with Others access
# https://askubuntu.com/questions/881949/ugly-color-for-directories-in-gnome-terminal
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git/'"
export FZF_COMPLETION_TRIGGER='~~'

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GHOSTTY_SHELL_FEATURES="cursor,title"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# Launch ssh-agent and persist it across tmux sessions
# source $DOT_FILES/scripts/workflow/ssh-agent-autostart.sh

ZSH_THEME="custom-agnoster"
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 30

plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# My custom sources to be loaded always
source $DOT_FILES/zsh/sources.sh

# Usage "z downloads" will cd into most used downloads folder
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # must be sourced before starting tmux
source $DOT_FILES/zsh/fzf_env.sh
source $DOT_FILES/scripts/workflow/tmux-autostart.sh
export PATH="/home/linuxbrew/.linuxbrew/opt/imagemagick@6/bin:$PATH"
export MAGICK_HOME="/usr/local/opt/imagemagick@6/lib"
export MAGICK_HOME="/usr/local/opt/imagemagick@6/lib"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="$PATH:/opt/mssql-tools18/bin"
fpath+=${ZDOTDIR:-~}/.zsh_functions


# Load Angular CLI autocompletion.
# check if ng is in path / installed
if command -v ng &> /dev/null; then
    source <(ng completion script)
    export PATH="$PATH:/opt/mssql-tools18/bin"
    export DOTNET_ROOT=/usr/local/share/dotnet
fi

setopt VI

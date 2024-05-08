
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$PATH:~/.local/bin"
export PATH="$PATH:$HOME/dotfiles/scripts/external/bin"

export LANG=en_US.UTF-8
export ZSH=$HOME/.oh-my-zsh
export DOTNET_ROOT=$HOME/.dotnet
export DOT_FILES="$HOME/dotfiles"
# Disable ugly colors for folders wiht Others access
# https://askubuntu.com/questions/881949/ugly-color-for-directories-in-gnome-terminal
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git/'"
export FZF_COMPLETION_TRIGGER='~~'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # must be sourced before starting tmux
source $DOT_FILES/scripts/workflow/tmux-autostart.sh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Launch ssh-agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s` &>/dev/null
fi

ZSH_THEME="custom-agnoster"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

plugins=(
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# My custom sources to be loaded always
source $DOT_FILES/zsh/sources.sh

# Usage "z downloads" will cd into most used downloads folder
eval "$(zoxide init zsh)"

# fpath+=${ZDOTDIR:-~}/.zsh_functions

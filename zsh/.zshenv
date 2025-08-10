skip_global_compinit=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=241"
# check if command nvim works
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

export IS_ZSH=true
export BAT_THEME="CatppuccinMocha"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export KUBE_EDITOR=nvim
export K9S_CONFIG_DIR=~/dotfiles/k9s
export DOCKER_HOST="tcp://192.168.34.195:2375"
export DOTNET_WATCH_SUPPRESS_BROWSER_REFRESH=1
export APP_ENVIRONMENT="s-fanaru"
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GHOSTTY_SHELL_FEATURES="cursor,title"

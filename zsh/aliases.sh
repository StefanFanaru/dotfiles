# NOTE: LSD-RS
# https://github.com/lsd-rs/lsd
alias ls='lsd'
alias l='ls'
alias ll='ls -la'
alias lt='ls --tree'

# Renames
alias cat='bat'
alias kc='kubectx'
alias kn='kubens'
alias v='nvim'
alias vim='nvim'
alias cls='clear'

# NOTE: CD
alias .='cd .'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias dtf='cd ~/dotfiles'

# NOTE: HELPERS
alias bashclear='echo "" > ~/.bash_history'
alias rm='rm -iv'
alias rzsh='source ~/.zshrc'
alias time='tty-clock -c -s -C 6 -f "%d %b"'

# NOTE: CDs
alias cdvim='cd /x/CLI/terminal-config/nvim'

alias layoutmanager='$DOT_FILES/scripts/external/i3-layout-manager/layout_manager.sh'

# SSH-ADD
alias sshgithub='ssh-add ~/.id_github'
alias sshstefanaru='ssh-add ~/.id_github'


# Kubectl
alias kgp='kubectl get pods'

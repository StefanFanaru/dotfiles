mistakeMessage='This is not the command you are looking for'
# NOTE: LSD-RS
# https://github.com/lsd-rs/lsd
alias l='\lsd'
alias ll='\lsd -la'
alias lt='\lsd --tree'
alias ls='echo $mistakeMessage; false'

# Renames
alias cat='bat'
alias kc='kubectx'
alias kn='kubens'
alias k='kubectl'
alias v='\nvim'
alias vv='\nvim .'
alias cls='\clear'
alias clear='echo $mistakeMessage; false'
alias lg='lazygit'
alias rm='trash-put'
alias nvim='echo $mistakeMessage; false'
alias sa='sudo'
alias so='source'

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
alias sshgithub='ssh-add ~/.ssh/id_github'
alias sshstefanaru='ssh-add ~/.ssh/id_github'

# Kubectl
alias kgp='kubectl get pods'

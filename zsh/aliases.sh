mistakeMessage='This is not the command you are looking for'
# NOTE: LSD-RS
# https://github.com/lsd-rs/lsd
alias l='\lsd'
alias ll='\lsd -la'
alias lt='\lsd --tree'
alias ls='echo $mistakeMessage; false'

# Renames
alias kc='kubectx'
alias kn='kubens'
alias k='kubectl'
alias v='nvim'
alias vv='nvim .'
alias cls='\clear'
alias clear='echo $mistakeMessage; false'
alias lg='lazygit'
alias rm='trash-put'
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
alias gitnamelectra= 'git config user.email "stefan.fanaru@geminicad.com"'
alias logoutnow='kill -9 -1'
alias xsc="xclip -selection clipboard"
alias seejson="xclip -o -selection clipboard | jless"
alias gvu="nmcli connection up 'Gemini VPN'"
alias gvd="nmcli connection down 'Gemini VPN'"
alias vpn="google-chrome-stable 'vpn.lectra.com'"

# NOTE: SSH-ADD
alias sshgithub='ssh-add ~/.ssh/id_github'
alias sshstefanaru='ssh-add ~/.ssh/id_github'
alias sshlectra='ssh-add ~/.ssh/s.fanaru_ed25519_key'

# NOTE: Kubectl
alias kgp='kubectl get pods'

mistakeMessage='This is not the command you are looking for'
# NOTE: LSD-RS
# https://github.com/lsd-rs/lsd
alias l='\lsd'
alias ll='\lsd -la'
alias lt='\lsd --tree'
alias ls='echo $mistakeMessage; false'

# Renames
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
alias dtf='cd ~/dotfiles'

# NOTE: HELPERS
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias modx='chmod +x'
alias mkdir='mkdir -pv'
alias ping='ping -c 5'
alias grep='grep --color=auto'
alias df='df -h'
alias top='btop'
alias rzsh='source ~/.zshrc'
alias time='tty-clock -c -s -C 6 -f "%d %b"'
alias gitnamelectra= 'git config user.email "stefan.fanaru@geminicad.com"'
alias gitnamegithub= 'git config user.email "stefan.fanaru@outlook.com"'
alias logoutnow='kill -9 -1'
alias myip='curl ipinfo.io/ip'
alias xsc="xclip -selection clipboard"
alias seejson="xclip -o -selection clipboard | jless"
alias gvu="nmcli connection up 'Gemini VPN'"
alias gvd="nmcli connection down 'Gemini VPN'"
alias gvp="nmcli connection show --active"
alias vpn="google-chrome-stable --profile-directory="Profile 2" vpn.lectra.com"
alias pulserestart="pulseaudio -k && pulseaudio --start"
alias headph="pactl set-default-sink 0"
alias speakers="pactl set-default-sink 1"
alias sudonvim='sudo /opt/nvim-linux64/bin/nvim'
alias btpw='/home/stefanaru/dotfiles/scripts/workflow/check-bt-battery.sh "JBL LIVE PRO 2 TWS"'
alias btu='/home/stefanaru/dotfiles/scripts/workflow/connect-jbl-pro.sh'
alias btd='/home/stefanaru/dotfiles/scripts/workflow/disconnect-jbl-pro.sh'

# NOTE: BAT
alias cat='bat --paging=never'
alias bathelp='bat --plain --language=help'
help() {
	"$@" --help 2>&1 | bathelp
}

# NOTE: SSH-ADD
alias sshgithub='ssh-add ~/.ssh/id_github'
alias sshstefanaru='ssh-add ~/.ssh/id_devops_stefanaru'
alias sshlectra='ssh-add ~/.ssh/s.fanaru_ed25519_key'

# NOTE: Kubectl
alias kgp='kubectl get pods'
alias kc='kubectx'
alias kn='kubens'
alias k='kubectl'

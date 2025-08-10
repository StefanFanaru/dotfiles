mistakeMessage='This is not the command you are looking for'
# NOTE: LSD-RS
# https://github.com/lsd-rs/lsd
alias l='\lsd'
alias la='\lsd -la'
alias lt='\lsd --tree'
alias ls='\lsd -la'

# Renames
# check if command nvim works
if command -v nvim &>/dev/null; then
	alias vim='nvim'
	alias vi='nvim'
	alias v='nvim'
else
	echo "nvim is not installed, using vim instead"
	alias vim='vim'
	alias vi='vim'
	alias v='vim'
fi
alias cls='\clear'
alias clear='echo $mistakeMessage; false'
alias lg='lazygit'
alias sa='sudo'
alias so='source'

# NOTE: CD
alias .='cd .'
alias ..='cd ..'
alias ...='cd ../../'
alias dtf='cd ~/dotfiles'

# NOTE: HELPERS
# alias rm='trash'
alias cp='cp -iv'
alias mv='mv -iv'
alias modx='chmod +x'
alias mkdir='mkdir -pv'
alias ping='ping -c 5'
alias grep='grep --color=auto'
alias df='df -h'
alias top='btop'
alias rzsh='source ~/.zshrc'
alias gitnamelectra= 'git config user.email "stefan.fanaru@geminicad.com"'
alias gitnamegithub= 'git config user.email "stefan.fanaru@outlook.com"'
alias syncproj="~/dotfiles/scripts/workflow/sync-work-projects.sh"
alias logoutnow='kill -9 -1'
alias myip='curl ipinfo.io/ip'
alias xsc="xclip -selection clipboard"
alias seejson="pbpaste | jless"
alias gvu="nmcli connection up 'Gemini VPN'"
alias gvd="nmcli connection down 'Gemini VPN'"
alias gvp="nmcli connection show --active"
alias vpn="google-chrome-stable --profile-directory=\"Profile 2\" vpn.lectra.com"
alias vpnp="pritunl-client start btag7jlsucbrt2uc --mode=ovpn"
alias pulserestart="pulseaudio -k && pulseaudio --start"
alias headphones="pactl set-default-sink 0"
alias speakers="pactl set-default-sink 1"
alias sudonvim='sudo /opt/nvim-linux64/bin/nvim'
alias btpw='/home/stefanaru/dotfiles/scripts/workflow/check-bt-battery.sh "JBL LIVE PRO 2 TWS"'
alias btu='/home/stefanaru/dotfiles/scripts/workflow/connect-jbl-pro.sh'
alias btd='/home/stefanaru/dotfiles/scripts/workflow/disconnect-jbl-pro.sh'
alias utcnow='date -u +"%H:%M:%S"'
alias quickrr='sudo systemctl restart lightdm'
alias tt='tasktango'
alias mmr='/home/stefanaru/dotfiles/scripts/workflow/make-mr.sh'
alias sus='systemctl suspend'
alias font='$HOME/dotfiles/scripts/workflow/toggle-font.sh'
alias rrray='$HOME/dotfiles/scripts/utils/raycast_restart.sh'

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

# NOTE: Dotnet
alias db='/Users/stefanaru/dotfiles/scripts/workflow/dotnet_command.sh build'
alias dr='/Users/stefanaru/dotfiles/scripts/workflow/dotnet_command.sh run'
alias dt='/Users/stefanaru/dotfiles/scripts/workflow/dotnet_command.sh test'
alias dres='/Users/stefanaru/dotfiles/scripts/workflow/dotnet_command.sh restore'
alias dw='/Users/stefanaru/dotfiles/scripts/workflow/dotnet_command.sh watch'

# NOTE: NPM
alias ni='npm install'
alias ns='npm run start'

# NOTE: SSH
alias sshserviable='ssh root@serviable'
alias sshrobbie='ssh root@robbie'
alias sshnas='ssh truenas_admin@192.168.34.144'
alias sshopenwrt='ssh root@192.168.34.1'
alias sshopenwrtwan='ssh root@5.14.168.108'
alias sshwazuh='ssh stefanaru@192.168.34.131'
alias sshha='ssh root@10.20.40.132 -p22222'
alias sqlstart='ssh root@serviable "pct start 114"'

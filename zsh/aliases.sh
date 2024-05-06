# NOTE: LSD-RS
# https://github.com/lsd-rs/lsd
alias ls='lsd'
alias l='ls -l'
alias ll='ls -la'
alias lt='ls --tree'

# NOTE: CD
alias .='cd .'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias dtf='cd ~/dotfiles'

# NOTE: HELPERS
alias bashclear='echo "" > ~/.bash_history'
alias cls='clear'
alias rm='rm -iv'
alias v='nvim'
alias vim='nvim'
alias rzsh='source ~/.zshrc'
alias time='tty-clock -c -s -C 6 -f "%d %b"'

# NOTE: CDs
alias cdvim='cd /x/CLI/terminal-config/nvim'

# NOTE: Call scripts
alias layoutmanager='$DOT_FILES/scripts/external/i3-layout-manager/layout_manager.sh'


# SSH-ADD
alias sshgithub='ssh-add ~/.id_github'
alias sshstefanaru='ssh-add ~/.id_github'

# Git
function gcmx {
	git commit -am "$1" && git push
}

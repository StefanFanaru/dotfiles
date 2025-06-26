session=$1
path=$2

# run applescript to open app Ghostty
osascript -e 'tell application "Ghostty" to activate'

# if session does not exist, create it at path
if ! tmux has-session -t "$session" 2>/dev/null; then
	tmux new-session -d -s "$session" -c "$path"
fi

tmux switch -t "$session"

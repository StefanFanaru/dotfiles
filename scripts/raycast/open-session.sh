session=$1
path=$2
open -b "org.alacritty"

# if session does not exist, create it at path
if ! tmux has-session -t "$session" 2>/dev/null; then
	tmux new-session -d -s "$session" -c "$path"
fi

tmux switch -t "$session"

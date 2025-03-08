#!/usr/bin/env bash

append_paths() {
	local result="$1"
	shift
	for path in "$@"; do
		result=$(printf "%s\n%s" "$result" "$path")
	done
	echo "$result"
}

if [[ $# -eq 1 ]]; then
	selected=$1
else
	# Find directories in specified paths
	find_result=$(find ~/Code/Lectra/digital-platform ~/Code/Stefan ~/Code/Lectra ~/Code/Lectra/lectra-repos ~/dotfiles -mindepth 1 -maxdepth 1 -type d)

	# Append paths to the find results
	find_result=$(append_paths "$find_result" "$HOME/dotfiles")

	# From file Results each line, remove "/Users/stefanaru" but leave the starting slash
	find_result=$(echo "$find_result" | sed "s|$HOME||")

	# Retrieve names of tmux sessions and append them to find_result
	tmux_sessions=$(tmux list-sessions -F "#S")

	#remove from find_result the lines that have pattern /tmux_session_name
	for session in $tmux_sessions; do
		find_result=$(echo "$find_result" | grep -v "$session$")
	done

	find_result=$(append_paths "$find_result" "$tmux_sessions")

	# Pass the combined result to fzf
	output=$(echo "$find_result" | fzf-tmux -p 80%,60% --query "$query" --print-query)
	# Count the number of lines in the output
	line_count=$(echo "$output" | wc -l)

	# Get the first line if there's only one line, otherwise get the second line
	if [ "$line_count" -eq 1 ]; then
		selected=$(echo "$output" | head -n 1)
	else
		selected=$(echo "$output" | tail -n 1)
	fi

fi

if [[ -z $selected ]]; then
	exit 0
fi

# if $selected starts with / append $HOME to it
if [[ $selected == /* ]]; then
	selected="$HOME$selected"
fi

selected_name=$(basename "$selected" | tr . _ | tr " " _)
selected_name="${selected_name//@/}"
if [ ! -d "$selected" ]; then
	selected="$HOME"
fi
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
	tmux new-session -s $selected_name -c $selected
	exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
	tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name

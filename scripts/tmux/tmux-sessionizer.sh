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
	find_result=$(find ~/work/digital-platform ~/work/ ~/personal/ ~/dotfiles/ -mindepth 1 -maxdepth 1 -type d)

	# Append paths to the find results
	find_result=$(append_paths "$find_result" "/home/stefanaru/dotfiles")

	# Retrieve names of tmux sessions and append them to find_result
	tmux_sessions=$(tmux list-sessions -F "#S")
	find_result=$(append_paths "$find_result" "$tmux_sessions")

	# Pass the combined result to fzf
	output=$(echo "$find_result" | fzf --query "$query" --print-query)
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

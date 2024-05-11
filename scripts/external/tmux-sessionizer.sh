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
	find_result=$(append_paths "$find_result" "/x/CLI/terminal-config/nvim" "/home/stefanaru/dotfiles")

	# Pass the combined result to fzf
	selected=$(echo "$find_result" | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name

#!/bin/sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Quick note
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Take a quick note in Obisidian
# @raycast.author Stefan Fanaru

# Send keys "space", "o", "n", "n" one by one
#
# check if tmux is running and if not quit
if ! tmux has-session -t obsidian 2>/dev/null; then
    echo "No tmux session found"
    open -b "org.alacritty"
    exit 1
fi

./open-session.sh "obsidian" "~/Data/second-brain/"

# select first tmux window
tmux select-window -t obsidian:1

# get the window name of the active tmux window
obsidian_window_name=$(tmux display-message -p -t obsidian:1 '#{window_name}')

# if the window name is zsh then sent the keys "vv" and enter
if [ "$obsidian_window_name" = "zsh" ]; then
    tmux send-keys -t obsidian space v v Enter
fi
tmux send-keys -t obsidian Escape
tmux send-keys -t obsidian space o n

#!/bin/bash

if [ "$TERM" != "alacritty" ]; then
	return
fi

if ! tmux ls | grep -q "^obsidian:"; then
	tmux new-session -d -s obsidian -c $HOME/Data/second-brain
	tmux send-keys -t obsidian 'vv' C-m
fi

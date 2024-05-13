#!/bin/bash

if [ "$TERM" != "alacritty" ]; then
	exit
fi

# Launch tmux by default
# Conditions to run tmux command
# 1. we're in an interactive shell, and
# 2. tmux exists on the system
# 3. tmux doesn't try to run within itself
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	# Start tmux if it's not already running
	if ! tmux has-session &>/dev/null; then
		exec tmux new-session -s abyss
	else
		# Check if tmux session "abyss" exists and no other clients are attached
		if tmux has-session -t abyss && [ "$(tmux list-clients -t abyss | wc -l)" -eq 0 ]; then
			exec tmux attach -t abyss
		else
			if tmux has-session -t abyss-mini &>/dev/null; then
				if [ "$(tmux list-clients -t abyss-mini | wc -l)" -eq 0 ]; then
					exec tmux attach -t abyss-mini
				else
					if [ "$(tmux list-clients -t obsidian | wc -l)" -eq 0 ]; then
						exec tmux attach -t obsidian
					else
						exec tmux attach -t abyss
					fi
				fi
			else
				exec tmux new-session -s abyss-mini
			fi
		fi
	fi
fi

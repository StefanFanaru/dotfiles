#!/bin/bash
current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
i3-msg 'floating disable'
if [ "$current_workspace" != "1" ]; then
	i3-msg "workspace number 1"
	i3-msg '[class="Google-chrome"] focus; '
	layout=$(i3-msg -t get_tree | jq -r '.. | select(.focused? == true).layout')
	if [ "$layout" != "stacked" ]; then
		i3-msg 'focus right;'
	fi
	i3-msg "workspace number $current_workspace"
	i3-msg 'move container to workspace number 1'
	i3-msg "workspace number 1"
	exit 0
else
	i3-msg 'move container to workspace number 5'

	i3-msg '[class="Google-chrome"] focus; '
	# if it's not focused currently on stacked container, focus next Google-chrome window
	layout=$(i3-msg -t get_tree | jq -r '.. | select(.focused? == true).layout')
	if [ "$layout" != "stacked" ]; then
		i3-msg 'focus right;'
	fi

	i3-msg "workspace number 5"
	i3-msg 'move container to workspace number 1'
	i3-msg "workspace number 1"
fi

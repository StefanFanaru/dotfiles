#!/bin/bash
current_workspace=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).num')

if [ $current_workspace -eq 1 ]; then
	i3-msg "workspace number 1"
	i3-msg '[workspace="1" instance="crx_cifhbcnohmdccbgoicgdjpfamggdegmo"] focus'
	i3-msg 'floating disable; move left; move right; move up'
	exit
fi
i3-msg "workspace number 1"
i3-msg '[class=".*"] focus; focus right; focus right; focus right'
i3-msg 'split v'
i3-msg "workspace number 3"
i3-msg '[workspace="3" instance="crx_cifhbcnohmdccbgoicgdjpfamggdegmo"] focus'
i3-msg 'floating disable'
i3-msg 'move container to workspace number 1'
i3-msg "workspace number 1"
i3-msg 'move up'

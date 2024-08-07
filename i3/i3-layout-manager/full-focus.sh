#!/bin/bash

# with i3 go to workspace 3 and check if there are any windows in that workspace
current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .num')
has_windows_on_ws3=$(i3-msg -t get_tree | jq -r 'recurse(.nodes[]) | select(.type == "workspace" and .num == 3) | .nodes | length')

if [ "$has_windows_on_ws3" != "" ]; then
	# if there are windows in workspace 3, move the  windows of workspace 3, 100 pixels to the left from their original position but keep them floating
	i3-msg "workspace number 3; floating enable; resize set 2200 px 1440 px; move absolute position center"
	i3-msg "workspace number 3; move left 100 px"
	i3-msg "workspace number $current_workspace"
fi
i3-msg "move container to workspace number 3, workspace number 3, floating enable, resize set 2200 px 1440 px, move absolute position center"

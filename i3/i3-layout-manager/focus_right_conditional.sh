#!/bin/bash

# Check if the direction argument is provided
if [ -z "$1" ]; then
	echo "Usage: $0 <left|right>"
	exit 1
fi

direction=$1

# Get the JSON tree from i3-msg
tree=$(i3-msg -t get_tree)

# Get the focused container's id
focused_id=$(echo "$tree" | jq '.. | select(.focused? == true).id')

# Get the layout of the focused container's parent
parent_layout=$(echo "$tree" | jq -r --argjson id "$focused_id" '.. | select(.nodes? and (.nodes | map(select(.id == $id)) | length > 0)).layout')

# If the parent layout is "stacked" or "tabbed", focus the parent first
if [[ "$parent_layout" == "stacked" || "$parent_layout" == "tabbed" ]]; then
	i3-msg focus parent
fi

# Move focus in the specified direction
i3-msg "focus $direction"

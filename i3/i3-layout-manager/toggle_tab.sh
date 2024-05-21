#!/bin/bash

# Get the JSON tree from i3-msg
tree=$(i3-msg -t get_tree)

# Get the focused container's id
focused_id=$(echo "$tree" | jq '.. | select(.focused? == true).id')

# Get the layout of the focused container's parent
parent_layout=$(echo "$tree" | jq -r --argjson id "$focused_id" '.. | select(.nodes? and (.nodes | map(select(.id == $id)) | length > 0)).layout')

# Check if the parent layout is "tabbed"
if [ "$parent_layout" == "tabbed" ]; then
	# Get the number of tabs
	num_tabs=$(echo "$tree" | jq -r --argjson id "$focused_id" '.. | select(.nodes? and (.nodes | map(select(.id == $id)) | length > 0)).nodes | length')

	# Get the focused container's index among tabs
	focused_index=$(echo "$tree" | jq -r --argjson id "$focused_id" --argjson parent_id "$focused_id" '.. | select(.nodes? and (.nodes | map(select(.id == $parent_id)) | length > 0)).nodes | map(.id) | index($id)')

	# Calculate the index of the next tab
	next_index=$((($focused_index + 1) % $num_tabs))

	# Get the id of the next tab
	next_tab_id=$(echo "$tree" | jq -r --argjson parent_id "$focused_id" --argjson index "$next_index" '.. | select(.nodes? and (.nodes | map(select(.id == $parent_id)) | length > 0)).nodes | .[$index].id')

	# Focus the next tab
	i3-msg "[con_id=$next_tab_id] focus"
fi

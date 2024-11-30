#!/bin/bash

export DISPLAY=:0

while true; do
	sleep 100
	current_workspace=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).num')
	mouse_x=$(xdotool getmouselocation | awk '{print $1}' | cut -d ":" -f 2)
	mouse_y=$(xdotool getmouselocation | awk '{print $2}' | cut -d ":" -f 2)

	ids=$(xdotool search --classname --all "crx_cifhbcnohmdccbgoicgdjpfamggdegmo" search --name "Microsoft Teams")

	# loop through the ids
	for id in $ids; do
		printf "id: %s\n" "$id"
		is_gemini=$(xdotool get_desktop_for_window "$id" | grep -q "0\|2" && echo "true" || echo "false")
		if [ "$is_gemini" == "false" ]; then
			continue
		fi

		window_workspace=$(xdotool get_desktop_for_window "$id")
		window_workspace=$((window_workspace + 1))
		if [ "$window_workspace" != "$current_workspace" ]; then
			continue
		fi

		xdotool mousemove --window "$id" 50 50
		xdotool mousemove "$mouse_x" "$mouse_y"
	done
	sleep 3
done

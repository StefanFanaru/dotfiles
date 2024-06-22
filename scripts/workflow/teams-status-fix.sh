#!/bin/bash

export DISPLAY=:0

while true; do
	sleep 120
	# get initial mouse location
	mouse_x=$(xdotool getmouselocation | awk '{print $1}' | cut -d ":" -f 2)
	mouse_y=$(xdotool getmouselocation | awk '{print $2}' | cut -d ":" -f 2)

	id=$(xdotool search --classname "crx_cifhbcnohmdccbgoicgdjpfamggdegmo")
	if [ -z "$id" ]; then
		continue
	fi
	#hover over the window
	xdotool mousemove --window $id 50 50
	# apply previous mouse location
	xdotool mousemove $mouse_x $mouse_y
done

#!/bin/bash

while true; do
	sleep 120
	tmp=$(xdotool getactivewindow)
	id=$(xdotool search --classname "crx_cifhbcnohmdccbgoicgdjpfamggdegmo")
	if [ -z "$id" ]; then
		continue
	fi
	xdotool windowactivate --sync "$id" key Right
	xdotool windowactivate "$tmp"
done

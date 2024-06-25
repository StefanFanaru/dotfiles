#!/bin/bash

i3-msg "workspace number 1"
i3-msg '[workspace="1" instance="crx_cifhbcnohmdccbgoicgdjpfamggdegmo"] focus'

focused_window_id=$(xdotool getwindowfocus)
window_height=$(xwininfo -id "$focused_window_id" | grep Height | awk '{print $2}')
window_width=$(xwininfo -id "$focused_window_id" | grep Width | awk '{print $2}')
xdotool mousemove --window "$focused_window_id" $((window_width / 2)) $((window_height - 50))
xdotool click 1

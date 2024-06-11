#!/bin/bash

sh -c 'alacritty &'
subscribe_to_window "Alacritty"
sleep 0.4
i3-msg '[class="Alacritty" workspace="3"] focus'
i3-msg '[class="Alacritty" workspace="3"] floating enable'
i3-msg 'resize set 1460 1440, move position 3660 px 0 px'

# Get the window ID of the currently focused window
focused_window=$(xdotool getwindowfocus)

# Send the keys CTRL+A and W to open obisian session
xdotool key --window "$focused_window" ctrl+a
sleep 0.2
xdotool key --window "$focused_window" w

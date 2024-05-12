#!/bin/bash
source ~/dotfiles/i3/i3-layout-manager/layout-helpers.sh

open_apps() {
	i3-msg "[workspace=1] kill"
	i3-msg 'workspace number 1'
	~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-PERSONALWORKSPACE1.json
	sh -c 'alacritty &'
	subscribe_to_window "Alacritty"

	session_count=$(tmux list-sessions | wc -l)
	if [ "$session_count" -gt 1 ]; then
		sleep 0.1
	else
		sleep 3
	fi

	sh -c 'alacritty &'
	subscribe_to_window "Alacritty"
	sh -c 'google-chrome-stable --profile-directory="Profile 2" &'
	subscribe_to_window "Google-chrome"
	i3-msg "focus right"
}

current_resolution=$(xrandr | grep -oP '\d{3,4}x\d{3,4}' | head -n 1)
if [ "$current_resolution" != "5120x1440" ]; then
	xrandr --output DP-0 --mode 5120x1440
	feh --bg-scale ~/dotfiles/misc/wallpaper_leaves.png
fi

open_apps

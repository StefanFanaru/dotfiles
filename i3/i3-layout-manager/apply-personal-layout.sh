#!/bin/bash
source ~/dotfiles/i3/i3-layout-manager/layout-helpers.sh

workspace_number=$1
changed_resolution=false

open_apps_workspace_one() {
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
}

open_apps_workspace_two() {
	i3-msg 'workspace number 2'
	~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-PERSONALWORKSPACE2.json

	sh -c 'alacritty &'
	subscribe_to_window "Alacritty"
}

open_apps() {
	if [ "$changed_resolution" = true ]; then
		i3-msg '[class=".*"] kill'
		open_apps_workspace_one
		open_apps_workspace_two
		i3-msg 'workspace number 1'
		return
	fi

	i3-msg "workspace number $workspace_number"
	num_windows=$(wmctrl -l | grep -c -v "Desktop")
	if [ "$num_windows" -eq 0 ]; then
		open_apps_workspace_one
		open_apps_workspace_two
		i3-msg 'workspace number 1'
		return
	fi

	i3-msg "[workspace=$workspace_number] kill"
	sleep 0.5
	if [ "$workspace_number" = "1" ]; then
		open_apps_workspace_one
	elif [ "$workspace_number" = "2" ]; then
		open_apps_workspace_two
	fi

	i3-msg "focus right"
}

current_resolution=$(xrandr | grep -oP '\d{3,4}x\d{3,4}' | head -n 1)
if [ "$current_resolution" != "5120x1440" ]; then
	xrandr --output DP-0 --mode 5120x1440
	feh --bg-scale ~/dotfiles/misc/wallpaper_leaves.png
	changed_resolution=true
fi
open_apps

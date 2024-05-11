#!/bin/bash
source ~/dotfiles/i3/i3-layout-manager/layout-helpers.sh

workspace_number=$1
changed_resolution=false
is_initial_start=false

open_apps_workspace_one() {
	i3-msg 'workspace number 1'
	~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-WORKSPACE1.json
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
	sh -c 'teams-for-linux &'
	subscribe_to_window 'teams-for-linux'
	sh -c 'google-chrome-stable --profile-directory=Default &'
	subscribe_to_window "Google-chrome"
}

open_apps_workspace_two() {
	i3-msg 'workspace number 2'
	~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-WORKSPACE2.json
	sh -c 'obsidian &'
	subscribe_to_window "obsidian"

	if [ "$is_initial_start" = true ]; then
		return
	fi

	sh -c 'google-chrome-stable --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo &'
	subscribe_to_window "Google-chrome"
	sh -c 'slack &'
	subscribe_to_window "Slack"
	sh -c 'google-chrome-stable --profile-directory=Default --app-id=faolnafnngnfdaknnbpnkhgohbobgegn &'
	subscribe_to_window "Google-chrome"
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
		is_initial_start=true
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
}

current_resolution=$(xrandr | grep -oP '\d{3,4}x\d{3,4}' | head -n 1)
if [ "$current_resolution" != "5120x1440" ]; then
	xrandr --output DP-0 --mode 5120x1440
	feh --bg-scale /mnt/x/CLI/terminal-config/wallpaper_leaves.png
	changed_resolution=true
fi
open_apps

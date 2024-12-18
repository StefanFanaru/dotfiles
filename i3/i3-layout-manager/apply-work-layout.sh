#!/bin/bash
source ~/dotfiles/i3/i3-layout-manager/layout-helpers.sh

workspace_number=$1
changed_resolution=false

open_apps_workspace_one() {
	i3-msg 'workspace number 1'
	~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-WORKSPACE1TABS.json

	sh -c 'google-chrome-stable --profile-directory="Profile 3" &'
	subscribe_to_window "Google-chrome"
	i3-msg title_format 'Gemini'

	sh -c 'google-chrome-stable --profile-directory="Profile 2" &'
	subscribe_to_window "Google-chrome"
	i3-msg title_format 'Lectra'

	sh -c 'alacritty &'
	subscribe_to_window "Alacritty"

	sh -c 'google-chrome-stable --profile-directory="Profile 3" --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo &'
	subscribe_to_window 'Google-chrome'

	sh -c 'google-chrome-stable --profile-directory="Profile 3" --app-id=pkooggnaalmfkidjmlhoelhdllpphaga &'
	subscribe_to_window "Google-chrome"

	sleep 5
	# session_count=$(tmux list-sessions | wc -l)
	# if [ "$session_count" -gt 1 ]; then
	# 	sleep 0.1
	# else
	# 	sleep 3
	# fi

	xdotool mousemove 3898 871
	xdotool click 1
	sleep 0.5
	xdotool mousemove 3954 819
	xdotool click 1
	xdotool mousemove 2560 720
}

open_apps_workspace_two() {
	i3-msg 'workspace number 2'
	~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-WORKSPACE2TABS.json

	sh -c 'google-chrome-stable --profile-directory="Profile 2" --app-id=faolnafnngnfdaknnbpnkhgohbobgegn &'
	subscribe_to_window "Google-chrome"
	i3-msg title_format 'Lectra'
	sh -c 'google-chrome-stable --profile-directory="Profile 3" --app-id=pkooggnaalmfkidjmlhoelhdllpphaga &'
	subscribe_to_window "Google-chrome"
	i3-msg title_format 'Gemini'
	i3-msg move left

	sh -c 'alacritty &'
	subscribe_to_window "Alacritty"
	# Teams Lectra
	sh -c 'google-chrome-stable --profile-directory="Profile 4" --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo &'
	subscribe_to_window "Google-chrome"
	# Slack
	sh -c 'google-chrome-stable --profile-directory="Profile 2" --app-id=gbgeipnpfoilbpmicolehcbfkeoapdjd &'
	subscribe_to_window "Google-chrome"
	i3-msg 'workspace 2; [class="^Alacritty$"] focus'
}

open_apps() {
	if [ "$changed_resolution" = true ]; then
		i3-msg '[class=".*"] kill'
		open_apps_workspace_one
		open_apps_workspace_two
		i3-msg 'workspace number 1; [class="^teams-for-linux$"] focus; focus left'
		return
	fi

	i3-msg "workspace number $workspace_number"
	num_windows=$(wmctrl -l | grep -c -v "Desktop")
	if [ "$num_windows" -eq 0 ]; then
		open_apps_workspace_one
		open_apps_workspace_two
		i3-msg 'workspace number 1; [class="^teams-for-linux$"] focus; focus left'
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
	feh --bg-scale ~/dotfiles/misc/wallpaper_leaves.png
	changed_resolution=true
fi
open_apps
i3-msg 'border pixel 3'

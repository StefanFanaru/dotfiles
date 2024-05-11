#!/bin/bash
source ~/dotfiles/i3/i3-layout-manager/layout-helpers.sh

workspace_number=$1
is_initial_start=false

open_apps() {
	i3-msg '[class=".*"] kill'
	i3-msg 'workspace number 1'
	~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-WORKSPACE1.json
	sh -c 'alacritty &'
	subscribe_to_window "Alacritty"

	if [ $is_initial_start = true ]; then
		# wait for tmux continuum plugin to restore sessions
		sleep 3
	fi

	sh -c 'alacritty &'
	subscribe_to_window "Alacritty"
	sh -c 'teams-for-linux &'
	subscribe_to_window 'teams-for-linux'
	sh -c 'google-chrome-stable --profile-directory=Default &'
	subscribe_to_window "Google-chrome"

	i3-msg 'workspace number 2'
	~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-WORKSPACE2.json
	sh -c 'obsidian &'
	subscribe_to_window "obsidian"

	sh -c 'google-chrome-stable --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo &'
	subscribe_to_window "Google-chrome"
	sh -c 'google-chrome-stable --profile-directory=Default --app-id=faolnafnngnfdaknnbpnkhgohbobgegn &'
	sh -c 'slack &'
	subscribe_to_window "Slack"
	i3-msg 'workspace number 1'
}

current_resolution=$(xrandr | grep -oP '\d{3,4}x\d{3,4}' | head -n 1)
if [ "$current_resolution" != "5120x1440" ]; then
	xrandr --output DP-0 --mode 5120x1440
	feh --bg-scale /mnt/x/CLI/terminal-config/wallpaper_leaves.png
	open_apps
else
	i3-msg "workspace number $workspace_number"
	num_windows=$(wmctrl -l | grep -c -v "Desktop")
	if [ "$num_windows" -eq 0 ]; then
		is_initial_start=true
	fi
	open_apps
fi

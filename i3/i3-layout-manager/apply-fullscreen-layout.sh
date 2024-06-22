#!/bin/bash
source ~/dotfiles/i3/i3-layout-manager/layout-helpers.sh

current_resolution=$(xrandr | grep -oP '\d{3,4}x\d{3,4}' | head -n 1)
resolution_changed=false
if [ "$current_resolution" != "2560x1440" ]; then
	i3-msg 'workspace number 2'
	i3-msg '[instance="crx_cifhbcnohmdccbgoicgdjpfamggdegmo"] focus'
	i3-msg 'kill'
	xrandr --output DP-0 --mode 2560x1440
	feh --bg-center /home/stefanaru/dotfiles/misc/wallpaper_leaves.png
	# sleep 1
	resolution_changed=true
fi

i3-msg '[class=".*"] move scratchpad'
current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

i3-msg 'workspace number 1'
~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-FULLWORKSPACE1.json
sh -c 'alacritty &'
subscribe_to_window "Alacritty"

# Browsers
i3-msg 'workspace number 2'
~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-FULLWORKSPACE2TABBED.json
sh -c 'google-chrome-stable --profile-directory="Profile 3" &'
subscribe_to_window "Google-chrome"
i3-msg 'border none'
i3-msg title_format 'Gemini'
sh -c 'google-chrome-stable --profile-directory="Profile 2" &'
subscribe_to_window "Google-chrome"
i3-msg 'border none'
i3-msg title_format 'Lectra'

# Teams Gemini
i3-msg 'workspace number 3'
i3-msg '[instance="crx_cifhbcnohmdccbgoicgdjpfamggdegmo"] scratchpad show'
i3-msg 'border none'
i3-msg 'floating disable'
i3-msg 'fullscreen enable'

# Outlook Gemini, Teams Lectra, Slack
i3-msg 'workspace number 4'
i3-msg '[instance="crx_pkooggnaalmfkidjmlhoelhdllpphaga"] scratchpad show'
i3-msg 'floating disable'
i3-msg 'border none'
i3-msg title_format 'Outlook Gemini'
i3-msg 'layout tabbed'

sh -c 'google-chrome-stable --profile-directory="Profile 4" --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo &'
subscribe_to_window "Google-chrome"
i3-msg 'border none'
i3-msg title_format 'Teams Lectra'

i3-msg '[instance="crx_gbgeipnpfoilbpmicolehcbfkeoapdjd"] scratchpad show'
i3-msg 'floating disable'
i3-msg 'border none'
i3-msg title_format 'Slack'

if [ $resolution_changed = true ]; then
	i3-msg 'workspace number 3'
else
	i3-msg "workspace number $current_workspace"
fi

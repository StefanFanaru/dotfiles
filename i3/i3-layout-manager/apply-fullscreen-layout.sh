#!/bin/bash
source ~/dotfiles/i3/i3-layout-manager/layout-helpers.sh

current_resolution=$(xrandr | grep -oP '\d{3,4}x\d{3,4}' | head -n 1)
resolution_changed=false
if [ "$current_resolution" != "2560x1440" ]; then
	xrandr --output DP-0 --mode 2560x1440
	feh --bg-center /mnt/x/CLI/terminal-config/wallpaper_leaves.png
	# sleep 1
	resolution_changed=true
fi

i3-msg '[class=".*"] kill'

i3-msg 'workspace number 1'
~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-FULLWORKSPACE1.json
sh -c 'alacritty &'
subscribe_to_window "Alacritty"

i3-msg 'workspace number 2'
~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-FULLWORKSPACE2.json
sh -c 'google-chrome-stable --profile-directory=Default &'
subscribe_to_window "Google-chrome"

i3-msg 'workspace number 3'
~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-FULLWORKSPACE3.json
sh -c 'teams-for-linux &'
subscribe_to_window 'teams-for-linux'

i3-msg 'workspace number 4'
~/dotfiles/i3/i3-layout-manager/layout_manager.sh ~/dotfiles/i3/i3-layout-manager/layouts/layout-FULLWORKSPACE4.json 4
sh -c 'google-chrome-stable --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo &'
# sh -c 'google-chrome-stable --profile-directory=Default --app-id=faolnafnngnfdaknnbpnkhgohbobgegn &'
sh -c 'google-chrome-stable --profile-directory=Default --app-id=pkooggnaalmfkidjmlhoelhdllpphaga &'
subscribe_to_window "Google-chrome"

if [ $resolution_changed = true ]; then
	i3-msg 'workspace number 3'
fi

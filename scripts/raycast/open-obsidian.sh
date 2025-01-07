#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Obsidian
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author Stefan Fanaru

open -a "Alacritty"
# check if tmux server is running, if not wait 2 seconds
if ! tmux has-session -t obsidian 2>/dev/null; then
	sleep 2
fi

sleep 0.1

osascript <<EOF
tell application "System Events"
    set appName to "Alacritty"

    -- Send the keystrokes Ctrl+A and W
    keystroke "a" using control down
    keystroke "w"
end tell
EOF

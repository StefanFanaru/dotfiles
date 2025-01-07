#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Quick note
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Take a quick note in Obisidian
# @raycast.author Stefan Fanaru

-- Focus the Alacritty application
tell application "System Events"
    set appName to "Alacritty"
    if exists (application process appName) then
        tell application process appName
            set frontmost to true
        end tell
    else
        display notification "Alacritty is not running" with title "Error"
        error "Alacritty is not running"
    end if
end tell
-- Send the keystrokes Ctrl+A and W
tell application "System Events"
    keystroke "a" using control down
    delay 0.1 -- slight delay to ensure proper key sequencing
    keystroke "w"

    key code 53 -- Escape key
    -- Send keys "space", "o", "n", "n" one by one
    keystroke space
    keystroke "o"
    keystroke "n"
end tell


#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Connect JBL
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎧

# Documentation:
# @raycast.author Stefan Fanaru

mac_address="84-d3-52-bd-b0-4b"
if bluetoothconnector --status $mac_address | grep -q "Connected"; then
	bluetoothconnector --disconnect $mac_address
	sleep 8
fi

# connect airpods
bluetoothconnector --connect $mac_address

# set volume to 75%
sleep 2
osascript -e "set volume output volume 75"

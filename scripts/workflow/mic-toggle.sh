#!/bin/bash

force_multe=$1
# Get the source ID for "HyperX SoloCast Analog Stereo"
DEVICE_NAME="alsa_input.usb-HP__Inc_HyperX_SoloCast-00.analog-stereo"

# Use pactl to list all sources and grep for the device name
SOURCE_ID=$(pactl list sources short | grep "$DEVICE_NAME" | awk '{print $1}') # Toggle the mute state
echo "Source ID: $SOURCE_ID"

CURRENT_STATE=$(pactl list sources | grep -A 10 "Source #$SOURCE_ID" | grep "Mute" | awk '{print $2}')
echo "Current state: $CURRENT_STATE"

if [ "$force_multe" == "mute" ]; then
	pactl set-source-mute "$SOURCE_ID" 1
	exit
fi

if [ "$CURRENT_STATE" == "yes" ]; then
	pactl set-source-mute "$SOURCE_ID" 0
else
	pactl set-source-mute "$SOURCE_ID" 1
fi

#!/bin/bash

force_multe=$1
# Get the source ID for "HyperX SoloCast Analog Stereo"
DEVICE_NAME="HyperX_SoloCast"

# Use pactl to list all sources and select the one that contains the device name on that row
SOURCE_ID=$(pactl list sources short | grep "$DEVICE_NAME" | awk '{print $1}')
echo "Source ID: $SOURCE_ID"

CURRENT_STATE=$(pactl list sources | grep -A 10 "Source #$SOURCE_ID" | grep "Mute" | awk '{print $2}')
echo "Current mute state: $CURRENT_STATE"
echo $CURRENT_STATE

if [ "$force_multe" == "mute" ]; then
	pactl set-source-mute "$SOURCE_ID" 1
	exit
fi

if [ "$CURRENT_STATE" == "yes" ]; then
	echo "Unmuting"
	pactl set-source-mute "$SOURCE_ID" 0
else
	echo "Muting"
	pactl set-source-mute "$SOURCE_ID" 1
fi

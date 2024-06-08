#!/bin/bash

model=$1
# Get the output of upower -d
UPOWER_OUTPUT=$(upower -d)

# Search for the JBL device model in the output
DEVICE_PATH=$(echo "$UPOWER_OUTPUT" | grep -B 10 "$model" | grep "Device:" | awk '{print $2}')

# Check if the device was found
if [ -z "$DEVICE_PATH" ]; then
	echo "Device '$model' not found."
	exit 1
fi

# Get the battery percentage for the found device
BATTERY_PERCENTAGE=$(upower -i "$DEVICE_PATH" | grep "percentage:" | awk '{print $2}')

# Check if the battery percentage was found
if [ -z "$BATTERY_PERCENTAGE" ]; then
	echo "Could not retrieve battery percentage for '$model'."
	exit 1
fi

# Print the battery percentage
echo $BATTERY_PERCENTAGE

#!/bin/bash

# MAC address of the Bluetooth device
DEVICE_MAC="84:D3:52:BD:B0:4B"

# Start bluetoothctl and issue the commands to disconnect
echo -e "disconnect $DEVICE_MAC\nexit" | bluetoothctl

# Check if the disconnection was successful
CONNECTED=$(echo -e "info $DEVICE_MAC\nexit" | bluetoothctl | grep "Connected: yes")

if [ -z "$CONNECTED" ]; then
	echo "Successfully disconnected from $DEVICE_MAC"
else
	echo "Failed to disconnect from $DEVICE_MAC"
fi

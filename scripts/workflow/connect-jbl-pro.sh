#!/bin/bash

# MAC address of the Bluetooth device
DEVICE_MAC="84:D3:52:BD:B0:4B"

# Start bluetoothctl and issue the commands to connect
echo -e "power on\nagent on\ndefault-agent\nconnect $DEVICE_MAC\nexit" | bluetoothctl

# Check if the connection was successful
CONNECTED=$(echo -e "info $DEVICE_MAC\nexit" | bluetoothctl | grep "Connected: yes")

if [ -n "$CONNECTED" ]; then
	echo "Successfully connected to $DEVICE_MAC"
else
	echo "Failed to connect to $DEVICE_MAC"
fi

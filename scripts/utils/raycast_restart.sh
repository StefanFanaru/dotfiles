#!/bin/bash

# Force quit Raycast but force it!
osascript -e 'tell application "Raycast" to quit'

# Wait for a few seconds to ensure it has quit
sleep 3

# Start Raycast again
open -a "Raycast"

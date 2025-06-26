#!/bin/bash

# Force quit Raycast
osascript -e 'quit app "Raycast"'

# Wait for a few seconds to ensure it has quit
sleep 3

# Start Raycast again
open -a "Raycast"

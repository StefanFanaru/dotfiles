#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Mic
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎤

# Documentation:
# @raycast.description Toggle microphone on/off
# @raycast.author Stefan Fanaru

if [ $(SwitchAudioSource -t input -a | grep -c "HyperX SoloCast") -eq 1 ]; then
	SwitchAudioSource -t input -s "HyperX SoloCast" >/dev/null
	SwitchAudioSource -m toggle -t input >/dev/null
else
	SwitchAudioSource -t input -s "MacBook Air Microphone" >/dev/null
	SwitchAudioSource -m toggle -t input >/dev/null
fi

# Set volume to 75%
osascript -e "set volume output volume 75"

#!/bin/bash
sleep 5
/home/stefanaru/dotfiles/scripts/workflow/mic-toggle.sh mute
DEVICE_NAME="HyperX_SoloCast"
DEVICE_FULL_NAME=$(pactl list sources short | grep "$DEVICE_NAME" | awk '{print $2}')
/home/stefanaru/.local/bin/noisetorch -i -s "$DEVICE_FULL_NAME" -t 20

pactl set-default-source 'NoiseTorch Microphone for HyperX SoloCast'
pactl set-source-volume "$DEVICE_FULL_NAME" 100%
pactl set-source-volume 'NoiseTorch Microphone for HyperX SoloCast' 100%

#!/bin/bash
sleep 2
/home/stefanaru/dotfiles/scripts/workflow/mic-toggle.sh mute
/home/stefanaru/.local/bin/noisetorch -i -s alsa_input.usb-HP__Inc_HyperX_SoloCast-00.analog-stereo -t 20
pactl set-default-source 'NoiseTorch Microphone for HyperX SoloCast'

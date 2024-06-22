#!/bin/bash
/home/stefanaru/.local/bin/noisetorch -i -s alsa_input.usb-HP__Inc_HyperX_SoloCast-00.analog-stereo -t 20
sleep 2
pactl set-default-source 'NoiseTorch Microphone for HyperX SoloCast'

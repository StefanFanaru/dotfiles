#!/bin/bash

killall chrome
killall NSGClient
nmcli connection down "Gemini VPN"
i3-msg '[class=".*"] kill'
tmux kill-server

#!/bin/bash

next_meeting_text=$($HOME/.config/tmux/scripts/next_meeting.sh)
next_time="${next_meeting_text#*;}"
echo "${next_time%%;*}"

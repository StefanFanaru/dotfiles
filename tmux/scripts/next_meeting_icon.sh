#!/bin/bash

next_meeting_text=$($HOME/.config/tmux/scripts/next_meeting.sh)
echo "${next_meeting_text%%;*}"

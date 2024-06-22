#!/bin/bash

# script to list all timers in the timer_state.txt file

# the timesr are in the format: "unique id","text","start time","duration"
# id=$(date +%s)
# echo "\"$id\",\"$text\",\"$(date +%s)\",\"$total_seconds\"" >>"$HOME/.logs/timer_state.txt"
#
# using zenity to display the list of timers and their remaining time

# read the timer_state.txt file and extract the active timers then print them with zenity in a list showing the remaining time
# example row
# "1719059791","test","1719059791","3600"
timer_file="$HOME/.timers_state.csv"
# timer file is like a csv
# read the file line by line
# for each line, extract the id, text, start time, and duration
# calculate the remaining time by subtracting the current time from the start time and duration
# format the remaining time in hours, minutes, and seconds
# display the id, text, and remaining time in a zenity list dialog
timers=$(cat "$timer_file")

IFS=$'\n'
for timer in $timers; do
	# values are wrapped in double quotes, so we need to remove them
	echo "timer: " "$timer"
	timer=$(echo "$timer" | tr -d '"')
	IFS="," read -r start_time text duration <<<"$timer"
	current_time=$(date +%s)
	remaining_time=$((start_time + duration - current_time))
	if [ $remaining_time -gt 0 ]; then
		remaining_time_formated=$(date -u -d @${remaining_time} +"%H:%M:%S")
		formatted_timers+=("$text" "$remaining_time_formated")
	fi
done
IFS=$'\n'

# display the list of active timers in a zenity list
zenity --list --title="Active Timers" --text="List of active timers and their remaining time" --column="Text" --column="Remaining Time" "${formatted_timers[@]}"

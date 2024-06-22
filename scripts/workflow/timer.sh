#!/bin/bash

# Function to display an error message
error_message() {
	zenity --error --text="$1"
	exit 1
}

# Prompt the user to enter the timer duration using a form
duration=$(zenity --forms --title="Set Timer" --text="Configure" \
	--add-entry="Text" \
	--add-entry="Hours" \
	--add-entry="Minutes" \
	--add-entry="Seconds")

# Check if the user canceled the input
if [ -z "$duration" ]; then
	exit 0
fi

# Parse the input duration
IFS="|" read -r text hours minutes seconds <<<"$duration"

# Validate the input values
if ! [[ "$hours" =~ ^[0-9]*$ ]] || ! [[ "$minutes" =~ ^[0-9]*$ ]] || ! [[ "$seconds" =~ ^[0-9]*$ ]]; then
	error_message "Invalid duration entered. Please enter positive integers."
fi

# Default values if no input provided
text=${text:-"Time's up!"}
hours=${hours:-0}
minutes=${minutes:-0}
seconds=${seconds:-0}

# Calculate the total duration in seconds
total_seconds=$((hours * 3600 + minutes * 60 + seconds))

# Check if the total duration is greater than zero
if [ "$total_seconds" -le 0 ]; then
	error_message "The duration must be greater than zero."
fi

# write the timer text and starting time to $HOME/.logs/timer.log in the format: "unique id","text","start time","duration"
# The unique id can be generated using the date command
start_time=$(date +%s)
printf "\"$start_time\",\"$text\",\"$total_seconds\"\n" >>"$HOME/.timers_state.csv"

# Wait for the specified duration
sleep "$total_seconds"

# Play a sound notification (you can replace the sound file with any other .wav file)
paplay /usr/share/sounds/freedesktop/stereo/complete.oga &

# Display the notification
zenity --info --title="Time's up" --text="$text"

# Remove the timer entry from the log file
sed -i "/^\"$start_time\"/d" "$HOME/.timers_state.csv"

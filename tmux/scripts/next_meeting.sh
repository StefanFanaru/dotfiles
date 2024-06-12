#!/bin/bash
CACHE_FILE="/tmp/meeting_cache.json"
CACHE_DURATION=30 # Cache duration in seconds
LOCK_FILE="$CACHE_FILE.lock"

NERD_FONT_FREE=""
NERD_FONT_MEETING=""
NERD_FONT_ERROR=""

is_cache_fresh() {
	if [ ! -f "$CACHE_FILE" ]; then
		return 1 # Cache doesn't exist
	fi
	local last_modified=$(date -r "$CACHE_FILE" +%s)
	local current_time=$(date +%s)
	local age=$((current_time - last_modified))
	if [ "$age" -lt "$CACHE_DURATION" ]; then
		return 0 # Cache is fresh
	else
		return 1 # Cache is stale
	fi
}

read_from_cache() {
	cat "$CACHE_FILE"
}

meeting_started_notification() {
	title="$1"
	# if [ "$title" == "ERROR" ]; then
	# 	return
	# fi
	play /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
	zenity --info --title="Meeting stared" --text="$title" &
}

fetch_json() {
	if is_cache_fresh; then
		cached_response=$(read_from_cache)
		echo "$cached_response"
		exit 0
	fi
	response=$(curl -sk "https://localhost:7048/api/Meetings/next")
	customText=$(echo "$response" | jq -r '.customText')
	if [ "$customText" == "NOW" ]; then
		cached_response=$(read_from_cache)
		customTextCached=$(echo "$cached_response" | jq -r '.customText')
		if [ -z "$customTextCached" ]; then
			title=$(echo "$response" | jq -r '.title')
			meeting_started_notification "$title"
		fi
	fi
	write_to_cache "$response"
	echo "$response"
}

write_to_cache() {
	echo "$1" >"$CACHE_FILE"
}

acquire_lock() {
	# Attempt to create the lock file, if it already exists, wait and try again
	while true; do
		if ln -s $$ "$LOCK_FILE" 2>/dev/null; then
			return 0
		fi
		sleep 0.1
	done
}

release_lock() {
	rm -f "$LOCK_FILE"
}

acquire_lock

json=$(fetch_json)
# if json is empty, exit
if [ -z "$json" ]; then
	release_lock
	echo "$NERD_FONT_ERROR;ERROR;#8aadf4"
	exit 0
fi

# Parse JSON and extract time field
title=$(echo "$json" | jq -r '.title')
time=$(echo "$json" | jq -r '.time')
color=$(echo "$json" | jq -r '.color')
customText=$(echo "$json" | jq -r '.customText')

# Calculate time difference in seconds
current_time=$(date -u +%s)          # Current time in UTC
meeting_time=$(date -ud "$time" +%s) # Meeting time in UTC
time_diff=$((meeting_time - current_time))

# Calculate hours and minutes
hours=$((time_diff / 3600))
minutes=$(((time_diff + 59) / 60))
minutes=$((minutes % 60))

# Choose the icon based on the time left
if [ "$hours" -eq 0 ] && [ "$minutes" -le 5 ]; then
	icon="$NERD_FONT_MEETING"
else
	icon="$NERD_FONT_FREE"
fi

if [ $time_diff -le 0 ] && [ "$customText" != "NOW" ] && [ "$title" != "ERROR" ]; then
	customText="NOW"
	meeting_started_notification "$title"
	# rewire the cache to have and updated json with customText = "NOW"
	json=$(echo "$json" | jq ".customText = \"NOW\"")
	write_to_cache "$json"
fi

result=""

if [ -z "$customText" ]; then
	if [ "$hours" -eq 0 ]; then
		result=$(printf "%s;%dm;%s\n" $icon $minutes $color)
	else
		result=$(printf "%s;%dh %dm;%s\n" $icon $hours $minutes $color)
	fi
else
	result="$icon;$customText;$color"
fi

echo "$result"

release_lock

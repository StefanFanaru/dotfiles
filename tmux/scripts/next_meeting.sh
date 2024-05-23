#!/bin/bash
CACHE_FILE="/tmp/meeting_cache.json"
CACHE_DURATION=30 # Cache duration in seconds
LOCK_FILE="$CACHE_FILE.lock"

NERD_FONT_FREE=""
NERD_FONT_MEETING=""

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

fetch_json() {
	curl -sk "https://localhost:7048/api/Meetings/next"
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

if is_cache_fresh; then
	cached_result=$(read_from_cache)
	echo "$cached_result"
	# Release lock before exiting
	release_lock
	exit 0
fi

json=$(fetch_json)

# Parse JSON and extract time field
time=$(echo "$json" | jq -r '.time')
color=$(echo "$json" | jq -r '.color')
customText=$(echo "$json" | jq -r '.customText')

# Calculate time difference in seconds
current_time=$(date -u +%s)          # Current time in UTC
meeting_time=$(date -ud "$time" +%s) # Meeting time in UTC
time_diff=$((meeting_time - current_time))

# Calculate hours and minutes
hours=$((time_diff / 3600))
minutes=$(((time_diff % 3600) / 60))

# Choose the icon based on the time left
if [ "$hours" -eq 0 ] && [ "$minutes" -lt 31 ]; then
	icon="$NERD_FONT_MEETING"
else
	icon="$NERD_FONT_FREE"
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

write_to_cache "$result"
echo "$result"

release_lock

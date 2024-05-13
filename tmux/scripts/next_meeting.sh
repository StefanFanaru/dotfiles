#!/bin/bash
CACHE_FILE="/tmp/meeting_cache.json"
CACHE_DURATION=60 # Cache duration in seconds
LOCK_FILE="$CACHE_FILE.lock"

NERD_FONT_FREE="󱁕"
NERD_FONT_MEETING="󰤙"

# Function to check if the cache is fresh
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

# Function to read from cache
read_from_cache() {
    cat "$CACHE_FILE"
}

# Function to fetch JSON from the specified URL
fetch_json() {
    curl -sk "https://localhost:7048/api/Meetings/next"
}

# Function to write to cache
write_to_cache() {
    echo "$1" >"$CACHE_FILE"
}

# Function to acquire lock
acquire_lock() {
    # Attempt to create the lock file, if it already exists, wait and try again
    while true; do
        if ln -s $$ "$LOCK_FILE" 2>/dev/null; then
            return 0
        fi
        sleep 0.1
    done
}

# Function to release lock
release_lock() {
    rm -f "$LOCK_FILE"
}

# Main script starts here

# Acquire lock
acquire_lock

# Check if cache is fresh
if is_cache_fresh; then
    cached_result=$(read_from_cache)
    echo "$cached_result"
    # Release lock before exiting
    release_lock
    exit 0
fi

# Fetch JSON
json=$(fetch_json)

# Parse JSON and extract time field
time=$(echo "$json" | jq -r '.time')
color=$(echo "$json" | jq -r '.color')

# Extract the day of the meeting
meeting_day=$(date -d "$time" +%Y-%m-%d)

# Calculate time difference in seconds
current_time=$(date +%s)
meeting_time=$(date -d "$time" +%s)
time_diff=$((meeting_time - current_time))

# Calculate hours and minutes
hours=$((time_diff / 3600))
minutes=$(((time_diff % 3600) / 60))

# Choose the icon based on the time left
if [ "$hours" -eq 0 ] && [ "$minutes" -lt 15 ]; then
    icon="$NERD_FONT_MEETING"
else
    icon="$NERD_FONT_FREE"
fi

result=""
# Output the icon and time left
if [ "$meeting_day" == "$(date -d 'tomorrow' +%Y-%m-%d)" ]; then
    result="$icon;TMRW;$color"
elif [ "$hours" -gt 0 ]; then
    result=$(printf "%s;%02d:%02d;%s\n" $icon $hours $minutes $color)
else
    result="$icon;$(date -d @$meeting_time +'%H:%M');$color"
fi

write_to_cache "$result"
echo "$result"

# Release lock
release_lock


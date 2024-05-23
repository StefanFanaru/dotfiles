#!/bin/bash

json=$(curl -sk "https://localhost:7048/api/Meetings/next")

time_utc=$(jq -r '.time' <<<"$json")
time_utc=$(jq -r '.time' <<<"$json")
time_local=$(TZ="Europe/Bucharest" date -d "$time_utc UTC" +"%H:%M")
date_local=$(TZ="Europe/Bucharest" date -d "$time_utc UTC" +"%Y-%m-%d")
date_local_pretty=$(TZ="Europe/Bucharest" date -d "$time_utc UTC" +"%d %b")

# Get the current date in Europe/Bucharest timezone
current_date=$(TZ="Europe/Bucharest" date +"%Y-%m-%d")

# Determine the format based on whether the event is today
if [ "$date_local" == "$current_date" ]; then
	starting_at="$time_local"
else
	starting_at="$time_local - $date_local_pretty"
fi

# Use jq to rename and reorder fields
json_modified=$(jq --arg starting_at "$starting_at" '{
  title: .title,
  starting: $starting_at,
  organizer: .organizer,
  attendees: .attendees,
  optionalAttendees: .optionalAttendees
}' <<<"$json")

result=$(echo "$json_modified" | yq -P eval | sed 's/^/    /')
result=$(echo -e "\n$result\n")

echo "$result" | bat --language=yaml --style=plain
echo -e "\n"
read -n 1 -s

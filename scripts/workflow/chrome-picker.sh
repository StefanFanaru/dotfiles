#!/bin/bash
# Extract the URL from the custom protocol
URL=$(echo "$1" | sed 's/chromepicker://')

if [[ $URL == *"lucid.app"* ]] || [[ $URL == *"dev.azure.com/geminicad"* ]] || [[ $URL == *"scgeminicadsystems"* ]]; then
	/usr/bin/google-chrome-stable --profile-directory="Profile 3" "$URL"
else
	is_teams_lectra=$(echo "$URL" | grep -o '@teamslectra')
	if [[ $is_teams_lectra ]]; then
		# remove @teamslectra from the URL at the end
		URL=${URL//@teamslectra/}
		if [[ $URL == *"lectra33"* ]]; then
			/usr/bin/google-chrome-stable --profile-directory="Profile 3" "$URL"
		else
			/usr/bin/google-chrome-stable --profile-directory="Profile 2" "$URL"
		fi
	else
		/usr/bin/google-chrome-stable --profile-directory="Profile 2" "$URL"
	fi
fi

i3-msg 'workspace 1'

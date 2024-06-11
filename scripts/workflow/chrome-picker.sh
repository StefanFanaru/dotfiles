#!/bin/bash
# Extract the URL from the custom protocol
URL=$(echo $1 | sed 's/chromepicker://')
# Open the URL in the desired Chrome profile

if [[ $URL == *"dev.azure.com/geminicad"* ]] || [[ $URL == *"scgeminicadsystems"* ]]; then
	/usr/bin/google-chrome-stable --profile-directory="Profile 3" "$URL"
else
	/usr/bin/google-chrome-stable --profile-directory="Profile 2" "$URL"
fi

#!/bin/bash

# Path to the Chrome executable
CHROME_PATH="/usr/bin/google-chrome"

# Profile directory name
PROFILE_NAME="Profile 2"

# URL to open
URL="$1"

# Launch Chrome with the specific profile
"$CHROME_PATH" --profile-directory="$PROFILE_NAME" "$URL"

#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Jenkins
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Placeholder" }

# Documentation:
# @raycast.author Stefan Fanaru
# if $1 is empty string or space
if [ -z "$1" ] || [ "$1" == " " ]; then
	url="https://apogy-digital-platform.ci.eu.lectra.com/view/List/"
else
	url="https://apogy-digital-platform.ci.eu.lectra.com/view/List/job/lectra/job/gemini/job/digital-platform/job/$1/job/main-next/"
fi
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --profile-directory='Default' "$url" >/dev/null 2>&1 &

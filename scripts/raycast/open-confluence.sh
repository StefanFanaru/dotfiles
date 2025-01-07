#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Confluence
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📚

# Documentation:
# @raycast.author Stefan Fanaru

url="https://lectragroup.atlassian.net/wiki/spaces/Apogy/overview"
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --profile-directory='Default' "$url" >/dev/null 2>&1 &

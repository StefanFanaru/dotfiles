#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Storage Account
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📦
# @raycast.argument1 { "type": "text", "placeholder": "Placeholder" }

# Documentation:
# @raycast.author Stefan Fanaru

url="https://portal.azure.com/#@lectra33.onmicrosoft.com/resource/subscriptions/9abad234-7001-4b73-a9b5-c7cf5b10d3e8/resourceGroups/apogy-euw-dev-rg/providers/Microsoft.Storage/storageAccounts/apogycldeuw$1datasa/overview"
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --profile-directory='Default' "$url" >/dev/null 2>&1 &

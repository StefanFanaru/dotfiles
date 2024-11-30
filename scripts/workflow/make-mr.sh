#!/bin/bash

# Exit on errors
set -e

# Function to log messages
function log {
    echo "[INFO] $1"
}

# Function to print error message and exit
function error_exit {
    echo "[ERROR] $1" >&2
    exit 1
}

log "Starting Merge Request creation script..."

# Check for GitLab token
if [ -z "$GITLAB_TOKEN" ]; then
    error_exit "GITLAB_TOKEN environment variable is not set."
else
    log "GitLab token found."
fi

GITLAB_API_URL="https://gitlab.com/api/v4/projects"

log "Fetching project ID from GitLab"
PROJECT_ID=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_API_URL?membership=true&search=$(basename $(pwd))" | jq '.[0].id')

if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" == "null" ]; then
    error_exit "Unable to fetch project ID. Ensure the GitLab URL and token are correct."
else
    log "Project ID: $PROJECT_ID"
fi

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" == "HEAD" ]; then
    error_exit "You are in a detached HEAD state."
else
    log "Current branch: $CURRENT_BRANCH"
fi

# Get default branch
# log "Fetching default branch from remote..."
# DEFAULT_BRANCH=$(git remote show origin | grep "HEAD branch" | awk '{print $NF}')
# if [ -z "$DEFAULT_BRANCH" ]; then
#     error_exit "Unable to determine the default branch."
# else
#     log "Default branch: $DEFAULT_BRANCH"
# fi
DEFAULT_BRANCH="main-next"
log "Default branch: $DEFAULT_BRANCH"

if [ ! -z "$1" ]; then
    MR_TITLE="$1"
    log "Using the provided title: $MR_TITLE"
else
    # Get last commit message
    log "Fetching the last commit message..."
    MR_TITLE=$(git log -1 --pretty=%s)
    if [ -z "$MR_TITLE" ]; then
        error_exit "Unable to fetch the last commit message."
    else
        log "Last commit title: $MR_TITLE"
    fi
fi

# Create the MR
log "Creating the Merge Request..."
# log the --data parameter for debugging
log "Request data:
{
    \"source_branch\": \"$CURRENT_BRANCH\",
    \"target_branch\": \"$DEFAULT_BRANCH\",
    \"title\": \"$MR_TITLE\"
}"

CREATE_MR_RESPONSE=$(curl -s --request POST --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    --header "Content-Type: application/json" \
    --data "{
        \"source_branch\": \"$CURRENT_BRANCH\",
        \"target_branch\": \"$DEFAULT_BRANCH\",
        \"title\": \"$MR_TITLE\"
    }" \
    "$GITLAB_API_URL/$PROJECT_ID/merge_requests")

# Extract the MR URL
MR_URL=$(echo "$CREATE_MR_RESPONSE" | jq -r '.web_url')
if [ "$MR_URL" == "null" ]; then
    log "Response: $CREATE_MR_RESPONSE"
    error_exit "Failed to create Merge Request. Please check the response for details."
else
    MR_URL="$MR_URL/diffs"
    log "Merge Request created successfully."
    # print merge request URL with a highlight color
    echo -e "\e[30;47m$MR_URL\e[0m"
    # copy url to clipboard
    echo -n "$MR_URL" | xclip -selection clipboard
fi

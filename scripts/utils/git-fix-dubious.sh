#!/bin/bash

# Set the directory to search for Git repositories
search_dir="/x"

# Function to recursively search for Git repositories and add them to git config
search_and_add_repos() {
    local dir=$1
    local max_depth=$2
    local current_depth=$3

    # Add all Git repositories found in the current directory
    for repo in $(find "$dir" -maxdepth 1 -type d -name ".git" | sed 's/\/.git//'); do
        if [[ "$repo" != *"$search_dir/$search_dir"* ]]; then
            git config --global --add safe.directory "$repo"
            echo "Added $repo to safe.directory"
        fi
    done

    # Recursively search subdirectories if not at max depth
    if [ $current_depth -lt $max_depth ]; then
        for subdir in "$dir"/*; do
            if [ -d "$subdir" ]; then
                search_and_add_repos "$subdir" $max_depth $((current_depth+1))
            fi
        done
    fi
}

# Call the function to start searching and adding repositories
search_and_add_repos "$search_dir" 3 0

echo "Done adding Git repositories to safe.directory"


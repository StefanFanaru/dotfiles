#!/bin/bash

# File path
CONFIG_FILE="$HOME/dotfiles/alacritty/alacritty.toml"

# Sizes to toggle between
SIZE_SMALL="15.0"
SIZE_LARGE="18.0"

# Check if the file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

# Determine the current size and toggle
if grep -q "size = $SIZE_SMALL" "$CONFIG_FILE"; then
    sed -i '' "s/size = $SIZE_SMALL/size = $SIZE_LARGE/" "$CONFIG_FILE"
    echo "Font size changed to $SIZE_LARGE"
elif grep -q "size = $SIZE_LARGE" "$CONFIG_FILE"; then
    sed -i '' "s/size = $SIZE_LARGE/size = $SIZE_SMALL/" "$CONFIG_FILE"
    echo "Font size changed to $SIZE_SMALL"
else
    echo "Error: Neither size $SIZE_SMALL nor $SIZE"
fi

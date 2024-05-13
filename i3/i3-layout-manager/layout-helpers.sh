#!/bin/bash

# Function to check if the window_properties.class equals "Alacritty"
check_window_class() {
	local class=$(echo "$1" | jq -r '.container.window_properties.class')
	if [[ "$class" == "$2" ]]; then
		return 0 # Return success if the class matches
	else
		return 1 # Return failure if the class does not match
	fi
}

# Subscribe to window events using i3-msg
subscribe_to_window() {
	i3-msg -t subscribe -m '[ "window" ]' | while read -r line; do
		# Check if the JSON contains window_properties.class
		if echo "$line" | jq -e '.container.window_properties.class' >/dev/null; then
			# Check if the window class matches the provided argument
			if check_window_class "$line" "$1"; then
				echo "$1 window found!"
				pkill -f "i3-msg -t subscribe" # Terminate the i3-msg subscribe process
				break                          # Exit the loop if the window is found
			fi
		fi
	done
}

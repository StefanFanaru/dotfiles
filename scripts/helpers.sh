gcm() {
	git add .
	git commit -m "$1" && git push
}

# Function to kill a process matching '/bin/bash ./timer.sh'
killtimers() {

	PIDS=$(pgrep -f '/bin/bash ./timer.sh')

	# Check if PIDS are found
	if [ -n "$PIDS" ]; then
		echo "Killing processes:"
		# Iterate through each PID
		echo "$PIDS" | while IFS= read -r PID; do
			if [ -n "$PID" ]; then
				echo "  - PID $PID"
				# Kill the process
				kill $PID
				if [ $? -eq 0 ]; then
					echo "    Successfully killed PID $PID"
				else
					echo "    Failed to kill PID $PID"
				fi
			fi
		done
	else
		echo "No processes matching '/bin/bash ./timer.sh' found."
	fi

	rm $HOME/.timers_state.csv
}

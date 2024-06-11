#!/bin/bash

# Get text with zenity
text=$(zenity --entry --text="" --title="TODO" --width=400 --height=100)

# If text is not empty, append it to the todo file
if [ -n "$text" ]; then
	# edit todo.md and remove any empty lines at the end
	sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /mnt/f/obsidian/second-brain/Evergreen/todo.md
	echo -e "- [ ] $text" >>/mnt/f/obsidian/second-brain/Evergreen/todo.md
fi

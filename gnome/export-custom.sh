#!/bin/bash

file_name='custom.txt'

if [ -s $file_name ]; then
        # The file is not-empty.
        rm -f $file_name
        touch $file_name
fi


dconf dump /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ > $file_name
echo "Custom bindings were exported"

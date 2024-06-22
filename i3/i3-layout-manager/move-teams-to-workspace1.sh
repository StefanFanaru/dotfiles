#!/bin/bash
i3-msg "workspace number 1"
# focus right most window in workspace 1
i3-msg '[class=".*"] focus; focus right; focus right; focus right'
i3-msg 'split v'
i3-msg "workspace number 3"
i3-msg 'floating disable'
i3-msg 'move container to workspace number 1'
i3-msg "workspace number 1"
i3-msg 'move up'

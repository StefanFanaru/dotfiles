#!/bin/bash
# if [ -z "$SSH_AUTH_SOCK" ] || [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent_sock" ]; then
# 	eval $(ssh-agent -s) &>/dev/null
# fi
#
# unlink "$HOME/.ssh/agent_sock" 2>/dev/null
# ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
# export SSH_AUTH_SOCK="$HOME/.ssh/agent_sock"

if [ -z "$SSH_AUTH_SOCK" ]; then
	eval "$(ssh-agent -s)" &>/dev/null
	unlink "$HOME/.ssh/agent_sock" 2>/dev/null
	ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
elif [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent_sock" ]; then
	ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
fi

export SSH_AUTH_SOCK="$HOME/.ssh/agent_sock"

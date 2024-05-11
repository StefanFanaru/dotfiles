#!/bin/bash
if [ -z "$SSH_AUTH_SOCK" ] || [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent_sock" ]; then
    eval $(ssh-agent -s) &>/dev/null
fi

unlink "$HOME/.ssh/agent_sock" 2>/dev/null
ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
export SSH_AUTH_SOCK="$HOME/.ssh/agent_sock"


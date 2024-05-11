#!/bin/bash
if [ -z "$SSH_AUTH_SOCK" ] ; then
    if [ ! -z "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent_sock" ] ; then
        unlink "$HOME/.ssh/agent_sock" 2>/dev/null
        ln -s "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
        export SSH_AUTH_SOCK="$HOME/.ssh/agent_sock"
    else
        eval $(ssh-agent -s) &>/dev/null
    fi
fi

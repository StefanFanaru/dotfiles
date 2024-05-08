#!/bin/bash

kdp() {
	kgp | fzf | awk '{print $1}' | xargs -n 1 kubectl describe pod
}

klp() {
	pod="$(kubectl get po -o wide | tail -n+2 | fzf -n1 --preview='kubectl logs --tail=20 --all-containers=true {1}' --preview-window=down:50%:hidden --bind=ctrl-p:toggle-preview --header="^P: Preview Logs" | awk '{print $1}')"
	if [[ -n $pod ]]; then
		kubectl logs --all-containers=true --timestamps --since=30m "$pod"
	fi
}


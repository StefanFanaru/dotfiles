#!/bin/bash

find_deployment_name() {
	substring=$(echo "$1" | cut -d '-' -f 1)
	echo "$substring"
}

kdp() {
	# kgp | fzf | awk '{print $1}' | xargs -n 1 kubectl get pod -o yaml | yq . | bat --color=always
	pod=$(kgp | fzf | awk '{print $1}')
	describe=$(kubectl describe pod "$pod")
	echo "$describe" | bat --color=always --language="yaml"

}

klp() {
	pod="$(kubectl get po -o wide | tail -n+2 | fzf -n1 --preview='kubectl logs --tail=20 --all-containers=true {1}' --preview-window=down:50%:hidden --bind=ctrl-p:toggle-preview --header="^P: Preview Logs" | awk '{print $1}')"
	if [[ -n $pod ]]; then
		deployment_name=$(find_deployment_name "$pod")
		stern "$deployment_name" --since 60m --exclude="api/status" --exclude="Healthy" --exclude="Hosting.Diagnostics" --highlight="error" --highlight="exception"
	fi
}

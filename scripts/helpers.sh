cf() {
	local dir
	local preffered_dirs=(~/work/digital-platform ~/work/ ~/personal/ ~/ ~/dotfiles/)

	if [ -n "$1" ]; then
		dir=$(fd . --type d --max-depth 2 "${preffered_dirs[@]}" | fzf --preview 'tree -C -L 2 {}' --query "$1" --bind 'result:accept')
	else
		dir=$(fd . --type d --max-depth 2 "${preffered_dirs[@]}" | fzf --preview 'tree -C -L 2 {}')
	fi

	if [ -n "$dir" ]; then
		cd "$dir" || (echo "Directory $1 not found" && return 1)
	else
		echo "Directory $1 was not found" && return 1
	fi
}

cv() {
	cf "$1"
	local cf_exit_code=$?
	if [ $cf_exit_code -eq 1 ]; then
		echo "Directory $1 was not found" && return 1
	fi
	\nvim .
}

fv() {
	file=$(fzf --preview 'bat --style=numbers --color=always {}')
	if [ -n "$file" ]; then
		\nvim "$file"
	fi
}

gcm() {
	git commit -am "$1" && git push
}

kdp() {
	kgp | fzf | awk '{print $1}' | xargs -n 1 kubectl describe pod
}

klp() {
	pod="$(kubectl get po -o wide | tail -n+2 | fzf -n1 --preview='kubectl logs --tail=20 --all-containers=true {1}' --preview-window=down:50%:hidden --bind=ctrl-p:toggle-preview --header="^P: Preview Logs" | awk '{print $1}')"
	if [[ -n $pod ]]; then
		kubectl logs --all-containers=true --timestamps --since=30m "$pod"
	fi
}

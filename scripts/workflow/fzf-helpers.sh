#!/bin/bash

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

fzfalias() {
	CMD=$(
		(
			(alias)
			(functions | grep "()" | cut -d ' ' -f1 | grep -v "^_")
		) | fzf | cut -d '=' -f1
	)

	eval "$CMD"
}

fzfenv() {
	local out
	out=$(env | fzf)
	echo $(echo "$out" | cut -d= -f2)
}

fzfkill() {
	local pid
	pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

	if [ "x$pid" != "x" ]; then
		echo "$pid" | xargs kill -"${1:-9}"
	fi
}


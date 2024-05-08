gcm() {
	git commit -am "$1" && git push
}

cat() {
    if [ "$1" = "-v" ]; then
        command cat -v "${@:2}"
    else
        command bat "$@"
    fi
}


# /bin/bash

cdp() {
    local -A repos
    repos=(
        admin admin
        e2e e2e-test
        embroidery embroidery
        identity identity
        nx nx-apps
        pingo pingo
        storage storage
        usagehub usagehub
        compute compute
        emailsender email-sender
        functions function-apps
        jobscheduler jobscheduler
        packages packages
        pluto pluto
        tools tools
    )

    local key="$1"
    if [[ "$key" = "-h" ]]; then
        echo "Possible arguments:"
        for k in ${(k)repos}; do
            echo "$k"
        done
        return 0
    else
        if [[ -v repos[$key] ]]; then
            cd "/x/Lectra/digital-platform/$repos[$key]" || return 1
        else
            echo "Key '$key' not found"
            return 1
        fi
    fi
}

vimp(){
    cdp "$1"
    vim .
}

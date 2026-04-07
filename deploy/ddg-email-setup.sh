#!/usr/bin/env bash

# $1 : verbose flag
function prepare_app_build() {
    local verbose="$1"

    wget -q https://raw.githubusercontent.com/csolallo/ddg-email/refs/heads/main/duckduckgo-token.txt
    create_driver_script "$verbose"
}

# $1 : verbose flag
function create_driver_script() {
    local verbose="$1"

    sc=$(cat <<EOF
#!/data/data/com.termux/files/usr/bin/bash

token=CAT_HERE

curl -sS 'https://quack.duckduckgo.com/api/email/addresses' \
   -X 'POST' \
   -H 'accept: */*' \
   -H 'accept-language: en-US,en;q=0.9' \
   -H 'authorization: Bearer '"$token" \
   -H 'origin: https://duckduckgo.com' \
   -H 'priority: u=1, i' \
   -H 'referer: https://duckduckgo.com/' \
   -o '/data/data/com.termux/files/home/storage/shared/Documents/Xfer/email.json'
EOF
)
    if [ "$verbose" == "1" ]; then
        echo "$sc"
    fi

    echo "$sc" > duckduckgo-email.sh
    sed -i 's/CAT_HERE/\$(cat \.\/duckduckgo-token\.txt)/g' ./duckduckgo-email.sh
    chmod +x duckduckgo-email.sh
}

# $1 : working folder
# $2 : destination folder
function move_app_to_destination() {
    local working="$1"
    local dest="$2"

    mkdir -p $dest
    cp -a $working/duckduckgo-*.* $dest/
}

export -f prepare_app_build
export -f move_app_to_destination
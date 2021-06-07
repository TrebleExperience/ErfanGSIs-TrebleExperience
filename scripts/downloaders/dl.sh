#!/bin/bash

# Most part of this program which is used to download files from Mega.NZ and MediaFire is under Copyright to stck-lzm at https://github.com/stck-lzm/badown

function gdrive() {
    FILE_ID="$(echo "${1:?}" | sed -r 's/.*([0-9a-zA-Z_-]{33}).*/\1/')"
    CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$FILE_ID" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
    aria2c -c -s16 -x16 -m10 --check-certificate=false --load-cookies /tmp/cookies.txt -d "$2" -o "$3" "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$FILE_ID" > /dev/null 2>&1
}

if [[ "$1" == *"drive.google.com"* ]]; then
    gdrive "$1" "$2" "$3"
fi

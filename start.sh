#!/bin/bash

env

set -x

set_val() {
    if [ -n "$2" ]; then
        echo "set '$2' to '$1'"
        sed -i "s/<$2>[^<]*<\/$2>/<$2>$1<\/$2>/g" /etc/icecast2/icecast.xml
    else
        echo "Setting for '$1' is missing, skipping." >&2
    fi
}

set_val $ICECAST_SOURCE_PASSWORD source-password
set_val $ICECAST_RELAY_PASSWORD  relay-password
set_val $ICECAST_ADMIN_PASSWORD  admin-password
set_val $ICECAST_PASSWORD        password
set_val $ICECAST_HOSTNAME        hostname

set -e

sudo -Eu icecast2 icecast2 -n -c /etc/icecast2/icecast.xml &

mkdir -p "audio"

declare -A PIDS

while true; do
    for USERNAME in ${TWITCH_USERNAMES}; do
        echo "Monitoring Twitch stream for user: ${USERNAME}"

        if ! ps -p ${PIDS[$USERNAME]} >/dev/null 2>&1; then
            echo "Starting stream capture for user: ${USERNAME}"

            timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
            output_file="${USERNAME}_${timestamp}.mp3"

            if $SAVE_TO_FILE; then
                mkdir -p "audio/$USERNAME"
                yt-dlp -q -o - "https://www.twitch.tv/${USERNAME}" 2>/dev/null | \
                tee >(ffmpeg -i pipe:0 -f mp3 "icecast://source:${ICECAST_PASSWORD}@localhost:8000/${USERNAME}" -loglevel warning) | \
                ffmpeg -i pipe:0 -f mp3 "audio/$USERNAME/$output_file" -loglevel warning &
            else
                yt-dlp -q -o - "https://www.twitch.tv/${USERNAME}" 2>/dev/null | \
                ffmpeg -i pipe:0 -f mp3 "icecast://source:${ICECAST_PASSWORD}@localhost:8000/${USERNAME}" -loglevel warning &
            fi

            PIDS[$USERNAME]=$!
        else
            echo "Stream capture for user ${USERNAME} is already running"
        fi
    done

    sleep 60
done
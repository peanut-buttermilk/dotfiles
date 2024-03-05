#!/bin/bash -x

export DISPLAY=":0"

cleanup() {
    xrandr --query | grep " disconnected" | cut -d" " -f1 | while read line; do
        xrandr --output "$line" --off
    done
}

autodetect() {
    DOTFILES=/home/bcherukuri/dotfiles
    MONITORS=$(xrandr --query | grep " connected" | sort | cut -d' ' -f1 | tr -d '\n')
    CONFIG=${DOTFILES}/udev/scripts/xrandr/${MONITORS}.sh
    
    if [ -f $CONFIG ]; then
        $CONFIG
    else
        echo "$CONFIG doesn't exist, running xrandr --auto"
        xrandr --auto
    fi
}

cleanup
autodetect


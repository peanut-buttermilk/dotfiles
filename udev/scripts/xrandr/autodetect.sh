#!/bin/bash -x

#!/bin/bash
DOTFILES=/home/bcherukuri/dotfiles
MONITORS=$(xrandr --query | grep " connected" | sort | cut -d' ' -f1 | tr -d '\n')
CONFIG=${DOTFILES}/udev/scripts/xrandr/${MONITORS}.sh

if [ -f $CONFIG ]; then
    $CONFIG
else
    echo "$CONFIG doesn't exist, runningg xrandr --auto"
    xrandr --auto
fi


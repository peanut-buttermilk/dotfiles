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
    SHA=$(hwinfo --monitor | awk -F': ' '/Unique ID:/{print $2}' | sort | tr -d '\n' | sha256sum | awk '{print $1}')       

    CONFIG=${DOTFILES}/udev/scripts/xrandr/config/${MONITORS}-${SHA}.sh
    
    if [ ! -f $CONFIG ]; then
        echo "$CONFIG doesn't exist, running xrandr --auto"
        echo "#!/bin/sh -x" >> $CONFIG
        echo "xrandr --auto" >> $CONFIG
        chmod +x $CONFIG
    fi

    $CONFIG
}

reload_i3() {
    /usr/bin/i3-msg restart
}

cleanup
autodetect
# reload_i3


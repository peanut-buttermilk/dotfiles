#!/bin/bash -x

umask 002
export DISPLAY=":0"

cleanup() {
    xrandr --query | grep " disconnected" | cut -d" " -f1 | while read line; do
        xrandr --output "$line" --off
    done
}

# Function to acquire a lock.
lock() {
    DOTFILES="/home/bcherukuri/dotfiles"
    CONFIG="${DOTFILES}/udev/scripts/xrandr/config/"
    local lockfile="$CONFIG/xrandr-autodetect-sh.lock"
    exec 200>$lockfile
    sudo chgrp udevscript $lockfile

    if ! flock -n 200; then
        echo "Another instance of the script is running."
        exit 1
    fi
    # The lock is now acquired and will be automatically
    # released when the script exits or when the file descriptor
    # is explicitly closed.
}

# Function to release the lock.
unlock() {
    # Explicitly release the lock by closing the file descriptor.
    flock -u 200
    exec 200>&-
}

autodetect() {
    DOTFILES=/home/bcherukuri/dotfiles
    MONITORS=$(xrandr --query | grep " connected" | sort | cut -d' ' -f1 | tr -d '\n')
    SHA=$(hwinfo --monitor | awk -F': ' '/Unique ID:/{print $2}' | sort | tr -d '\n' | sha256sum | awk '{print $1}')       

    CONFIG_ANY=$(ls -rt ${DOTFILES}/udev/scripts/xrandr/config/${MONITORS}-*.sh | tail -1)
    CONFIG=${DOTFILES}/udev/scripts/xrandr/config/${MONITORS}-${SHA}.sh
    
    if [ ! -f "$CONFIG" ]; then
        if [ "$MONITORS" = "" ]; then
            xrandr --auto
            return
        elif [ -n "$CONFIG_ANY" ]; then
            cp "$CONFIG_ANY" "$CONFIG"
        else
            echo "$CONFIG doesn't exist, running xrandr --auto"
            echo "#!/bin/sh -x" >> "$CONFIG"
            echo "xrandr --auto" >> "$CONFIG"
            chmod +x "$CONFIG"
        fi
    fi

    "$CONFIG"

}

reload_i3() {
    /usr/bin/i3-msg restart
}

# give it a second for all the monitors to be connected
lock
sleep 2

cleanup
autodetect
# reload_i3
unlock


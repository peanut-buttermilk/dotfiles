#!/usr/bin/env bash

# Terminate already running bar instances
polybar-msg cmd quit
# Alternatively, if IPC is not working, you can uncomment the following:
# killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar on each detected monitor
xrandr --query | grep " connected" | grep -v "None" | cut -d" " -f1 | while read monitor; do
    echo "Monitor: $monitor" | tee -a /tmp/polybar-$moniotr.log
    MONITOR=$monitor polybar --reload $monitor 2>&1 | tee -a /tmp/polybar-$monitor.log & disown
done

echo "Bars launched..."


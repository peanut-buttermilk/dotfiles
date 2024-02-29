#!/bin/sh
status=$(bluetoothctl show | grep -i "powered: yes" | cut -d' ' -f 2)

if [ "x$status" = "xyes" ]
then
    echo "󰂯"
else
    echo "󰂲"
fi


#!/bin/sh

status=$(globalprotect show --status | awk '{print $4}')
echo $status

if [ x$status = "xDisconnected" ]; then
    echo "󱙱"
elif [ x$status = "xDisconnected" ]; then
    echo "󱎚"
else
    echo "󰣯"
fi

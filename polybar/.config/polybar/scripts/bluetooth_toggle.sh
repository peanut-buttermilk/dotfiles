#!/bin/sh

# Get the current Bluetooth power status
status=$(bluetoothctl show | grep -i "Powered:" | awk '{print $2}')

# Toggle the Bluetooth status based on the current status
if [ "$status" = "yes" ]; then
    # Bluetooth is on, turn it off
    echo -e 'power off\nexit' | bluetoothctl
    echo "Bluetooth has been turned off."
else
    # Bluetooth is off, turn it on
    echo -e 'power on\nexit' | bluetoothctl
    echo "Bluetooth has been turned on."
fi


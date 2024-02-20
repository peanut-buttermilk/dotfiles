#!/bin/bash

# The direction of brightness adjustment (+/-)
direction=$1

# The minimum brightness allowed
min_brightness=5

# Current brightness and maximum brightness
current_brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)

# Calculate minimum brightness in terms of the max_brightness
min_brightness_value=$((max_brightness * min_brightness / 100))

if [ "$direction" = "up" ]; then
    # Increase brightness
    brightnessctl set +5%
elif [ "$direction" = "down" ]; then
    # Decrease brightness but check if it's above the minimum threshold
    if [ "$current_brightness" -gt "$min_brightness_value" ]; then
        brightnessctl set 5%-
    fi
fi


#!/bin/bash

# # This script listens for Dunst notifications and focuses the corresponding window
# 
# # Listen for click events on Dunst notifications
# dbus-monitor --session "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged'" |
#   while read -r line; do
#     echo "event: $line"
#     if [[ $line == *"string \"click_action\""* ]]; then
#       # Extract window ID from the notification
#       window_id=$(echo "$line" | grep -oP '(?<=uint32 )\d+')
#       # Focus the window
#       echo i3-msg "[id=$window_id] focus"
#       i3-msg "[id=$window_id] focus"
#     fi
#   done

#!/bin/bash

# This script listens for Dunst notifications to close and focuses the corresponding window

# Start Dunst if not already running
# pgrep -x dunst >/dev/null || dunst &

# Listen for signals indicating that a notification has been closed
dbus-monitor --session "type='signal',interface='org.freedesktop.Notifications',member='NotificationClosed'" |
  while read -r line; do
    echo "$line"
    if [[ $line == *"uint32"* ]]; then
      # Extract notification ID from the signal
      notification_id=$(echo "$line" | grep -oP '(?<=uint32 )\d+')
      # Extract window ID from the notification ID
      window_id=$(echo "$notification_id" | awk '{print $1 + 1}') # Assuming notification IDs are consecutive integers starting from 1
      # Focus the window
      i3-msg "[id=$window_id] focus"
    fi
  done

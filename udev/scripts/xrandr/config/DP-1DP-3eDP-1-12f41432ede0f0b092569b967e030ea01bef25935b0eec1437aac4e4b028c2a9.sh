#!/bin/sh -x
xrandr --auto
xrandr --output DP-3 --primary --auto --output DP-1 --auto --right-of DP-3 --output eDP-1 --auto --below DP-3

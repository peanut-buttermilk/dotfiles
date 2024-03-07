#!/bin/sh -x
xrandr --auto
xrandr --output DP-1 --primary --auto --output DP-3 --auto --left-of DP-1 --output eDP-1 --auto --right-of DP-1

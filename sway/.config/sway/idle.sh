#!/bin/bash
swayidle -w \
	timeout 1800 '~/.config/sway/lock.sh' \
	timeout 1805 'swaymsg "output * power off"' \
	resume 'swaymsg "output * power on"'


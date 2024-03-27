#!/bin/bash -x
#
umask 002
export DISPLAY=":0"

reload_i3() {
    /usr/bin/i3-msg restart
}

# give it a second for all the monitors to be connected
sleep 2

reload_i3


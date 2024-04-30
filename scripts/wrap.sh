#!/usr/bin/env bash
wrap() {
    local sed_command='s/^/\t/'

    echo "[Start] starting $1"

    # Start the command, tee its output to both sed and stdout, then stream to sed
    "$@" 2>&1 | sed -e "$sed_command" >&2

    echo "[End] ending $1"
}

wrap pwd
wrap date

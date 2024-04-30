#!/usr/bin/env bash

refresh_applications() {
    update-desktop-database -v ~/.local/share/applications
}

wrap refresh_applications


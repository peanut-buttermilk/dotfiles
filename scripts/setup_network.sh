#!/usr/bin/env bash

setup_network() {
    sudo systemctl enable NetworkManager.service
    sudo systemctl disable iwd.service
    sudo systemctl stop iwd.service
    sudo systemctl start NetworkManager.service
}

wrap setup_network

#!/usr/bin/env bash

enable_power_save() {
    sudo systemctl stop tlp.service
    sudo cp ./tlp/etc/tlp.conf /etc/tlp.conf
    sudo systemctl enable tlp.service
    sudo systemctl start tlp.service

    sudo powertop --auto-tune
}

wrap enable_power_save

#!/usr/bin/env bash

install_udev_rules() {
    sudo cp -rv ~/dotfiles/udev/rules.d/* /etc/udev/rules.d/
    sudo groupadd udevscript
    sudo usermod -aG udevscript bcherukuri
    sudo usermod -aG udevscript root
}

wrap install_udev_rules

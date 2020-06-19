#!/bin/sh

msg "Starting udevd..."

if [ ! -x /sbin/udevd ]; then
    msg_warn "cannot find udevd!"
    return 0
fi

udevd --daemon
udevadm trigger --action=add --type=subsystems
udevadm trigger --action=add --type=devices
udevadm settle

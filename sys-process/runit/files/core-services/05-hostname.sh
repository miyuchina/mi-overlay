#!/bin/sh

HOSTNAME="${HOSTNAME:-gentoo}"

[ -r /etc/hostname ] && read -r HOSTNAME < /etc/hostname

msg "Setting hostname to '${HOSTNAME}'..."
printf "%s" "$HOSTNAME" > /proc/sys/kernel/hostname

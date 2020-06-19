#!/bin/sh

msg "Loading sysctl settings..."

for conf in /run/sysctl.d/*.conf \
            /etc/sysctl.d/*.conf \
            /usr/lib/sysctl.d/*.conf \
            /etc/sysctl.conf; do
    [ -f "$conf" ] || continue

    case $seen in *" ${conf##*/} "*) continue; esac
    seen=" $seen ${conf##*/}"
    sysctl -p "$conf"
done

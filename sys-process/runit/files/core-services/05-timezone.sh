#!/bin/sh

if [ -n "${TIMEZONE}" ]; then
    msg "Setting timezone to '${TIMEZONE}'..."
    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
fi

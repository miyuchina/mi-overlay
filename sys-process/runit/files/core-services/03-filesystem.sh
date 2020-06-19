#!/bin/sh

msg "Remounting rootfs as read-only..."
mount -o remount,ro / || sos

if [ -x /sbin/btrfs ] || [ -x /bin/btrfs ]; then
    msg "Activating btrfs devices..."
    btrfs device scan || sos
fi

msg "Checking filesystems..."
fsck -ATat noopts=_netdev
[ $? -gt 1 ] && sos

msg "Mounting rootfs as read-write..."
mount -o remount,rw / || sos

msg "Mounting all local filesystems..."
mount -a || sos

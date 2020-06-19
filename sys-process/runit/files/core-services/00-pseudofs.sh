#!/bin/sh

msg "Mounting pseudo-filesystems..."

mnt proc /proc -t proc     -o nosuid,noexec,nodev
mnt sys  /sys  -t sysfs    -o nosuid,noexec,nodev
mnt run  /run  -t tmpfs    -o mode=0755,nosuid,nodev
mnt dev  /dev  -t devtmpfs -o mode=0755,nosuid

mkdir -p       \
    /run/runit \
    /run/user  \
    /run/lock  \
    /run/lvm   \
    /run/log   \
    /dev/pts   \
    /dev/shm

mnt devpts     /dev/pts             -t devpts     -n -o mode=0620,gid=5,nosuid,noexec
mnt shm        /dev/shm             -t tmpfs      -n -o mode=1777,nosuid,nodev
mnt securityfs /sys/kernel/security -t securityfs -n
mnt none       /sys/fs/cgroup       -t cgroup2

#!/bin/sh

msg "Initializing random seed..."

seed=/var/lib/init/random-seed
[ -f "$seed" ] && cat "$seed" > /dev/urandom

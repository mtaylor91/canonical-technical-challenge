#!/bin/sh

mount -t devtmpfs none /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys

echo "Hello, world!"

setsid cttyhack /bin/sh

umount /dev
umount /proc
umount /sys
poweroff -f

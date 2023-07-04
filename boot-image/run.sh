#!/bin/sh
set -eux

LINUX_SOURCE="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.37.tar.xz"
LINUX_SOURCE_FILE="linux-6.1.37.tar.xz"
LINUX_SOURCE_DIR="linux-6.1.37"

BUSYBOX_SOURCE="https://busybox.net/downloads/busybox-1.36.1.tar.bz2"
BUSYBOX_SOURCE_FILE="busybox-1.36.1.tar.bz2"
BUSYBOX_SOURCE_DIR="busybox-1.36.1"

INITRAMFS_DIR="initramfs"

# Download Busybox source
if [ ! -f $BUSYBOX_SOURCE_FILE ]; then
  wget $BUSYBOX_SOURCE
fi

# Download Linux source
if [ ! -f $LINUX_SOURCE_FILE ]; then
  wget $LINUX_SOURCE
fi

# Extract Busybox source
if [ ! -d $BUSYBOX_SOURCE_DIR ]; then
  tar -xf $BUSYBOX_SOURCE_FILE
fi

# Extract Linux source
if [ ! -d $LINUX_SOURCE_DIR ]; then
  tar -xf $LINUX_SOURCE_FILE
fi

# Clean up initramfs
sudo rm -rf $INITRAMFS_DIR

# Build Busybox
if [ ! -f $BUSYBOX_SOURCE_DIR/.config ]; then
  cp busybox.config $BUSYBOX_SOURCE_DIR/.config
fi
(
  cd $BUSYBOX_SOURCE_DIR && make -j$(nproc) && make install
)

# Prepare initramfs
cp init.sh $INITRAMFS_DIR/init
mkdir -p $INITRAMFS_DIR/{dev,proc,sys}
sudo mknod -m 666 $INITRAMFS_DIR/dev/console c 5 1
sudo mknod -m 666 $INITRAMFS_DIR/dev/tty c 5 0
sudo mknod -m 666 $INITRAMFS_DIR/dev/tty0 c 4 0
sudo chown -R root:root $INITRAMFS_DIR

# Build Linux
if [ ! -f $LINUX_SOURCE_DIR/.config ]; then
    cp linux.config $LINUX_SOURCE_DIR/.config
fi
(
  cd $LINUX_SOURCE_DIR && make -j$(nproc)
)

# Run QEMU
qemu-system-x86_64 \
  -nographic -append console=ttyS0 \
  -kernel $LINUX_SOURCE_DIR/arch/x86_64/boot/bzImage

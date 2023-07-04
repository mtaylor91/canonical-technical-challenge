Canonical Technical Take Home Exercise - Solutions
==================================================

# Exercise 1: Bootable Linux image via QEMU

The boot-image subdirectory contains a shell script (run.sh) that creates and runs a
Linux kernel image with an embedded CPIO archive containing busybox and the init script.
The init script prints hello world and drops the user to a busybox shell.
When the shell is exited, the system will shut down.

# Exercise 2: Shred tool in Go

The go-shred subdirectory contains a go module which exports the Shred function.  Shred
uses direct IO (`O_DIRECT`) to bypass file system caches and write random data to a
regular file 3 times before deleting it.  This may not have the desired effect on SSDs
where write leveling may cause the data to be written to new sectors instead of
overwriting.


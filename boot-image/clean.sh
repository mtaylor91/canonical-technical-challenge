#!/bin/sh

function clean_all() {
  clean_archives
  clean_directories
}

function clean_archives() {
  rm -rf busybox-1.36.1.tar.bz2
  rm -rf linux-6.1.37.tar.xz
}

function clean_directories() {
  rm -rf busybox-1.36.1
  rm -rf linux-6.1.37
  sudo rm -rf initramfs
}

case "$1" in
  all)
    clean_all
    ;;
  archives)
    clean_archives
    ;;
  directories)
    clean_directories
    ;;
  dirs)
    clean_directories
    ;;
  *)
    clean_all
    ;;
esac

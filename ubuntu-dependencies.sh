#!/bin/sh
set -e
sudo apt-get update
sudo apt-get install -y \
  bison \
  build-essential \
  flex \
  golang-go \
  libelf-dev \
  libssl-dev \
  qemu-system \
  wget

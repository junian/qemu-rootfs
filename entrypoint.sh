#!/bin/bash

set -ex

if [ -e "$CHROOT.tar.xz" ]; then
  ./extract-tar.sh "$CHROOT"
fi

if [ -e "$CHROOT" ] && [ ! -e "$HDA_QCOW2" ]; then
  ./create-image.sh "$CHROOT"
fi

exec ./qemu.sh "$@"

#!/bin/bash

set -ex

if [ -e "$CHROOT.tar.xz" ]; then
  ./extract-tar.sh "$CHROOT"
fi

if [ -e "$CHROOT" ] && [ ! -e "$HDA" ]; then
  ./create-image.sh "$CHROOT"
fi

exec ./qemu.sh "$@"

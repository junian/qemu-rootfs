#!/bin/bash

set -ex

if [ -e "$CHROOT" ] && [ ! -e "$HDA" ]; then
  ./create-image.sh "$CHROOT"
fi

exec ./qemu.sh "$@"

#!/bin/bash

set -ex

# if HDA_SIZE starts with "+", add to computed size.
if [[ $HDA_SIZE == +* ]]; then
  BASE_SIZE=$(du -s "$CHROOT" | awk "{print int(\$1)}")
  qemu-img create "$HDA" "${BASE_SIZE}k"
  qemu-img resize "$HDA" "$HDA_SIZE"
else
  qemu-img create "$HDA" "$HDA_SIZE"
fi

mkfs.ext2 -d "$CHROOT/" "$HDA"

if [ -w "$CHROOT" ]; then
  rm -rf "$CHROOT"
fi

#!/bin/bash

set -ex

# if HDA_SIZE starts with "+", add to computed size.
if [[ $HDA_SIZE == +* ]]; then
  BASE_SIZE=$(du -s "$CHROOT" | awk "{print int(\$1)}")
  qemu-img create -f raw "$HDA_RAW" "${BASE_SIZE}k"
  qemu-img resize -f raw "$HDA_RAW" "$HDA_SIZE"
else
  qemu-img create "$HDA_RAW" "$HDA_SIZE"
fi

mkfs.ext2 -d "$CHROOT/" "$HDA_RAW"
[ -w "$CHROOT" ] && rm -rf "$CHROOT"

qemu-img convert -f raw -O qcow2 "$HDA_RAW" "$HDA_QCOW2"
[ -w "$HDA_RAW" ] && rm "$HDA_RAW"

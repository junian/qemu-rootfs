#!/bin/bash

set -ex

# TODO: Implement with --privileged
usage() {
  echo "missing --privileged" >&2
  exit 1
}

# if HDA_SIZE starts with "+", add to computed size.
if [[ $HDA_SIZE == +* ]]; then
  BASE_SIZE=$(du -s "$CHROOT" | awk "{print int(\$1)}")
  qemu-img create "$HDA" "${BASE_SIZE}k"
  qemu-img resize "$HDA" "$HDA_SIZE"
else
  qemu-img create "$HDA" "$HDA_SIZE"
fi

mkfs.ext2 "$HDA"

mkdir /mnt/hda
mount -o loop "$HDA" /mnt/hda || usage
cp -pR "$CHROOT"/* /mnt/hda
umount /mnt/hda
rmdir /mnt/hda

if [ -w "$CHROOT" ]; then
  rm -rf "$CHROOT"
fi

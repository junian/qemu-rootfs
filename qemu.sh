#!/bin/bash

set -ex

if [ -e "/dev/kvm" ]; then
  KVM="--enable-kvm"
fi

if [ ! -e "$HDA" ]; then
  echo "missing HDA=$HDA" >&2
  exit 1
fi

if [ ! -e "$KERNEL" ]; then
  echo "missing KERNEL=$KERNEL" >&2
  exit 1
fi

if [ -n "$1" ]; then
  APPEND="init=$1"
fi

exec qemu-system-x86_64 \
  -no-reboot \
  -kernel "$KERNEL" \
  -append "root=/dev/sda rw console=ttyS0 $APPEND" \
  -display none -serial stdio \
  $KVM \
  -m "$MEM" \
  -netdev type=user,id=net0 -device virtio-net-pci,netdev=net0 \
  -hda "$HDA"

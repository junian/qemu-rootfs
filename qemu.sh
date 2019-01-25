#!/bin/bash

set -ex

if [ -e "/dev/kvm" ]; then
  KVM="--enable-kvm"
fi

if [ ! -e "$HDA_QCOW2" ]; then
  echo "missing HDA_QCOW2=$HDA_QCOW2" >&2
  exit 1
fi

if [ ! -e "$KERNEL" ]; then
  echo "missing KERNEL=$KERNEL, will use container's kernel" >&2
  export KERNEL="/boot/vmlinuz-vanilla"
fi

if [ -n "$1" ]; then
  APPEND="init=$1"
fi

exec qemu-system-x86_64 \
  -no-reboot \
  -kernel "$KERNEL" \
  -append "root=/dev/sda rw console=ttyS0 panic=1 $APPEND" \
  -display none -serial stdio \
  $KVM \
  -m "$MEM" \
  -netdev type=user,id=net0 -device virtio-net-pci,netdev=net0 \
  -hda "$HDA_QCOW2"

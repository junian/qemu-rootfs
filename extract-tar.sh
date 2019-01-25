#!/bin/bash

set -ex

pushd "$CHROOT"

tar xf "$CHROOT.tar.xz"

if [ -w "$CHROOT.tar.xz" ]; then
  rm "$CHROOT.tar.xz"
fi

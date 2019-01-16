set -ex

# TODO: Implement with --privileged
usage() {
  echo "missing --privileged" >&2
  exit 1
}

SIZE=$(du -s "$CHROOT" | awk "{print int(\$1)}")
qemu-img create "$HDA" "${SIZE}k"
mkfs.ext2 "$HDA"

mkdir /mnt/hda
mount -o loop "$HDA" /mnt/hda || usage
cp -pR "$CHROOT"/* /mnt/hda
umount /mnt/hda
rmdir /mnt/hda

qemu-img resize "$HDA" +500m

if [ -w "$CHROOT" ]; then
  rm -rf "$CHROOT"
fi

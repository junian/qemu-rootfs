# qemu-rootfs

Dockerized QEMU that boots an extracted Linux rootfs.

## Development

Build Docker image.

```sh
$ docker build --tag qemu-rootfs .
```

## Usage

### debootstrap

Can be used to test rootfs created with [debootstrap](https://wiki.debian.org/Debootstrap).

```sh
$ sudo debootstrap --arch amd64 bionic /mnt/ubuntu http://archive.ubuntu.com/ubuntu/
$ echo "root:passworD1" | sudo chpasswd --root /mnt/ubuntu

$ docker run --rm -it --privileged \
      --volume "/dev/kvm:/dev/kvm" \
      --volume "/boot/vmlinuz-$(uname -r):/boot/vmlinuz:ro" \
      --volume "/mnt/ubuntu:/rootfs:ro" \
    qemu-rootfs
```

## Docker image as rootfs

Set `ROOTFS_IMAGE` to any Docker base image.

```sh
$ docker build --build-arg "ROOTFS_IMAGE=ubuntu:bionic" --tag qemu-rootfs .
$ docker run --rm -it --privileged \
      --volume "/boot/vmlinuz-$(uname -r):/boot/vmlinuz:ro" \
    qemu-rootfs
```

## Docker multi-stage build

Can also be used a base image in a multi-stage build where a rootfs is customized.

```sh
$ docker build --tag qemu-ubuntu - <<EOF
FROM ubuntu:bionic as rootfs
RUN apt-get update && apt-get install -y curl

FROM qemu-rootfs
COPY --from=rootfs / /rootfs
EOF

$ docker run --rm -it --privileged \
      --volume "/boot/vmlinuz-$(uname -r):/boot/vmlinuz:ro" \
    qemu-ubuntu
```

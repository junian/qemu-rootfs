# qemu-rootfs

Dockerized QEMU that boots an extracted Linux rootfs.

## Development

Build Docker image.

```sh
$ docker build -t qemu-rootfs .
```

## Usage

### debootstrap

Can be used to test rootfs created with [debootstrap](https://wiki.debian.org/Debootstrap).

```sh
$ sudo debootstrap --arch amd64 bionic /mnt/ubuntu http://archive.ubuntu.com/ubuntu/

$ docker run --rm -it --privileged \
	-v "/dev/kvm:/dev/kvm" \
	-v "/boot/vmlinuz-$(uname -r):/bzImage:ro" \
	-v "/mnt/ubuntu:/rootfs:ro" \
	qemu-rootfs
```

## Docker multi-stage build

Can also be used a base image in a multi-stage build where a rootfs is customized.

```
FROM qemu-rootfs as rootfs
RUN apt-get update && apt-get install -y curl

FROM qemu-rootfs
COPY --from=rootfs / /rootfs
```

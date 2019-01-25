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
      --volume "/mnt/ubuntu:/rootfs:ro" \
    qemu-rootfs
```


## Ubuntu Cloud Image

```sh
$ wget http://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64-root.tar.xz
$ docker run --rm -it --privileged \
      --volume "$PWD/ubuntu-18.04-server-cloudimg-amd64-root.tar.xz:/rootfs.tar.xz:ro" \
    qemu-rootfs
````

```sh
$ wget http://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img
$ docker run --rm -it --privileged \
      --volume "$PWD/ubuntu-18.04-server-cloudimg-amd64.img:/hda.img" \
    qemu-rootfs
````

## Docker image as rootfs

Set `ROOTFS_IMAGE` to any Docker base image.

```sh
$ docker build --build-arg "ROOTFS_IMAGE=ubuntu:bionic" --tag qemu-rootfs .
$ docker run --rm -it --privileged \
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
    qemu-ubuntu
```

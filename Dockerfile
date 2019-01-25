ARG ROOTFS_IMAGE=scratch
FROM ${ROOTFS_IMAGE} as rootfs

FROM ubuntu:18.04 as build

RUN unset UCF_FORCE_CONFFOLD; \
	export UCF_FORCE_CONFFNEW=YES; \
	ucf --purge /boot/grub/menu.lst; \
	export DEBIAN_FRONTEND=noninteractive; \
	apt-get update && \
	apt-get install -o Dpkg::Options::="--force-confnew" --force-yes -fuy \
	linux-image-4.18.0-13-generic

FROM alpine:3.8

RUN apk add --no-cache \
	bash \
	e2fsprogs \
	qemu-img \
	qemu-system-x86_64

ENV CHROOT /rootfs
ENV KERNEL /boot/vmlinuz

ENV MEM 2G
ENV HDA /hda.img
ENV HDA_SIZE +500m

COPY --from=build /boot/vmlinuz-4.18.0-13-generic /boot/vmlinuz
COPY create-image.sh .
COPY extract-tar.sh .
COPY entrypoint.sh .
COPY qemu.sh .

COPY --from=rootfs / /rootfs

ENTRYPOINT [ "./entrypoint.sh" ]

ARG ROOTFS_IMAGE=scratch
FROM ${ROOTFS_IMAGE} as rootfs


FROM alpine:3.8

RUN apk add --no-cache \
	bash \
	e2fsprogs \
	qemu-img \
	qemu-system-x86_64 \
	linux-vanilla

ENV CHROOT /rootfs
ENV KERNEL /boot/vmlinuz

ENV MEM 2G
ENV HDA_RAW /hda.img
ENV HDA_QCOW2 /hda.qcow2
ENV HDA_SIZE +500m

COPY create-image.sh .
COPY extract-tar.sh .
COPY entrypoint.sh .
COPY qemu.sh .

COPY --from=rootfs / /rootfs

ENTRYPOINT [ "./entrypoint.sh" ]

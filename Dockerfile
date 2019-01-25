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

COPY create-image.sh .
COPY entrypoint.sh .
COPY qemu.sh .

ENTRYPOINT [ "./entrypoint.sh" ]

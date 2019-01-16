FROM alpine:3.8

RUN apk add --no-cache \
	bash \
	e2fsprogs \
	qemu-img \
	qemu-system-x86_64

ENV CHROOT /rootfs
ENV KERNEL /bzImage

ENV MEM 2G
ENV HDA /hda.img

COPY create-image.sh .
COPY entrypoint.sh .
COPY qemu.sh .

ENTRYPOINT [ "./entrypoint.sh" ]

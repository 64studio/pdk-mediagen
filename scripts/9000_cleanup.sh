# unmount apt repo
umount $ROOTFS/media/apt

# TODO: setup http apt repo

# remove qemu binary
rm $ROOTFS/usr/bin/qemu-arm-static

# show used disk space
info "used disk-space:"
df -h | grep $ROOTFS

info "Completed system setup!"

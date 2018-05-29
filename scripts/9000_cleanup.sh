# unmount apt repo
umount $ROOTFS/media/apt

# setup http apt repo
# TODO: install apt-key and not do this trusted
echo "deb [trusted=yes] $REPO_URL $CODENAME main" > $ROOTFS/etc/apt/sources.list
echo "deb-src [trusted=yes] $REPO_URL $CODENAME main" >> $ROOTFS/etc/apt/sources.list

# clean up apt
# TODO: have we gone over the top?
chroot_exec apt-get autoclean
chroot_exec apt-get clean
chroot_exec apt-get purge
chroot_exec apt-get update

# remove qemu binary
# TODO: check arch
rm $ROOTFS/usr/bin/qemu-arm-static

# show used disk space
info "used disk-space:"
df -h | grep $ROOTFS

info "Completed system setup!"

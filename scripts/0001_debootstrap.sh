# debootstrap a basic Debian system
info "Debootstrapping system (first-stage)"
DEB_MIRROR="file://$PDK_REPO"
KEYRING="$PDK_REPO/dists/$CODENAME/archive-keyring.gpg"

# TODO: codename has to be buster/stretch etc
debootstrap --foreign --arch="$ARCH" --keyring="$KEYRING" "$CODENAME" "$ROOTFS" "$DEB_MIRROR"

# TODO: check arch
# copy in the ARM static binary (so we can chroot)
cp /usr/bin/qemu-arm-static $ROOTFS/usr/bin/

# actually install the packages
info "Debootstrapping system (second-stage)"
chroot_exec /debootstrap/debootstrap --second-stage


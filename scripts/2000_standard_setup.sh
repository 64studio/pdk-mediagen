# install standard packages
# TODO: fix gnupg & apt-key
# TODO: check if package available before running command
#chroot_exec apt-get install gnupg locales --yes
chroot_exec apt-get install locales debconf-utils --yes

# install archive keyring
# TODO: fix this
#chroot_exec apt-key add /media/apt/dists/$CODENAME/archive-keyring.pub

# TODO: remove after testing
#chroot_exec apt-key list

# generate locales
# TODO: remove locale package after generating
echo "en_GB.UTF-8 UTF-8" > $ROOTFS/etc/locale.gen
chroot_exec locale-gen

# install preseed
if [ -f "$PDK_WORKSPACE/$PRESEED" ]; then
  info "installing preseed $PRESEED"
  cp "$PDK_WORKSPACE/$PRESEED" "$ROOTFS/tmp/preseed.conf"
  chroot_exec debconf-set-selections /tmp/preseed.conf
  rm "$ROOTFS/tmp/preseed.conf"
fi

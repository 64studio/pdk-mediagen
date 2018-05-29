# run postinst
if [ ! -z "$POSTINST" ] && [ -f "$PDK_WORKSPACE/$POSTINST" ]; then
  info "running postinst $POSTINST"
  cp "$PDK_WORKSPACE/$POSTINST" "$ROOTFS/tmp/postinst"
  chmod +x "$ROOTFS/tmp/postinst"
  chroot_exec "/tmp/postinst"
  rm "$ROOTFS/tmp/postinst"
fi


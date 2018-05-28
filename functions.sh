info() {
  echo "I: pdk-mediagen: $*"
}

error() {
  echo "E: pdk-mediagen: $*"
}

# hack to get configuration option from pdk :-)
# TODO: implement this in pdk source
read_meta() {
  CONFNAME=$1
  CONF=$(pdk dumpmeta $PDK_COMPONENT | grep -F "$PDK_COMPONENT|" | grep -F "|$CONFNAME|" | rev | cut -d "|" -f1 | rev)
  if [ -z "$CONF" ]; then
    exit 1
  fi
  echo $CONF
}

chroot_exec() {
  LANG=C LC_ALL=C DEBIAN_FRONTEND=noninteractive chroot ${ROOTFS} $*
}


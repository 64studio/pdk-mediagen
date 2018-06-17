info() {
  echo "I: pdk-mediagen: $*"
}

error() {
  echo "E: pdk-mediagen: $*"
}

# get configuration option from pdk component file
read_meta() {
  CONFNAME=$1
  CONF=$(pdk listmeta $PDK_COMPONENT | grep -F "$CONFNAME|" | rev | cut -d "|" -f1 | rev)
  if [ -z "$CONF" ]; then
    exit 1
  fi
  echo $CONF
}

chroot_exec() {
  LANG=C LC_ALL=C DEBIAN_FRONTEND=noninteractive chroot ${ROOTFS} $*
}


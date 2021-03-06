# hostname
echo "$HOSTNAME" > $ROOTFS/etc/hostname

# hosts file
echo "127.0.0.1	localhost.localdomain	localhost
127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}" > $ROOTFS/etc/hosts

# set root password
ENCRYPTED_PASSWORD=$(mkpasswd -m sha-512 "$ROOT_PASSWORD")
chroot_exec usermod -p "${ENCRYPTED_PASSWORD}" root

# mount root filesystem
echo "/dev/mmcblk0p1	/boot	vfat	defaults	0	0
/dev/mmcblk0p2	/	ext4	defaults,noatime	0	1" > $ROOTFS/etc/fstab

# setup wired network (dhcp)
echo "
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet dhcp" >> $ROOTFS/etc/network/interfaces

# mount apt repo inside debootstrap
# TODO: confirm cleaned up
mkdir -p $ROOTFS/media/apt
mount --bind "$PDK_REPO" $ROOTFS/media/apt

# setup apt
# we can do this part trusted
echo "deb [trusted=yes] file:/media/apt $CODENAME main" > $ROOTFS/etc/apt/sources.list

# do not install recommended packages
echo "APT::Install-Recommends \"0\";
APT::Install-Suggests \"0\";" > $ROOTFS/etc/apt/apt.conf.d/99no-install-recommends-suggests

# update repo
chroot_exec apt-get update

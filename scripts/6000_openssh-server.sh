# TODO: check if package is in pdk
# install ssh server
chroot_exec apt-get install openssh-server --yes

# allow root logins
# TODO: accept configuration option
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' $ROOTFS/etc/ssh/sshd_config

# re-generate ssh keys at boot by default
no_gen_keys=$(read_meta mediagen.openssh-server.no-gen-keys)
if [ -z "$no_gen_keys" ]; then
  no_gen_keys=false
fi

if [ "$no_gen_keys" = "false" ]; then
  info "openssh-server: re-generating ssh keys on first boot"

  # disable ssh server (this is enabled once keys are re-generated)
  chroot_exec systemctl disable ssh

  # startup script to generate new ssh host keys
  # TODO: check if this works
  # TODO: update to systemd service
  rm -f $ROOTFS/etc/ssh/ssh_host_*
  cat << EOF > $ROOTFS/etc/init.d/ssh_gen_host_keys
#!/bin/sh
### BEGIN INIT INFO
# Provides:          Generates new ssh host keys on first boot
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Generates new ssh host keys on first boot
# Description:       Generates new ssh host keys on first boot
### END INIT INFO
systemctl stop ssh
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ""
ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N ""
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N ""
ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ""
update-rc.d ssh_gen_host_keys disable
update-rc.d ssh_gen_host_keys remove
update-rc.d ssh defaults
systemctl enable ssh
systemctl start ssh

# remove the script
rm -f \$0
EOF
  chmod a+x $ROOTFS/etc/init.d/ssh_gen_host_keys
  chroot_exec update-rc.d ssh_gen_host_keys defaults
else
  # just enable the ssh server
  # TODO: is this needed?
  chroot_exec systemctl enable ssh
fi

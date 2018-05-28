# TODO: check if package is in pdk
# install ssh server
chroot_exec apt-get install openssh-server --yes

# allow root logins (this is temporary, do not worry)
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' $ROOTFS/etc/ssh/sshd_config

# startup script to generate new ssh host keys
# TODO: does this work?
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
update-rc.d ssh_gen_host_keys disable
update-rc.d ssh_gen_host_keys remove
update-rc.d ssh defaults
systemctl start ssh
systemctl enable ssh

# remove the script
rm -f \$0
EOF
chmod a+x $ROOTFS/etc/init.d/ssh_gen_host_keys
chroot_exec update-rc.d ssh_gen_host_keys defaults

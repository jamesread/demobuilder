#!/bin/bash

ROOT=$(realpath ../..)
. $ROOT/config
. $ROOT/utils/functions

mkbuild

QCOW=$(cache https://download.eng.rdu2.redhat.com/brewroot/packages/rhel-guest-image/6.5/20140603.0/images/rhel-guest-image-6.5-20140603.0.x86_64.qcow2)

cp $QCOW build/rhel-guest-image-6.5.qcow2

guestfish --rw -a build/rhel-guest-image-6.5.qcow2 -i <<EOF
mkdir /root/.ssh
chmod 0700 /root/.ssh
copy-in $ROOT/keys/demobuilder.pub /root/.ssh
mv /root/.ssh/demobuilder.pub /root/.ssh/authorized_keys
chown 0 0 /root/.ssh/authorized_keys 
sh "chcon system_u:object_r:ssh_home_t:s0 /root/.ssh /root/.ssh/authorized_keys"
rm /etc/rc.d/rc3.d/S50cloud-init-local 
rm /etc/rc.d/rc3.d/S51cloud-init
rm /etc/rc.d/rc3.d/S52cloud-config
rm /etc/rc.d/rc3.d/S53cloud-final
EOF
#!/bin/bash

set -e

# mount the iso, get what we need, return
mount -o loop /tmp/stacki.iso /mnt/
install -m 0700 /mnt/frontend-install.py /tmp/
umount /mnt/

# install the frontend using rolls.xml and site.attrs in /tmp
/tmp/frontend-install.py \
    --stacki-name=stacki \
    --stacki-version=3.2 \
    --stacki-iso=/tmp/stacki.iso \
    --os-name=CentOS \
    --os-version=7.2 \
    --os-iso=/tmp/centos7.iso

# grant access to everything to the vagrant user
PATH="$PATH:/opt/stack/bin:/opt/stack/sbin" \
    /opt/stack/bin/stack set access command="*" group=vagrant

# fix the gateway to point to the NAT network interface so we can get out
sed -i -r "s/^GATEWAY=.*$/GATEWAY=10.0.2.2/" /etc/sysconfig/network

# clean everything up
rm /tmp/stacki.iso
rm /tmp/centos7.iso
systemctl stop foundation-mariadb
sh -c 'dd if=/dev/zero of=/boot/zero bs=1024k || :'
rm -f /boot/zero
sh -c 'dd if=/dev/zero of=/tmp/zero bs=1024k || :'
rm -f /tmp/zero

#!/bin/bash

echo "Trimming logs and purging caches..."
dnf clean all
truncate -c -s 0 /var/log/dnf.log
truncate -c -s 0 /var/log/dnf.rpm.log

# eliminate insecure files
echo "Removing insecure files..."

# this is the kernel's RNG seed, we don't want this baked into every VM
find /var/lib -type f -name 'random-seed' -exec rm -fv {} \;

# these will be regenerated on reboot, and we don't want the same keys baked into every VM
rm -v /etc/ssh/ssh_host_*_key \
    /etc/ssh/ssh_host_*_key.pub

# fill the disk with zeroes so we get a nice compact disk image
echo "Filling the disk with zeroes..."
dd if=/dev/zero of=/zero bs=1M >/dev/null 2>&1 ; rm /zero

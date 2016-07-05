#!/bin/bash

set -ex

# install guest additions
mount -o loop /tmp/VBoxGuestAdditions.iso /mnt/
sh /mnt/VBoxLinuxAdditions.run
umount /mnt/

# Fedora 24 kickstart file - ks.cfg
#
# For more information on kickstart syntax and commands, refer to the
# Fedora Installation Guide:
# http://docs.fedoraproject.org/en-US/Fedora/19/html/Installation_Guide/s1-kickstart2-options.html
#
# For testing, you can fire up a local http server temporarily.
# cd to the directory where this ks.cfg file resides and run the following:
#    $ python -m SimpleHTTPServer
# You don't have to restart the server every time you make changes.  Python
# will reload the file from disk every time.  As long as you save your changes
# they will be reflected in the next HTTP download.  Then to test with
# a PXE boot server, enter the following on the PXE boot prompt:
#    > linux text ks=http://<your_ip>:8000/ks.cfg

# main config
lang en_US.UTF-8
keyboard 'us'
rootpw --lock
user --name=vagrant --password=vagrant
auth --enableshadow --passalgo=sha512
timezone Etc/UTC --isUtc

# installation related config
install
cmdline
cdrom
repo --name="fedora" --mirrorlist=http://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
repo --name="updates" --mirrorlist=http://mirrors.fedoraproject.org/metalink?repo=updates-released-f$releasever&arch=$basearch
network --bootproto=dhcp --device=link --activate
selinux --enforcing
firewall --disabled
reboot

# partition/filesystem configuration
zerombr
clearpart --all --initlabel
bootloader --append="no_timer_check console=tty1 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0" --location=mbr --timeout=1
part / --fstype="ext4" --grow

# services
services --disabled="cloud-init,cloud-init-local,cloud-config,cloud-final" --enabled="network,sshd"

# install minimal tools necessary for a fedora cloud instance with vagrant support
%packages
@^cloud-server-environment
# admin utilities for sanity
bash-completion
dnf-yum
vim
# automation utilities required for ansible; ansible is not installed by default
libselinux-python
# build utilities required for guest additions
gcc
make
kernel-devel
%end

# post-installation tweaks
%post --erroronfail --interpreter /bin/bash
# disable TTY requirement; https://bugzilla.redhat.com/show_bug.cgi?id=1020147#c5
echo "Disabling TTY requirement for sudo access..."
sed -i 's,Defaults\\s*requiretty,Defaults !requiretty,' /etc/sudoers

# give vagrant user passwordless sudo
echo "Granting passwordless sudo access to the vagrant user..."
echo 'vagrant ALL=NOPASSWD: ALL' > /etc/sudoers.d/vagrant
%end

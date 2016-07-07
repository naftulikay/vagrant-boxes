# vagrant-boxes

Vagrant boxes for fun and profit.

# Stacki 7 Box

To build the Stacki 3.2 (CentOS 7) box, you'll need a [`packer`](https://packer.io) binary and must do the following:

 1. Build the CentOS 7 everything OVF image.
 2. Build the Stacki 3.2 (CentOS 7) Vagrant box on top of the CentOS 7 everything box.

This is required because the `bento/centos7.2` box doesn't include all of the required packages that Stacki requires.
First, use the `Makefile` to download the dependency ISOs; grab some coffee because this is in total around ~9GiB of
artifacts to download.

```
$ make download-centos7-everything download-stacki
```

The ISOs will be downloaded into the `artifacts/` directory.

After these have been downloaded and verified, the images can be built using Packer:

```
$ $(which packer) build centos7-everything.json
$ $(which packer) build stacki7.json
```

This will take a very long time and will require around ~30GiB of disk space, so be advised. I have been in contact
with the Stacki team and there isn't really a good way to slim down the final image size at this point in time.

After the Stacki box has been built, install it to Vagrant using the following command:

```
$ vagrant box add --name "rfkrocktk/stacki-3.2-7.x" stacki-3.2-7.x-virtualbox.box
```

You may now proceed with using the [vagrant-stacki](https://github.com/rfkrocktk/vagrant-stacki) project to bootstrap
a local Vagrant Stacki setup in VirtualBox.

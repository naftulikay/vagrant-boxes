#!/bin/bash

# clean all caches
dnf clean all

# upgrade ALL THE THINGS
echo "Upgrading all installed packages for security updates..."
dnf upgrade -y >/dev/null

# clean all packages again
dnf clean all

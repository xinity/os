#!/bin/bash
set -e

cd /home/rancher

if [ ! -e /etc/ssl/certs.orig ]; then
        cp -a /etc/ssl/certs{,.tmp}
        mv /etc/ssl/certs{,.orig}
        mv /etc/ssl/certs{.tmp,}
fi

apt-get update
apt-get -y install build-essential gawk alien fakeroot zlib1g-dev uuid-dev libblkid-dev libselinux-dev parted lsscsi dh-autoreconf git wget xz-utils

if [[ ! -d linux-$(uname -r | sed 's/-.*$//') ]]; then
    wget --no-check-certificate https://www.kernel.org/pub/linux/kernel/v3.x/linux-$(uname -r | sed 's/-.*$//').tar.xz
    tar xf linux-$(uname -r | sed 's/-.*$//').tar.xz
    # TODO build the kernel with the rancher kernel config
fi

# TODO symlinked /lib/modules/$(uname -r)/build -> linux build

# TODO run through https://github.com/ClusterHQ/powerstrip-flocker/blob/master/vagrant-aws/stage1.sh

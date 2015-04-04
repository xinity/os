#!/bin/bash
set -x -e

: ${KERNEL:=Ubuntu-3.19.0-10.10.tar.gz}

sudo apt-get update
sudo apt-get -y install build-essential gawk alien fakeroot zlib1g-dev uuid-dev libblkid-dev libselinux-dev parted lsscsi dh-autoreconf git wget xz-utils bc

if [ ! -e $KERNEL ]; then
	wget https://github.com/rancherio/linux/archive/$KERNEL
	tar xf $KERNEL
fi
cd linux-*
zcat /proc/config.gz > .config
make oldconfig
make -j$(nproc) bzImage

sudo rm -f /lib/modules/$(uname -r)/build
sudo ln -s $(pwd) /lib/modules/$(uname -r)/build

good_zfs_version="7f3e466"
good_spl_version="6ab0866"

# Compile and install spl
cd ~/
git clone https://github.com/zfsonlinux/spl
cd spl
git checkout $good_spl_version
./autogen.sh
./configure
make
make deb
sudo dpkg -i *.deb

# Compile and install zfs
cd ~/
git clone https://github.com/zfsonlinux/zfs
cd zfs
git checkout $good_zfs_version
./autogen.sh
./configure
make
make deb
sudo dpkg -i *.deb

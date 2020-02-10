#!/bin/bash

#Check root execution verification
if [[ "$EUID" -ne 0 ]]; then
	echo -e "Run this script as root"
	exit 1
fi
#Update repositories
apt-get update
#Upgrade packages
apt-get -y full-upgrade
#Dependancies install for compile kernel sources (dependancies compatibles for kernel 4.x)
apt-get install debconf-utils dpkg-dev debhelper build-essential libncurses5-dev libelf-dev liblz4-tool bc libssl-dev xz-utils ncurses-dev git initramfs-tools dpkg-dev bin86 libglib2.0-dev libgtk2.0-dev libglade2-dev libqt4-dev pkg-config bison flex po-debconf xmlto gettext wget rsync -y
#Download kernel-package packet for Debian distributions
wget http://ftp.fr.debian.org/debian/pool/main/k/kernel-package/kernel-package_13.018+nmu1~bpo9+1_all.deb
#Install deb packet after download 
dpkg -i kernel-package_13.018+nmu1~bpo9+1_all.deb
#Remove kernel-package packet after install
rm kernel-package_13.018+nmu1~bpo9+1_all.deb
#Move to /usr/src directory for work
cd /usr/src
#Download kernel 5.3.9 on official source
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.9.tar.xz
#Extract tar.xz archive
tar xvf linux-5.3.9.tar.xz
#Remove tar archive after extract 
rm linux-5.3.9.tar.xz
#Move to folder linux-5.3.9 obtain for extract tar archive
cd linux-5.3.9/
#Elements a compile custom kernel 
make menuconfig
#Build and compile custom kernel and create entries for utilisation and deb packages creates
#kaisenlinux can be replace by your choice name of your custom kernel
make-kpkg --append-to-version=-kaisenlinux --revision=1.0 --initrd --us --uc kernel_image kernel_headers -j $(nproc)
#Move parent directory
cd ..
#Install kernel custom with all .deb packages generates by make-kpkg
dpkg -i *.deb

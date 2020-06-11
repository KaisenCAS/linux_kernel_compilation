#!/bin/bash

#Check root execution verification
if [[ "$EUID" -ne 0 ]]; then
	echo -e "Run this script as root"
	exit 1
fi
#Update and upgrade repositories
apt update;apt -y full-upgrade
#Dependancies install for compile kernel sources (dependancies compatibles for kernel 4.x)
apt install debconf-utils dpkg-dev debhelper build-essential libncurses5-dev libelf-dev liblz4-tool bc libssl-dev xz-utils libncurses-dev git initramfs-tools bin86 libglib2.0-dev libgtk2.0-dev libglade2-dev pkg-config bison flex po-debconf xmlto gettext wget rsync -y
#Move to /usr/src directory for work
cd /usr/src
#Download kernel 5.6.19 on official source
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.19.tar.xz
#Extract tar.xz archive
tar xvf linux-5.6.19.tar.xz
#Remove tar archive after extract
rm linux-5.6.19.tar.xz
#Move to folder linux-5.6.19 obtain for extract tar archive
cd linux-5.6.19/
#Kernel personnalization
make menuconfig
#Fix :
#make[2]: *** No rule to make target 'debian/certs/benh@debian.org.cert.pem', needed by 'certs/x509_certificate_list'.
#Stop. Makefile:951: recipe for target 'certs' failed
sed -i -e "s/CONFIG_SYSTEM_TRUSTED_KEY./#CONFIG_SYSTEM_TRUSTED_KEY/g" .config
sed -i -e "s/CONFIG_MODULE_SIG_KEY./#CONFIG_MODULE_SIG_KEY/g" .config
sed -i -e "s/CONFIG_SYSTEM_TRUSTED_KEYRING./#CONFIG_SYSTEM_TRUSTED_KEYRING/g" .config
#Build and compile custom kernel and create entries for utilisation and deb packages creates
#customkernel can be replace by your choice name of your custom kernel
make deb-pkg -j"$(nproc)" LOCALVERSION=-customkernel KDEB_PKGVERSION="$(make kernelversion)-1"
#Move parent directory
cd ..
#Install kernel custom with all .deb packages generates by deb-pkg
dpkg -i *.deb

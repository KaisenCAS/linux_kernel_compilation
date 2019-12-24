# linux_kernel_compilation

Recompiling the Linux kernel with your own configuration

Recompiling the Linux kernel with your own configuration This script permit compile custom Linux kernel automatic for Debian and Ubuntu. Tested in Debian 9 and 10 and Ubuntu 19.04. This script is compatible with Linux kernel 3.x and 4.x. Changes wget link and names folders and xz/tar archives for use this script for olds Linux kernels. This script can possibility compatible Linux kernels futures versions. Changes wget link and names folders and xz/tar archives for use this script for futures Linux kernels.

## Resolved issues

During the compilation it can happen that an error of this kind:

make[2]: *** No rule to make target 'debian/certs/benh@debian.org.cert.pem', needed by 'certs/x509_certificate_list'.  Stop.
Makefile:951: recipe for target 'certs' failed

To solve this problem you need:
1. Execute the make menuconfig command
2. Close by changing our settings
3. In the kernel sources folder, execute the command "nano .config"
4. Find named lines: 
CONFIG_MODULE_SIG_KEY
and
CONFIG_SYSTEM_TRUSTED_KEY
and
CONFIG_SYSTEM_TRUSTED_KEYRING
Reviewing them.
5. Reissue the make menuconfig command, save and exit.
6. Restart the compilation, it should work normally.

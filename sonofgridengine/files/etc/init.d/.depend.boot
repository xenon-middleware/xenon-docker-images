TARGETS = mountkernfs.sh hostname.sh x11-common mountdevsubfs.sh procps hwclock.sh urandom networking checkroot.sh checkfs.sh mountall-bootclean.sh mountall.sh bootmisc.sh checkroot-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
INTERACTIVE = checkroot.sh checkfs.sh
mountdevsubfs.sh: mountkernfs.sh
procps: mountkernfs.sh
hwclock.sh: mountdevsubfs.sh
urandom: hwclock.sh
networking: mountkernfs.sh urandom procps
checkroot.sh: hwclock.sh mountdevsubfs.sh hostname.sh
checkfs.sh: checkroot.sh
mountall-bootclean.sh: mountall.sh
mountall.sh: checkfs.sh checkroot-bootclean.sh
bootmisc.sh: mountall-bootclean.sh checkroot-bootclean.sh mountnfs-bootclean.sh
checkroot-bootclean.sh: checkroot.sh
mountnfs.sh: networking
mountnfs-bootclean.sh: mountnfs.sh

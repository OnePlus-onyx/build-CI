#/bin/sh

sudo mount --rbind /dev rootfs/dev
sudo mount --rbind /proc rootfs/proc
sudo mount --rbind /sys rootfs/sys
sudo mount -t tmpfs tmpfs rootfs/tmp
sudo mount -vt devpts devpts rootfs/dev/pts -o gid=5,mode=620
sudo mount -vt tmpfs tmpfs rootfs/run
#chroot ./rootfs

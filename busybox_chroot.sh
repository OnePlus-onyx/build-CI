#/system/bin/sh

unset LD_PRELOAD TMPDIR
busybox mount --rbind /dev rootfs/dev
busybox mount --rbind /proc rootfs/proc
busybox mount --rbind /sys rootfs/sys
busybox mount -t tmpfs tmpfs rootfs/tmp
busybox mount -vt devpts devpts rootfs/dev/pts -o gid=5,mode=620
busybox mount -vt tmpfs tmpfs rootfs/run
chroot ./rootfs


# 网络权限
# groupadd -g 3001 net_bt_admin
# groupadd -g 3002 net_bt
# groupadd -g 3003 inet
# groupadd -g 3004 net_raw
# usermod -a -G net_bt_admin,net_bt,inet,net_raw root
# usermod -a -G net_bt_admin,net_bt,inet,net_raw riko
# newgrp inet

# 内置储存权限
# 如果把内置储存挂到这里并且用普通用户的话需要配置下。
# groupadd -g 1015 sdcard_rw
# groupadd -g 1023 media_rw
# groupadd -g 1028 sdcard_r
# usermod -a -G sdcard_rw,media_rw,sdcard_r riko

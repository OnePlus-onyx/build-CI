#/system/bin/sh

unset LD_PRELOAD TMPDIR
busybox mount --rbind /dev /data/arch/dev
busybox mount --rbind /proc /data/arch/proc
busybox mount --rbind /sys /data/arch/sys
busybox mount -t tmpfs tmpfs /data/arch/tmp
chroot /data/arch /bin/bash

网络权限
groupadd -g 3001 net_bt_admin
groupadd -g 3002 net_bt
groupadd -g 3003 inet
groupadd -g 3004 net_raw
usermod -a -G net_bt_admin,net_bt,inet,net_raw root
usermod -a -G net_bt_admin,net_bt,inet,net_raw riko
newgrp inet

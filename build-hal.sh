#!/bin/bash
source halium.env
export DEVICE="onyx"
export ANDROID_ROOT=~/work/halium
export PATH=$PATH:~/bin/
#patch
cd $ANDROID_ROOT
./hybris-patches/apply-patches.sh --mb
sudo rm -r ./.repo
# replace something
#sed -i 's/external\/selinux/external\/selinux external\/libcurl/g' build/core/main.mk
export LC_ALL=C
chmod +x $ANDROID_ROOT/kernel/oneplus/onyx/scripts/gcc-wrapper.py
source build/envsetup.sh
export USE_CCACHE=1
breakfast $DEVICE
make -j$(nproc) mkbootimg
make -j$(nproc) halium-boot
make -j$(nproc) hybris-boot
make -j$(nproc) systemimage 

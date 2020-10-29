#!/bin/bash

export GONK_PATH=`pwd`
export GECKO_PATH=${GONK_PATH}/gecko

# Prepare the device-specific paths in the AOSP build files
case "${TARGET_ARCH}" in
    arm)
        ARCH_NAME="arm"
        ARCH_ABI="androideabi"
        ;;
    arm64)
        ARCH_NAME="aarch64"
        ARCH_ABI="android"
        TARGET_TRIPLE=$ARCH_NAME-linux-$ARCH_ABI
        BINSUFFIX=64
        ;;
    x86)
        ARCH_NAME="i686"
        ARCH_ABI="android"
        TARGET_TRIPLE=$ARCH_NAME-linux-$ARCH_ABI
        ;;
    x86_64)
        ARCH_NAME="x86"
        ARCH_ABI="android"
        BINSUFFIX=64
        ;;
    *)
        echo "Unsupported $TARGET_ARCH"
        exit 1
        ;;
esac

TARGET_TRIPLE=${TARGET_TRIPLE:-$TARGET_ARCH-linux-$ARCH_ABI}

if [ "$TARGET_ARCH_VARIANT" = "$TARGET_ARCH" ] ||
   [ "$TARGET_ARCH_VARIANT" = "generic" ]; then
TARGET_ARCH_VARIANT=""
else
TARGET_ARCH_VARIANT="_$TARGET_ARCH_VARIANT"
fi

if [ "$TARGET_CPU_VARIANT" = "$TARGET_ARCH" ] ||
   [ "$TARGET_CPU_VARIANT" = "generic" ]; then
TARGET_CPU_VARIANT=""
else
TARGET_CPU_VARIANT="_$TARGET_CPU_VARIANT"
fi

ARCH_FOLDER="${TARGET_ARCH}${TARGET_ARCH_VARIANT}${TARGET_CPU_VARIANT}"


# Package the sysroot
SYSROOT_PREBUILTS="prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9/lib/gcc/x86_64-linux-android/4.9.x"

SYSROOT_INCLUDE_FOLDERS="system/libhidl/base/include
system/core/libcutils/include  
system/core/libutils/include  
system/core/libbacktrace/include  
system/core/liblog/include  
system/core/libsystem/include  
system/libhidl/transport/include  
system/core/base/include  
out/soong/.intermediates/system/libhidl/transport/manager/1.0/android.hidl.manager@1.0_genc++_headers/gen  
out/soong/.intermediates/system/libhidl/transport/manager/1.1/android.hidl.manager@1.1_genc++_headers/gen  
out/soong/.intermediates/system/libhidl/transport/base/1.0/android.hidl.base@1.0_genc++_headers/gen  
system/libhwbinder/include  
external/libcxx/include  
external/libcxxabi/include  
system/core/include  
system/media/audio/include  
hardware/libhardware/include  
hardware/libhardware_legacy/include  
hardware/ril/include  
libnativehelper/include  
frameworks/native/include  
frameworks/native/opengl/include  
frameworks/av/include    
bionic/libc/arch-arm/include    
bionic/libc/include    
bionic/libc/kernel/uapi    
bionic/libc/kernel/uapi/asm-arm    
bionic/libc/kernel/android/scsi    
bionic/libc/kernel/android/uapi  
libnativehelper/include_deprecated
out/target/product/${GONK_PRODUCT_NAME}/obj
out/target/product/${GONK_PRODUCT_NAME}/system"

tar -c $SYSROOT_PREBUILTS $SYSROOT_LIBRARIES $SYSROOT_INCLUDE_FOLDERS --transform 's,^,api-sysroot/,S' | $GECKO_PATH/taskcluster/scripts/misc/zstdpy > "api-sysroot.tar.zst"

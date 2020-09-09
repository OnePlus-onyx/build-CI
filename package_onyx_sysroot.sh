#!/bin/bash

export GONK_PATH=`pwd`
export GECKO_PATH=${GONK_PATH}/gecko
export UPLOAD_DIR=${GONK_PATH}/sysroot-upload
###############################################################################
# Package the sysroot

# Copy the contents of the directories in the first argument to the sysroot
# preserving their full paths
function copy_to_sysroot_full_path() {
  printf "${1}\n" | while read path; do
    if [ -d "${path}" ]; then
      mkdir -p "b2g-sysroot/${path}"
      rsync -r "${path}/" "b2g-sysroot/${path}/"
    else
      mkdir -p "b2g-sysroot/$(dirname ${path})"
      cp "${path}" "b2g-sysroot/${path}"
    fi
  done
}

# Copy the contents of the directories in the first argument to the sysroot
# using the second argument as the destination folder
function copy_to_sysroot() {
  mkdir -p "b2g-sysroot/${2}"
  printf "${1}\n" | while read path; do
    rsync -r --copy-links --times --exclude=".git" "${path}/" "b2g-sysroot/${2}/"
  done
}

# Copy the prebuilts to the sysroot
PREBUILTS="prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9/lib/gcc/x86_64-linux-android/4.9.x"

copy_to_sysroot_full_path "${PREBUILTS}"

# Copy the onyx's system libraries to the sysroot
LIBRARIES="out/target/product/onyx/system/lib/android.hardware.gnss@1.0.so
out/target/product/onyx/system/lib/android.hardware.gnss@1.1.so
out/target/product/onyx/system/lib/android.hardware.gnss@2.0.so
out/target/product/onyx/system/lib/android.hardware.radio@1.0.so
out/target/product/onyx/system/lib/android.hardware.gnss.visibility_control@1.0.so
out/target/product/onyx/system/lib/android.hardware.sensors@1.0.so
out/target/product/onyx/system/lib/android.hardware.vibrator@1.0.so
out/target/product/onyx/system/lib/android.hardware.wifi@1.0.so
out/target/product/onyx/system/lib/android.hardware.wifi@1.1.so
out/target/product/onyx/system/lib/android.hardware.wifi@1.2.so
out/target/product/onyx/system/lib/android.hardware.wifi@1.3.so
out/target/product/onyx/system/lib/android.hardware.wifi.hostapd@1.0.so
out/target/product/onyx/system/lib/android.hardware.wifi.hostapd@1.1.so
out/target/product/onyx/system/lib/android.hardware.wifi.supplicant@1.0.so
out/target/product/onyx/system/lib/android.hardware.wifi.supplicant@1.1.so
out/target/product/onyx/system/lib/android.hardware.wifi.supplicant@1.2.so
out/target/product/onyx/system/lib/binder_b2g_connectivity_interface-cpp.so
out/target/product/onyx/system/lib/binder_b2g_telephony_interface-cpp.so
out/target/product/onyx/system/lib/dnsresolver_aidl_interface-V2-cpp.so
out/target/product/onyx/system/lib/libaudioclient.so
out/target/product/onyx/system/lib/libbase.so
out/target/product/onyx/system/lib/libbinder.so
out/target/product/onyx/system/lib/libcamera_client.so
out/target/product/onyx/system/lib/libc++.so
out/target/product/onyx/system/lib/libcutils.so
out/target/product/onyx/system/lib/libgui.so
out/target/product/onyx/system/lib/libhardware_legacy.so
out/target/product/onyx/system/lib/libhardware.so
out/target/product/onyx/system/lib/libhidlbase.so
out/target/product/onyx/system/lib/libhidlmemory.so
out/target/product/onyx/system/lib/libhidltransport.so
out/target/product/onyx/system/lib/libhwbinder.so
out/target/product/onyx/system/lib/libmedia_omx.so
out/target/product/onyx/system/lib/libmedia.so
out/target/product/onyx/system/lib/libstagefright_foundation.so
out/target/product/onyx/system/lib/libstagefright_omx.so
out/target/product/onyx/system/lib/libstagefright.so
out/target/product/onyx/system/lib/libsuspend.so
out/target/product/onyx/system/lib/libsysutils.so
out/target/product/onyx/system/lib/libui.so
out/target/product/onyx/system/lib/libutils.so
out/target/product/onyx/system/lib/libvold_binder_shared.so
out/target/product/onyx/system/lib/libwificond_ipc_shared.so
out/target/product/onyx/system/lib/netd_aidl_interface-V2-cpp.so
out/target/product/onyx/system/lib/netd_event_listener_interface-V1-cpp.so"

copy_to_sysroot_full_path "${LIBRARIES}"

# Store the system includes in the sysroot
INCLUDE_FOLDERS="frameworks/av/camera/include
frameworks/av/include
frameworks/av/media/libaudioclient/include
frameworks/av/media/libmedia/aidl
frameworks/av/media/libmedia/include
frameworks/av/media/libstagefright/foundation/include
frameworks/av/media/libstagefright/include
frameworks/av/media/mtp
frameworks/native/headers/media_plugin
frameworks/native/include/gui
frameworks/native/include/media/openmax
frameworks/native/libs/binder/include
frameworks/native/libs/gui/include
frameworks/native/libs/math/include
frameworks/native/libs/nativebase/include
frameworks/native/libs/nativewindow/include
frameworks/native/libs/ui/include
frameworks/native/opengl/include
gonk-misc/libcarthage/HWC
gonk-misc/libcarthage/include
hardware/libhardware/include
hardware/libhardware_legacy/include
system/connectivity
system/core/base/include
system/core/include
system/core/libcutils/include
system/core/liblog/include
system/core/libprocessgroup/include
system/core/libsuspend/include
system/core/libsync/include
system/core/libsystem/include
system/core/libsysutils/include
system/core/libutils/include
system/libhidl/base/include
system/libhidl/transport/token/1.0/utils/include
system/media/audio/include
system/media/camera/include"

copy_to_sysroot "${INCLUDE_FOLDERS}" "include"

# Store the generated HIDL headers in the sysroot
#android_arm_armv7-a-neon_krait_core_shared
GENERATED_AIDL_HEADERS="out/soong/.intermediates/frameworks/av/camera/libcamera_client/android_arm_armv7-a-neon_krait_core_shared/gen/aidl
out/soong/.intermediates/frameworks/av/media/libaudioclient/libaudioclient/android_arm_armv7-a-neon_krait_core_shared/gen/aidl
out/soong/.intermediates/frameworks/av/media/libmedia/libmedia_omx/android_arm_armv7-a-neon_krait_core_shared/gen/aidl
out/soong/.intermediates/gonk-misc/gonk-binder/binder_b2g_connectivity_interface-cpp-source/gen/include
out/soong/.intermediates/gonk-misc/gonk-binder/binder_b2g_telephony_interface-cpp-source/gen/include
out/soong/.intermediates/system/connectivity/wificond/libwificond_ipc/android_arm_armv7-a-neon_krait_core_static/gen/aidl
out/soong/.intermediates/system/netd/resolv/dnsresolver_aidl_interface-V2-cpp-source/gen/include
out/soong/.intermediates/system/netd/server/netd_aidl_interface-V2-cpp-source/gen/include
out/soong/.intermediates/system/netd/server/netd_event_listener_interface-V1-cpp-source/gen/include
out/soong/.intermediates/system/vold/libvold_binder_shared/android_arm_armv7-a-neon_krait_core_shared/gen/aidl"

copy_to_sysroot "${GENERATED_AIDL_HEADERS}" "include"

# Store the generated AIDL headers in the sysroot
GENERATED_HIDL_HEADERS="out/soong/.intermediates/system/libhidl/transport/base/1.0/android.hidl.base@1.0_genc++_headers/gen
out/soong/.intermediates/system/libhidl/transport/manager/1.0/android.hidl.manager@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/gnss/1.0/android.hardware.gnss@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/gnss/1.1/android.hardware.gnss@1.1_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/gnss/2.0/android.hardware.gnss@2.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/gnss/measurement_corrections/1.0/android.hardware.gnss.measurement_corrections@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/gnss/visibility_control/1.0/android.hardware.gnss.visibility_control@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/graphics/bufferqueue/1.0/android.hardware.graphics.bufferqueue@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/graphics/bufferqueue/2.0/android.hardware.graphics.bufferqueue@2.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/graphics/common/1.0/android.hardware.graphics.common@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/graphics/common/1.1/android.hardware.graphics.common@1.1_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/graphics/common/1.2/android.hardware.graphics.common@1.2_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/media/1.0/android.hardware.media@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/media/omx/1.0/android.hardware.media.omx@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/radio/1.0/android.hardware.radio@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/sensors/1.0/android.hardware.sensors@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/vibrator/1.0/android.hardware.vibrator@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/wifi/1.0/android.hardware.wifi@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/wifi/1.1/android.hardware.wifi@1.1_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/wifi/1.2/android.hardware.wifi@1.2_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/wifi/1.3/android.hardware.wifi@1.3_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/wifi/hostapd/1.0/android.hardware.wifi.hostapd@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/wifi/hostapd/1.1/android.hardware.wifi.hostapd@1.1_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/wifi/supplicant/1.0/android.hardware.wifi.supplicant@1.0_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/wifi/supplicant/1.1/android.hardware.wifi.supplicant@1.1_genc++_headers/gen
out/soong/.intermediates/hardware/interfaces/wifi/supplicant/1.2/android.hardware.wifi.supplicant@1.2_genc++_headers/gen"

copy_to_sysroot "${GENERATED_HIDL_HEADERS}" "include"

tar -c b2g-sysroot | $GECKO_PATH/taskcluster/scripts/misc/zstdpy > "b2g-sysroot.tar.zst"

# Bundle both tarballs into a single artifact
#mkdir -p "$UPLOAD_DIR"
#tar -c "b2g-sysroot.tar.zst" "b2g-emulator.tar.zst" > "$UPLOAD_DIR/b2g-build.tar"

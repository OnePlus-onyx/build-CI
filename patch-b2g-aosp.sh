#https://github.com/kaiostech/gecko-b2g/blob/gonk/taskcluster/scripts/misc/build-b2g-emulator.sh
#

#!/bin/bash
set -x -e -v

cd "${work}/B2G"

# Remove the Gecko build & packaging steps
patch -d gonk-misc -p1 <<'EOF'
diff --git a/Android.mk b/Android.mk
index c2e3147..7df775f 100644
--- a/Android.mk
+++ b/Android.mk
@@ -161,15 +161,15 @@ endif
 $(LOCAL_INSTALLED_MODULE) : $(LOCAL_BUILT_MODULE)
 	@echo Install dir: $(TARGET_OUT)/b2g
 	rm -rf $(filter-out $(addprefix $(TARGET_OUT)/b2g/,$(PRESERVE_DIRS)),$(wildcard $(TARGET_OUT)/b2g/*))
-	cd $(TARGET_OUT) && tar xvfz $(abspath $<)
+	:
 ifneq ($(EXPORT_DEVICE_PREFS),)
-	cp -n $(EXPORT_DEVICE_PREFS)/*.js $(TARGET_OUT)/b2g/defaults/pref/
+	:
 endif
 ifneq ($(EXPORT_DEVICE_USER_BUILD_PREFS),)
-	cp -n $(EXPORT_DEVICE_USER_BUILD_PREFS) $(TARGET_OUT)/b2g/defaults/pref/
+	:
 endif
 ifneq ($(EXPORT_BUILD_PREFS),)
-	cp -n $(EXPORT_BUILD_PREFS) $(TARGET_OUT)/b2g/defaults/pref/
+	:
 endif
 
 GECKO_LIB_DEPS := \
@@ -235,36 +235,7 @@ endif
 
 .PHONY: $(LOCAL_BUILT_MODULE)
 $(LOCAL_BUILT_MODULE): $(TARGET_CRTBEGIN_DYNAMIC_O) $(TARGET_CRTEND_O) $(addprefix $(TARGET_OUT_SHARED_LIBRARIES)/,$(GECKO_LIB_DEPS)) $(GECKO_LIB_STATIC)
-ifeq ($(USE_PREBUILT_B2G),1)
-	@echo -e "\033[0;33m ==== Use prebuilt gecko ==== \033[0m";
-	mkdir -p $(@D) && cp $(abspath $(PREFERRED_B2G)) $@
-else
-	echo "export GECKO_OBJDIR=$(abspath $(GECKO_OBJDIR))"; \
-	echo "export GONK_PRODUCT_NAME=$(TARGET_DEVICE)"; \
-	echo "export GONK_PATH=$(abspath .)"; \
-	echo "export PLATFORM_VERSION=$(PLATFORM_SDK_VERSION)"; \
-	echo "export TARGET_ARCH=$(TARGET_ARCH)"; \
-	echo "export TARGET_ARCH_VARIANT=$(TARGET_ARCH_VARIANT)"; \
-	echo "export TARGET_CPU_VARIANT=$(TARGET_CPU_VARIANT)"; \
-	echo "export PRODUCT_MANUFACTURER=$(PRODUCT_MANUFACTURER)"; \
-	echo "export MOZ_DISABLE_LTO=$(MOZ_DISABLE_LTO)"; \
-	echo "export HOST_OS=$(HOST_OS)";	\
-	unset CC_WRAPPER && unset CXX_WRAPPER && \
-	export GECKO_OBJDIR="$(abspath $(GECKO_OBJDIR))" && \
-	export GONK_PATH="$(abspath .)" && \
-	export GONK_PRODUCT_NAME="$(TARGET_DEVICE)" && \
-	export PLATFORM_VERSION="$(PLATFORM_SDK_VERSION)" && \
-	export TARGET_ARCH="$(TARGET_ARCH)" && \
-	export TARGET_ARCH_VARIANT="$(TARGET_ARCH_VARIANT)" && \
-	export TARGET_CPU_VARIANT="$(TARGET_CPU_VARIANT)" && \
-	export PRODUCT_MANUFACTURER="$(PRODUCT_MANUFACTURER)" && \
-	export MOZ_DISABLE_LTO="$(MOZ_DISABLE_LTO)" && \
-	export MOZ_SANDBOX_GPU_NODE="$(MOZ_SANDBOX_GPU_NODE)" && \
-	export HOST_OS="$(HOST_OS)" && \
-	(cd $(GECKO_PATH) ; $(SHELL) build-b2g.sh) && \
-	(cd $(GECKO_PATH) ; $(SHELL) build-b2g.sh package) && \
-	mkdir -p $(@D) && cp $(GECKO_OBJDIR)/dist/b2g-*.tar.gz $@
-endif
+	:
 
 .PHONY: buildsymbols
 buildsymbols:
EOF

# # Work around the hardcoded LOCAL_NDK variable
# patch -d gonk-misc/api-daemon -p1 <<'EOF'
# diff --git a/Android.mk b/Android.mk
# index afaa48f..72a5636 100644
# --- a/Android.mk
# +++ b/Android.mk
# @@ -40,7 +40,11 @@ API_DAEMON_LIB_DEPS := \
 
#  include $(BUILD_PREBUILT)
 
# +ifndef ANDROID_NDK
#  LOCAL_NDK := $(HOME)/.mozbuild/android-ndk-r20b-canary
# +else
# +LOCAL_NDK := $(ANDROID_NDK)
# +endif
 
#  $(LOCAL_BUILT_MODULE): $(TARGET_CRTBEGIN_DYNAMIC_O) $(TARGET_CRTEND_O) $(addprefix $(TARGET_OUT_SHARED_LIBRARIES)/,$(API_DAEMON_LIB_DEPS))
#  	@echo "api-daemon: $(API_DAEMON_EXEC)"
# @@ -88,4 +92,4 @@ ifneq ($(PREBUILT_CA_BUNDLE),)
#  	@cp $(PREBUILT_CA_BUNDLE) -f $@
#  else
#  	@perl $(MK_CA_BUNDLE) -d $(CERTDATA_FILE) -f $@
# -endif
# \ No newline at end of file
# +endif
# EOF

# Force compressing debug symbols
patch -d build/soong -p1 <<'EOF'
diff --git a/cc/config/global.go b/cc/config/global.go
index 815c31d8..9d82d460 100644
--- a/cc/config/global.go
+++ b/cc/config/global.go
@@ -44,6 +44,7 @@ var (
 
 		"-O2",
 		"-g",
+		"-gz", // Compress debug symbols
 
 		"-fno-strict-aliasing",
 	}
@@ -69,6 +70,7 @@ var (
 		"-Werror=sequence-point",
 		"-Werror=date-time",
 		"-Werror=format-security",
+		"-gz", // Compress debug symbols
 	}
 
 	deviceGlobalCppflags = []string{
@@ -85,6 +87,7 @@ var (
 		"-Wl,--no-undefined-version",
 		"-Wl,--exclude-libs,libgcc.a",
 		"-Wl,--exclude-libs,libgcc_stripped.a",
+		"-Wl,--compress-debug-sections=zlib", // Compress debug symbols
 	}
 
 	deviceGlobalLldflags = append(ClangFilterUnknownLldflags(deviceGlobalLdflags),
EOF

LOCAL_PATH:= $(call my-dir)

# Visualizer library
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	EffectVisualizer.cpp

LOCAL_CFLAGS+= -fvisibility=hidden
# This might require optimizations to build?
# -O2 was forced before, so if we get something lower than it other than -Os, force -O2
# Otherwise, don't overwrite -O3!
ifeq ($(findstring -O, $(TARGET_GLOBAL_CFLAGS)),)
LOCAL_CFLAGS += -O2
endif
ifneq ($(findstring -O0, $(TARGET_GLOBAL_CFLAGS)),)
LOCAL_CFLAGS += -O2
endif
ifneq ($(findstring -O1, $(TARGET_GLOBAL_CFLAGS)),)
LOCAL_CFLAGS += -O2
endif

LOCAL_SHARED_LIBRARIES := \
	libcutils \
	liblog \
	libdl

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/soundfx
LOCAL_MODULE:= libvisualizer

LOCAL_C_INCLUDES := \
	$(call include-path-for, graphics corecg) \
	$(call include-path-for, audio-effects)


include $(BUILD_SHARED_LIBRARY)

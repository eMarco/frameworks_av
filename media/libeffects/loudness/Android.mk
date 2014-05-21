LOCAL_PATH:= $(call my-dir)

# LoudnessEnhancer library
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	EffectLoudnessEnhancer.cpp \
	dsp/core/dynamic_range_compression.cpp

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
	libstlport

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/soundfx
LOCAL_MODULE:= libldnhncr

LOCAL_C_INCLUDES := \
	$(call include-path-for, audio-effects) \
	bionic \
	bionic/libstdc++/include \
	external/stlport/stlport


include $(BUILD_SHARED_LIBRARY)

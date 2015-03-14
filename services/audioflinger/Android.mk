LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    ISchedulingPolicyService.cpp \
    SchedulingPolicyService.cpp

# FIXME Move this library to frameworks/native
LOCAL_MODULE := libscheduling_policy

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    ServiceUtilities.cpp

# FIXME Move this library to frameworks/native
LOCAL_MODULE := libserviceutility

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libutils \
    liblog \
    libbinder

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

# Clang++ aborts on AudioMixer.cpp,
# b/18373866, "do not know how to split this operator."
ifeq ($(filter $(TARGET_ARCH),arm arm64),$(TARGET_ARCH))
    LOCAL_CLANG := false
endif

LOCAL_SRC_FILES:=               \
    AudioFlinger.cpp            \
    Threads.cpp                 \
    Tracks.cpp                  \
    Effects.cpp                 \
    AudioMixer.cpp.arm          \
    PatchPanel.cpp

LOCAL_SRC_FILES += StateQueue.cpp

LOCAL_C_INCLUDES := \
    $(TOPDIR)frameworks/av/services/audiopolicy \
    $(call include-path-for, audio-effects) \
    $(call include-path-for, audio-utils)

LOCAL_SHARED_LIBRARIES := \
    libaudioresampler \
    libaudioutils \
    libcommon_time_client \
    libcutils \
    libutils \
    liblog \
    libbinder \
    libmedia \
    libnbaio \
    libhardware \
    libhardware_legacy \
    libeffects \
    libpowermanager \
    libserviceutility

LOCAL_STATIC_LIBRARIES := \
    libscheduling_policy \
    libcpustats \
    libmedia_helper

LOCAL_MODULE:= libaudioflinger
LOCAL_32_BIT_ONLY := true

LOCAL_SRC_FILES += FastMixer.cpp FastMixerState.cpp AudioWatchdog.cpp
LOCAL_SRC_FILES += FastThread.cpp FastThreadState.cpp
LOCAL_SRC_FILES += FastCapture.cpp FastCaptureState.cpp

LOCAL_CFLAGS += -DSTATE_QUEUE_INSTANTIATIONS='"StateQueueInstantiations.cpp"'

LOCAL_CFLAGS += -fvisibility=hidden

include $(BUILD_SHARED_LIBRARY)

#
# build audio resampler test tool
#
include $(CLEAR_VARS)

LOCAL_SRC_FILES:=               \
    test-resample.cpp           \

LOCAL_C_INCLUDES := \
    $(call include-path-for, audio-utils)

LOCAL_STATIC_LIBRARIES := \
    libsndfile

LOCAL_SHARED_LIBRARIES := \
    libaudioresampler \
    libaudioutils \
    libdl \
    libcutils \
    libutils \
    liblog

ifeq ($(OMAP_ENHANCEMENT), true)
    OMAP_SPEEX_RESAMPLER := true
else
ifeq ($(OMAP_TUNA), true)
    OMAP_SPEEX_RESAMPLER := true
endif
endif

ifeq ($(OMAP_SPEEX_RESAMPLER), true)
LOCAL_C_INCLUDES += \
	external/speex/include

LOCAL_SRC_FILES += \
	AudioResamplerSpeex.cpp.arm

LOCAL_SHARED_LIBRARIES += \
	libspeexresampler
endif

LOCAL_MODULE:= test-resample

LOCAL_MODULE_TAGS := optional

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
    AudioResampler.cpp.arm \
    AudioResamplerCubic.cpp.arm \
    AudioResamplerSinc.cpp.arm \
    AudioResamplerDyn.cpp.arm

LOCAL_C_INCLUDES := \
    $(call include-path-for, audio-utils)

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libdl \
    liblog

ifeq ($(OMAP_ENHANCEMENT), true)
    OMAP_SPEEX_RESAMPLER := true
else
ifeq ($(OMAP_TUNA), true)
    OMAP_SPEEX_RESAMPLER := true
endif
endif

ifeq ($(OMAP_SPEEX_RESAMPLER), true)
    LOCAL_SRC_FILES += AudioResamplerSpeex.cpp.arm
    LOCAL_C_INCLUDES += external/speex/include
    LOCAL_SHARED_LIBRARIES += libspeexresampler
endif

LOCAL_MODULE := libaudioresampler

include $(BUILD_SHARED_LIBRARY)

include $(call all-makefiles-under,$(LOCAL_PATH))

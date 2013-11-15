LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_SHARED_LIBRARIES := libcutils liblog

LOCAL_SRC_FILES := 	\
	../cpp/portal.cpp gralloc.cpp mapper.cpp
#	../cpp/portal.cpp HdmiDisplay.cpp gralloc.cpp mapper.cpp

LOCAL_MODULE_TAGS = optional
LOCAL_MODULE := gralloc.portal
LOCAL_CFLAGS:= -DLOG_TAG=\"gralloc\" -I$(LOCAL_PATH)/../cpp -I$(LOCAL_PATH)/..

include $(BUILD_SHARED_LIBRARY)

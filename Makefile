export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.5:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_DEVICE_IP = 10.0.0.65

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CustomCarrier15

CustomCarrier15_FILES = Tweak.x
CustomCarrier15_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += customcarrierprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

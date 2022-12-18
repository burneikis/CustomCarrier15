export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.5:14.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CustomCarrierPrefs

CustomCarrierPrefs_FILES = XXXRootListController.m
CustomCarrierPrefs_FRAMEWORKS = UIKit
CustomCarrierPrefs_PRIVATE_FRAMEWORKS = Preferences
CustomCarrierPrefs_INSTALL_PATH = /Library/PreferenceBundles
CustomCarrierPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

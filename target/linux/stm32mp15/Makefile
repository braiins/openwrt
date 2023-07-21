# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2023  Braiins Systems s.r.o.

include $(TOPDIR)/rules.mk

ARCH:=arm
BOARD:=stm32mp15
BOARDNAME:=STMicroelectronics STM32MP15 SoCs
FEATURES:=fpu gpio rtc usb usbgadget ext4 squashfs targz boot-part rootfs-part
SUBTARGETS:=ii1
MAINTAINER:=Braiins <braiins@braiins.com>

KERNEL_PATCHVER:=5.10

KERNELNAME:=zImage dtbs

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += uboot-envtools
DEFAULT_PACKAGES += mkf2fs e2fsprogs
DEFAULT_PACKAGES += kmod-gpio-button-hotplug

$(eval $(call BuildTarget))

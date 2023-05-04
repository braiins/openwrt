# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2023  Braiins Systems s.r.o.

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

KERNEL_LOADADDR := 0xC2000040

define Device/Default
  FILESYSTEMS := ext4
  KERNEL := kernel-bin
  IMAGES :=
endef

define Device/sd
  DEVICE_TITLE := STM32MP1 SD Card Image
endef
TARGET_DEVICES += sd

define Device/emmc
  DEVICE_TITLE := STM32MP1 eMMC Image
endef
TARGET_DEVICES += emmc

$(eval $(call BuildImage))

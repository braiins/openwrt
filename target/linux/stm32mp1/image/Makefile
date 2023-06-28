# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2023  Braiins Systems s.r.o.

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

KERNEL_LOADADDR := 0xC2000040

TARGET_NAME = $(subst _,-,$(SUBTARGET))_$(DEVICE_NAME)

define Build/gpt
	rm -rf $@.tmp
	mkdir -p $@.tmp/data $@.tmp/tmp

	ln -s $(STAGING_DIR_IMAGE)/$(TARGET_NAME)-tf-a.stm32 $@.tmp/data/tf-a.stm32
	ln -s $(STAGING_DIR_IMAGE)/$(TARGET_NAME)-fip.bin $@.tmp/data/fip.bin
	ln -s $(IMAGE_ROOTFS) $@.tmp/data/rootfs.img

    # Prepare partition for read-write overlay with Ext4 filesystem
	dd if=/dev/zero of=$@.tmp/data/rootfs_data.img bs=1024k count=0 seek=88
	$(STAGING_DIR_HOST)/bin/mkfs.ext4 $@.tmp/data/rootfs_data.img

	genimage \
		--tmppath $@.tmp/tmp \
		--inputpath $@.tmp/data \
		--outputpath $@.tmp \
		--config genimage_sd.cfg
	mv $@.tmp/sd.img $@

	rm -rf $@.tmp
endef

define Device/Default
  KERNEL := kernel-bin
  IMAGES :=
  IMAGE/gpt.img.gz := gpt | gzip
endef

define Device/sd
  DEVICE_TITLE := STM32MP1 SD Card Image
  FILESYSTEMS := squashfs
  IMAGES := gpt.img.gz
endef
TARGET_DEVICES += sd

define Device/emmc
  DEVICE_TITLE := STM32MP1 eMMC Image
  FILESYSTEMS := squashfs
endef
TARGET_DEVICES += emmc

$(eval $(call BuildImage))

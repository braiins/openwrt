# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2023  Braiins Systems s.r.o.

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

KERNEL_LOADADDR := 0xC2000040

TARGET_NAME = $(subst _,-,$(SUBTARGET))_$(DEVICE_NAME)

define Build/stm32mp1-sdcard
	rm -rf $@.tmp
	mkdir -p $@.tmp/data $@.tmp/tmp

	gzip -dc $(TFA_GZ_PATH) > $@.tmp/data/tf-a.stm32
	gzip -dc $(FIP_GZ_PATH) > $@.tmp/data/fip.bin
	ln -s $(IMAGE_ROOTFS) $@.tmp/data/rootfs.img

	genimage \
		--tmppath $@.tmp/tmp \
		--inputpath $@.tmp/data \
		--outputpath $@.tmp \
		--config genimage_sd.cfg
	mv $@.tmp/sd.img $@

	rm -rf $@.tmp
endef

define Build/stm32mp1-mmcblk0
	rm -rf $@.tmp
	mkdir -p $@.tmp/data $@.tmp/tmp

	gzip -dc $(FIP_GZ_PATH) > $@.tmp/data/fip.bin

	genimage \
		--tmppath $@.tmp/tmp \
		--inputpath $@.tmp/data \
		--outputpath $@.tmp \
		--config genimage_emmc.cfg
	mv $@.tmp/emmc.img $@

	rm -rf $@.tmp
endef

define Build/append-tf-a
	gzip -dc $(TFA_GZ_PATH) >> $@
endef

define Build/append-fip-gz
	dd if=$(FIP_GZ_PATH) >> $@
endef

define Device/Default
  KERNEL := kernel-bin
  TFA_GZ_PATH = $(STAGING_DIR_IMAGE)/$$(TARGET_NAME)-tf-a.stm32.gz
  FIP_GZ_PATH = $(STAGING_DIR_IMAGE)/$$(TARGET_NAME)-fip.bin.gz
  UBOOT_PATH = $(STAGING_DIR_IMAGE)/$$(TARGET_NAME)-u-boot-nodtb.bin
  BOOT_TFA_SIZE := 1024k
  BOOT_FIP_SIZE := 2048k
  MMC_BLOCK_SIZE := 512
  IMAGES :=
  ARTIFACTS :=
endef

define Device/sd
  DEVICE_TITLE := STM32MP1 SD Card Image
  FILESYSTEMS := squashfs
  IMAGES := user.img.gz
  IMAGE/user.img.gz := stm32mp1-sdcard | gzip
endef
TARGET_DEVICES += sd

define Device/emmc
  DEVICE_TITLE := STM32MP1 eMMC Image
  FILESYSTEMS := squashfs
  IMAGES := mmcblk0gp0.img
  ARTIFACTS := mmcblk0bootx.img.gz mmcblk0.img.gz
  IMAGE/mmcblk0gp0.img := append-rootfs | pad-to $$$$(MMC_BLOCK_SIZE)
  ARTIFACT/mmcblk0bootx.img.gz := \
	append-tf-a | pad-to $$$$(BOOT_TFA_SIZE) | \
	append-fip-gz | pad-to $$$$(BOOT_FIP_SIZE) | \
	gzip
  ARTIFACT/mmcblk0.img.gz := stm32mp1-mmcblk0 | gzip
endef
TARGET_DEVICES += emmc

$(eval $(call BuildImage))

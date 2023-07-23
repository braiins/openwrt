# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2023  Braiins Systems s.r.o.

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

# format version of sysupgrade image
# it is possible to upgrade firmware only with supported formats
FORMAT_VERSION := '\"format_version\": \"1\"'

BOS_MODE_SD := '\"bos_mode\": \"sd\"'
BOS_MODE_EMMC := '\"bos_mode\": \"emmc\"'

KERNEL_LOADADDR := 0xC2000040

TARGET_NAME = $(SUBTARGET)-$(BOARD_IFACE)_$(DEVICE_NAME)

define Build/stm32mp15-sysupgrade-tar
	rm -rf $@.tmp
	mkdir -p $@.tmp/sysupgrade-$(BOARD_NAME)

	echo "BOARD=$(BOARD_NAME)" > $@.tmp/sysupgrade-$(BOARD_NAME)/CONTROL
	gzip -dc $(TFA_GZ_PATH) > $@.tmp/sysupgrade-$(BOARD_NAME)/tf-a.stm32
	gzip -dc $(FIP_GZ_PATH) > $@.tmp/sysupgrade-$(BOARD_NAME)/fip.bin
	ln -s $(IMAGE_ROOTFS) $@.tmp/sysupgrade-$(BOARD_NAME)/rootfs.img

	tar -C $@.tmp --sort=name --owner=0 --group=0 --numeric-owner -cvhf $@ \
		sysupgrade-$(BOARD_NAME)

	rm -rf $@.tmp
endef

define Build/stm32mp15-sdcard
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

define Build/stm32mp15-mmcblk0
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

define Build/append-factory-env
	$(STAGING_DIR_HOST)/bin/mkenvimage -r -p 0 -s $(FACTORY_ENV_SIZE) -o - \
		factory-env_$(1).txt >> $@
endef

define Device/Default
  KERNEL := kernel-bin
  TFA_GZ_PATH = $(STAGING_DIR_IMAGE)/$$(TARGET_NAME)-tf-a.stm32.gz
  FIP_GZ_PATH = $(STAGING_DIR_IMAGE)/$$(TARGET_NAME)-fip.bin.gz
  UBOOT_PATH = $(STAGING_DIR_IMAGE)/$$(TARGET_NAME)-u-boot-nodtb.bin
  BOARD_NAME = $$(SUBTARGET)-$$(DEVICE_NAME)
  SUPPORTED_DEVICES = $(SUBTARGET_COMPATIBLES)
  FACTORY_ENV_SIZE := 0x8000
  BOOT_FIP_OFFSET := 1024k
  BOOT_FACTORY_ENV_OFFSET := 3072k
  BOOT_RESERVED_OFFSET := 3584k
  MMC_BLOCK_SIZE := 512
  IMAGES :=
  ARTIFACTS :=
endef

define Device/sd
  DEVICE_TITLE := STM32MP15 SD Card Image
  FILESYSTEMS := squashfs
  IMAGES := sysupgrade.tar user.img.gz
  IMAGE_METADATA := $(FORMAT_VERSION),$(BOS_MODE_SD)
  IMAGE/sysupgrade.tar := stm32mp15-sysupgrade-tar | append-metadata
  IMAGE/user.img.gz := stm32mp15-sdcard | gzip
endef
TARGET_DEVICES += sd

define Device/emmc
  DEVICE_TITLE := STM32MP15 eMMC Image
  FILESYSTEMS := squashfs
  IMAGES := sysupgrade.tar mmcblk0gp0.img
  ARTIFACTS := mmcblk0bootx.img.gz mmcblk0.img.gz
  IMAGE_METADATA := $(FORMAT_VERSION),$(BOS_MODE_EMMC)
  IMAGE/sysupgrade.tar := stm32mp15-sysupgrade-tar | append-metadata
  IMAGE/mmcblk0gp0.img := append-rootfs | pad-to $$$$(MMC_BLOCK_SIZE)
  ARTIFACT/mmcblk0bootx.img.gz := \
	append-tf-a | pad-to $$$$(BOOT_FIP_OFFSET) | \
	append-fip-gz | pad-to $$$$(BOOT_FACTORY_ENV_OFFSET) | \
	append-factory-env $(1) | pad-to $$$$(BOOT_RESERVED_OFFSET) | \
	gzip
  ARTIFACT/mmcblk0.img.gz := stm32mp15-mmcblk0 | gzip
endef
TARGET_DEVICES += emmc

$(eval $(call BuildImage))

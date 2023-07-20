# Copyright (C) 2023  Braiins Systems s.r.o.
#
# This file is part of Braiins Open-Source Initiative (BOSI).
#
# BOSI is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Please, keep in mind that we may also license BOSI or any part thereof
# under a proprietary license. For more information on the terms and conditions
# of such proprietary license or if you have any other questions, please
# contact us at opensource@braiins.com.

include $(TOPDIR)/rules.mk

PKG_VERSION:=2.4
PKG_RELEASE:=1

ifeq ($(strip $(CONFIG_EXTERNAL_ARM_TRUSTED_FIRMWARE_STM32MP1_TREE)),"")
	$(error Empty CONFIG_EXTERNAL_ARM_TRUSTED_FIRMWARE_STM32MP1_TREE)
else
	PKG_SOURCE_VERSION:=local
    USE_SOURCE_DIR:=$(call qstrip,$(CONFIG_EXTERNAL_ARM_TRUSTED_FIRMWARE_STM32MP1_TREE))
endif

include $(INCLUDE_DIR)/trusted-firmware-a.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

DTB_VARIANT_NAME_ii1:=stm32mp157c-ii1$(call qstrip,$(CONFIG_DTB_VARIANT_stm32mp1_ii1))

define Trusted-Firmware-A/Default
  BUILD_TARGET:=stm32mp1
  PLAT:=stm32mp1
  BOOT_DEVICE:=
  DEPENDS:=@LINUX_5_10 +u-boot-$(1)
endef

define Trusted-Firmware-A/ii1-stm_sd
  NAME:=TF-A $(PKG_VERSION) for STM32MP157C Braiins Control Board (SD)
  BUILD_SUBTARGET:=ii1_stm
  BUILD_DEVICES:=sd
  BOOT_DEVICE:=sd
  DTB_FILE_NAME:=$(DTB_VARIANT_NAME_ii1)
endef

define Trusted-Firmware-A/ii1-stm_emmc
  NAME:=TF-A $(PKG_VERSION) for STM32MP157C Braiins Control Board (eMMC)
  BUILD_SUBTARGET:=ii1_stm
  BUILD_DEVICES:=emmc
  BOOT_DEVICE:=emmc
  DTB_FILE_NAME:=$(DTB_VARIANT_NAME_ii1)
endef

TFA_TARGETS:= \
	ii1-stm_sd \
	ii1-stm_emmc

TFA_MAKE_FLAGS += \
	BUILD_BASE=build-$(BUILD_VARIANT) \
	DTC=$(LINUX_DIR)/scripts/dtc/dtc \
	ARCH=aarch32 \
	ARM_ARCH_MAJOR=7 \
	AARCH32_SP=sp_min \
	DTB_FILE_NAME=$(DTB_FILE_NAME).dtb \
	$(if $(filter sd,$(BOOT_DEVICE)),STM32MP_SDMMC=1) \
	$(if $(filter emmc,$(BOOT_DEVICE)),STM32MP_EMMC=1) \
	BL33=$(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot-nodtb.bin \
	BL33_CFG=$(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot.dtb \
	$(if $(CONFIG_ARM_TRUSTED_FIRMWARE_STM32MP1_DEBUG),DEBUG=1) \
	all fip

TFA_BUILD_DIR:=$(if $(CONFIG_ARM_TRUSTED_FIRMWARE_STM32MP1_DEBUG),debug,release)

define Package/trusted-firmware-a/install
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	gzip -f -9n -c $(PKG_BUILD_DIR)/build-$(BUILD_VARIANT)/$(PLAT)/$(TFA_BUILD_DIR)/tf-a-$(DTB_FILE_NAME).stm32 \
		> $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-tf-a.stm32.gz
	gzip -f -9n -c $(PKG_BUILD_DIR)/build-$(BUILD_VARIANT)/$(PLAT)/$(TFA_BUILD_DIR)/fip.bin \
		> $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-fip.bin.gz
endef

define Build/Clean
	rm -rf $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-tf-a.stm32
	rm -rf $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-fip.bin
endef

define Package/trusted-firmware-a-ii1-stm_sd/config
	source "$(SOURCE)/Config.in"
endef

$(eval $(call BuildPackage/Trusted-Firmware-A))

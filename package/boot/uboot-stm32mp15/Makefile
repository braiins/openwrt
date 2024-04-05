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

PKG_VERSION:=2020.10
PKG_RELEASE:=1

ifeq ($(strip $(CONFIG_EXTERNAL_UBOOT_STM32MP15_TREE)),"")
	$(error Empty CONFIG_EXTERNAL_UBOOT_STM32MP15_TREE)
else
	PKG_SOURCE_VERSION:=local
	USE_SOURCE_DIR:=$(call qstrip,$(CONFIG_EXTERNAL_UBOOT_STM32MP15_TREE))
endif

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

# Define the SOURCE_DATE_EPOCH variable to capture the package's source date epoch.
SOURCE_DATE_EPOCH := $(PKG_SOURCE_DATE_EPOCH)

define U-Boot/Default
  BUILD_TARGET=stm32mp15
  BUILD_SUBTARGET:=ii1
endef

define U-Boot/ii1-am2_sd_template
  NAME:=U-Boot $(PKG_VERSION) for Braiins Control Board ($(1)/SD)
  BUILD_DEVICES:=sd
  DTB_FILE_NAME:=$(1)
  UBOOT_CONFIG=$(1)_sd
endef

define U-Boot/ii1-am2_emmc_template
  NAME:=U-Boot $(PKG_VERSION) for Braiins Control Board ($(1)/eMMC)
  BUILD_DEVICES:=emmc
  DTB_FILE_NAME:=$(1)
  UBOOT_CONFIG=$(1)_emmc
endef

U-Boot/ii1-am2_sd=$(call U-Boot/ii1-am2_sd_template,stm32mp157c-ii1-am2)
U-Boot/ii1-am2_emmc=$(call U-Boot/ii1-am2_emmc_template,stm32mp157c-ii1-am2)

U-Boot/ii1-am2_p03_a12_sd=$(call U-Boot/ii1-am2_sd_template,stm32mp157c-ii1-am2_p03_a12)
U-Boot/ii1-am2_p03_a12_emmc=$(call U-Boot/ii1-am2_emmc_template,stm32mp157c-ii1-am2_p03_a12)

UBOOT_TARGETS := \
	ii1-am2_sd \
	ii1-am2_emmc \
	ii1-am2_p03_a12_sd \
	ii1-am2_p03_a12_emmc

UBOOT_MAKE_FLAGS += \
	DEVICE_TREE=$(DTB_FILE_NAME)

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/u-boot-nodtb.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot-nodtb.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/u-boot.dtb $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot.dtb
endef

define Build/Clean
	rm -rf $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot-nodtb.bin
	rm -rf $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot.dtb
endef

define Package/u-boot-ii1-am2_sd/config
	source "$(SOURCE)/Config.in"
endef

$(eval $(call BuildPackage/U-Boot))

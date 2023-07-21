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

DTB_VARIANT_NAME_ii1_am2:=stm32mp157c-ii1-am2$(call qstrip,$(CONFIG_DTB_VARIANT_stm32mp15_ii1))

define U-Boot/Default
  BUILD_TARGET=stm32mp15
  UBOOT_CONFIG=stm32mp15_$$(BUILD_SUBTARGET)_$$(BUILD_DEVICES)
endef

define U-Boot/ii1-am2_sd
  NAME:=U-Boot $(PKG_VERSION) for Braiins Control Board (stm32mp157c-ii1-am2/SD)
  BUILD_SUBTARGET:=ii1
  BUILD_DEVICES:=sd
  DTB_FILE_NAME:=$(DTB_VARIANT_NAME_ii1_am2)
endef

define U-Boot/ii1-am2_emmc
  NAME:=U-Boot $(PKG_VERSION) for Braiins Control Board (stm32mp157c-ii1-am2/eMMC)
  BUILD_SUBTARGET:=ii1
  BUILD_DEVICES:=emmc
  DTB_FILE_NAME:=$(DTB_VARIANT_NAME_ii1_am2)
endef

UBOOT_TARGETS := \
	ii1-am2_sd \
	ii1-am2_emmc

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

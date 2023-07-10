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

PKG_NAME:=boot-ii1-stm
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

LINUX_BOOT_DIR:=$(LINUX_DIR)/arch/$(LINUX_KARCH)/boot
DTB_DEFAULT_NAME:=stm32mp157c-ii1
DTB_VARIANT_NAME:=$(DTB_DEFAULT_NAME)$(call qstrip,$(CONFIG_DTB_VARIANT_stm32mp1_ii1))

define Package/boot-ii1-stm
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=Boot package for for STM32MP157C Braiins Control Board (ii1-stm)
  DEPENDS:=@LINUX_5_10 @TARGET_stm32mp1_ii1_stm
endef

define Package/boot-ii1-stm/description
  Package with Linux kernel and boot scripts.
endef

define Build/Compile
endef

define Package/boot-ii1-stm/config
	source "$(SOURCE)/Config.in"
endef

define Package/boot-ii1-stm/install
	$(INSTALL_DIR) $(1)/boot
	$(INSTALL_DATA) $(LINUX_BOOT_DIR)/zImage $(1)/boot/
	$(INSTALL_DATA) $(LINUX_BOOT_DIR)/dts/$(DTB_VARIANT_NAME).dtb $(1)/boot/$(DTB_DEFAULT_NAME).dtb
endef

$(eval $(call BuildPackage,boot-ii1-stm))

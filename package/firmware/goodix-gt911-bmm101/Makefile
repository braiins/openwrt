# Copyright (C) 2024  Braiins Systems s.r.o.
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

PKG_NAME:=goodix-gt911-bmm101
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/goodix-gt911-bmm101
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=Goodix GT911 firmware for BMM101
  DEPENDS:=@TARGET_stm32mp15_ii2 +kmod-input-touchscreen-goodix
endef

define Package/goodix-gt911-bmm101/description
  Package with Linux kernel and boot scripts.
endef

define Build/Compile

endef

define Package/goodix-gt911-bmm101/install
	$(INSTALL_DIR) $(1)/lib/firmware
	$(INSTALL_DATA) ./files/goodix_911_cfg.bin $(1)/lib/firmware/goodix_911_cfg.bin
endef

$(eval $(call BuildPackage,goodix-gt911-bmm101))

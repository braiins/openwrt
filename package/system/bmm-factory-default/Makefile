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

PKG_NAME:=bmm-factory-default
PKG_RELEASE:=$(AUTORELEASE)

include $(INCLUDE_DIR)/package.mk

define Package/bmm-factory-default
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Scritps and utils for factory default
  DEPENDS:=@TARGET_stm32mp15_ii2
endef

define Build/Compile

endef

define Package/bmm-factory-default/conffiles
/etc/factory-default
endef

define Package/bmm-factory-default/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) ./files/etc/factory-default $(1)/etc/factory-default

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/factory-default-wifi $(1)/etc/init.d/factory-default-wifi
	$(INSTALL_BIN) ./files/etc/init.d/factory-default-cfg-revert $(1)/etc/init.d/factory-default-cfg-revert

	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DATA) ./files/etc/hotplug.d/iface/20-disable-wifi $(1)/etc/hotplug.d/iface/20-disable-wifi

	$(INSTALL_DIR) $(1)/lib/functions
	$(INSTALL_DATA) ./files/lib/functions/captive-portal.sh $(1)/lib/functions/captive-portal.sh
endef

$(eval $(call BuildPackage,bmm-factory-default))

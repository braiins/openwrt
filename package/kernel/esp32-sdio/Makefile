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

PKG_NAME:=esp32-sdio
PKG_RELEASE:=$(AUTORELEASE)

ifeq ($(strip $(CONFIG_EXTERNAL_ESP32_SDIO_TREE)),"")
	$(error Empty CONFIG_EXTERNAL_ESP32_SDIO_TREE)
else
	PKG_SOURCE_VERSION:=local
	USE_SOURCE_DIR:=$(call qstrip,$(CONFIG_EXTERNAL_ESP32_SDIO_TREE))
endif

PKG_BUILD_PARALLEL:=1

STAMP_CONFIGURED_DEPENDS := $(STAGING_DIR)/usr/include/mac80211-backport/backport/autoconf.h

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/esp32-sdio-ng
  SUBMENU:=Wireless Drivers
  TITLE:=ESP32-SDIO NG driver optimized for Espressif chips used in SDIO mode
  DEPENDS:=+@DRIVER_11N_SUPPORT +kmod-mac80211 +kmod-cfg80211 +kmod-bluetooth +wireless-tools +esp32-sdio-common
  FILES:=$(PKG_BUILD_DIR)/esp_hosted_ng/host/esp32_sdio.ko
  PROVIDES:=kmod-esp32-sdio-ng
  VARIANT:=regular
endef

define KernelPackage/esp32-sdio-fg
  SUBMENU:=Wireless Drivers
  TITLE:=ESP32-SDIO FG driver optimized for Espressif chips used in SDIO mode
  DEPENDS:=+esp32-sdio-common
  FILES:=$(PKG_BUILD_DIR)/esp_hosted_fg/host/linux/host_driver/esp32/esp32_sdio_fg.ko
  PROVIDES:=kmod-esp32-sdio-fg
  VARIANT:=regular
endef

define Package/esp32-sdio-cli
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Utility for managing esp32-sdio-fg kernel driver
  DEPENDS=+kmod-esp32-sdio-fg
endef

define Package/esp32-sdio-common
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Scripts for bringing up and managing esp32 based wifi
  DEPENDS=+espflash +ii-gpiod-tools @TARGET_stm32mp15_ii2
endef

NOSTDINC_FLAGS_NG := \
	$(KERNEL_NOSTDINC_FLAGS) \
	-I$(PKG_BUILD_DIR)/esp_hosted_ng/host/ \
	-I$(PKG_BUILD_DIR)/esp_hosted_ng/host/include \
	-I$(STAGING_DIR)/usr/include/mac80211-backport \
	-I$(STAGING_DIR)/usr/include/mac80211-backport/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211 \
	-I$(STAGING_DIR)/usr/include/mac80211/uapi \
	-include backport/backport.h \
	-DCONFIG_AP_MODE

NOSTDINC_FLAGS_FG := \
	$(KERNEL_NOSTDINC_FLAGS) \
	-I$(PKG_BUILD_DIR)/esp_hosted_fg/common/include \
	-I$(PKG_BUILD_DIR)/esp_hosted_fg/host/linux/host_driver/esp32/ \
	-I$(STAGING_DIR)/usr/include/mac80211-backport \
	-I$(STAGING_DIR)/usr/include/mac80211-backport/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211 \
	-I$(STAGING_DIR)/usr/include/mac80211/uapi \
	-include backport/backport.h

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR)/esp_hosted_ng/host/ \
	ARCH=$(LINUX_KARCH) \
	KERNEL="$(LINUX_DIR)" \
	$(KERNEL_MAKE_FLAGS) \
	NOSTDINC_FLAGS="$(NOSTDINC_FLAGS_NG)" \
	target="sdio"

	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR)/esp_hosted_fg/host/linux/host_driver/esp32 \
	ARCH=$(LINUX_KARCH) \
	KERNEL="$(LINUX_DIR)" \
	$(KERNEL_MAKE_FLAGS) \
	NOSTDINC_FLAGS="$(NOSTDINC_FLAGS_FG)" \
	CONFIG_TEST_RAW_TP=n \
	CONFIG_BT_ENABLED=n \
	target="sdio" && \
	mv $(PKG_BUILD_DIR)/esp_hosted_fg/host/linux/host_driver/esp32/esp32_sdio.ko \
	$(PKG_BUILD_DIR)/esp_hosted_fg/host/linux/host_driver/esp32/esp32_sdio_fg.ko

	cd $(PKG_BUILD_DIR)/esp_hosted_fg/host/linux/host_control/c_support; \
	$(MAKE) $(PKG_JOBS) CC="$(TARGET_CC)"
endef

define Package/esp32-sdio-cli/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/esp_hosted_fg/host/linux/host_control/c_support/test.out $(1)/usr/bin/esp32-sdio-cli
endef

define Package/esp32-sdio-common/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/esp32-fw-log $(1)/usr/bin/esp32-fw-log

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/esp32-init $(1)/etc/init.d/esp32-init

	$(INSTALL_DIR) $(1)/lib/functions/
	$(INSTALL_DATA) ./files/lib/functions/esp32-wifi.sh $(1)/lib/functions/esp32-wifi.sh
endef

define Package/esp32-sdio-ng/config
	source "$(SOURCE)/Config.in"
endef

define Package/esp32-sdio-fg/config
	source "$(SOURCE)/Config.in"
endef

define Package/esp32-sdio-cli/config
	source "$(SOURCE)/Config.in"
endef

define InstallSdioFirmware
	$(INSTALL_DIR) $(1)/lib/firmware/esp32c6/sdio/$(2)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/bin/firmware/esp32c6/sdio/$(2)/bootloader.bin $(1)/lib/firmware/esp32c6/sdio/$(2)/bootloader.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/bin/firmware/esp32c6/sdio/$(2)/network_adapter.bin $(1)/lib/firmware/esp32c6/sdio/$(2)/network_adapter.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/bin/firmware/esp32c6/sdio/$(2)/ota_data_initial.bin $(1)/lib/firmware/esp32c6/sdio/$(2)/ota_data_initial.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/bin/firmware/esp32c6/sdio/$(2)/partition-table.bin $(1)/lib/firmware/esp32c6/sdio/$(2)/partition-table.bin
endef

define KernelPackage/esp32-sdio-fg/install
	$(call InstallSdioFirmware,$(1),fg)
endef

define KernelPackage/esp32-sdio-ng/install
	$(call InstallSdioFirmware,$(1),ng)

	$(INSTALL_DIR) $(1)/etc/hotplug.d/ieee80211/
	$(INSTALL_BIN) ./files/etc/hotplug.d/ieee80211/00-copy-mac $(1)/etc/hotplug.d/ieee80211/00-copy-mac

	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface/
	$(INSTALL_BIN) ./files/etc/hotplug.d/iface/50-wifi-wdt $(1)/etc/hotplug.d/ieee80211/50-wifi-wdt
endef

$(eval $(call KernelPackage,esp32-sdio-ng))
$(eval $(call KernelPackage,esp32-sdio-fg))
$(eval $(call BuildPackage,esp32-sdio-cli))
$(eval $(call BuildPackage,esp32-sdio-common))

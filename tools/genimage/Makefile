#
# Copyright (C) 2017 Yegor Yefremov <yegorslists@googlemail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=genimage
PKG_VERSION:=16

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://github.com/pengutronix/genimage/releases/download/v$(PKG_VERSION)
PKG_HASH:=869f9662d3b778c69b1d1fe70df658e1c9e90aeda26abb753f6fe55e8b0c6e73

HOST_BUILD_PARALLEL:=1
HOST_BUILD_DEPENDS:=confuse/host pkg-config/host

include $(INCLUDE_DIR)/host-build.mk

HOSTCC := $(HOSTCC_NOCACHE)
HOSTCXX := $(HOSTCXX_NOCACHE)

define Host/Install
	+$(MAKE) $(HOST_JOBS) -C $(HOST_BUILD_DIR) install
endef

$(eval $(call HostBuild))

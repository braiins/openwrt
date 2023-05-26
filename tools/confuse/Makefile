#
# Copyright (C) 2017 Yegor Yefremov <yegorslists@googlemail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=confuse
PKG_VERSION:=3.2.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://github.com/libconfuse/libconfuse/releases/download/v$(PKG_VERSION)
PKG_HASH:=a9240b653d02e8cfc52db48e8c4224426e528e1faa09b65e8ca08a197fad210b

PKG_FIXUP:=autoreconf
HOST_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/host-build.mk

HOST_CONFIGURE_ARGS += \
	--enable-shared=no \
	--enable-static=yes \
	--disable-rpath \
	--without-libiconv-prefix \
	--without-libintl-prefix \
	--disable-examples

define Host/Install
	+$(MAKE) $(HOST_JOBS) -C $(HOST_BUILD_DIR) install
endef

$(eval $(call HostBuild))

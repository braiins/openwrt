include $(INCLUDE_DIR)/bos-version.mk

define Package/base-files/install-target
	$(BOS_VERSION_SED_SCRIPT) \
		$(1)/etc/banner \
		$(1)/etc/bos_build \
		$(1)/etc/bos_major \
		$(1)/etc/bos_version
	$(call Package/base-files/install-subtarget,$(1))
endef

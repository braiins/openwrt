VERSION_FW:=$(call qstrip,$(CONFIG_FIRMWARE_VERSION))
VERSION_FW_MAJOR:=$(or $(call qstrip,$(CONFIG_FIRMWARE_MAJOR)),$(VERSION_FW))
VERSION_FW_REQUIRE:=$(call qstrip,$(CONFIG_FIRMWARE_REQUIRE))

BOS_VERSION_SED_SCRIPT:=$(SED) \
	's,%f,$(call sed_escape,$(VERSION_FW)),g' -e \
	's,%F,$(call sed_escape,$(VERSION_FW_MAJOR)),g' -e \
	's,%r,$(call sed_escape,$(VERSION_FW_REQUIRE)),g'

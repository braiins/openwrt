#!/bin/sh

BOS_BUILD_PATH="/etc/bos_build"
BOS_MAJOR_PATH="/etc/bos_major"
BOS_MODE_PATH="/etc/bos_mode"
BOS_REVISION_PATH="/etc/bos_revision"
BOS_PLATFORM_PATH="/etc/bos_platform"
BOS_VERSION_PATH="/etc/bos_version"
FACTORY_DEFAULT_FLAG_PATH="/etc/factory-default"
MINER_HWID_PATH="/tmp/miner_hwid"
WIFI_MAC_PATH="/tmp/wifi_mac"
NVMEM_PATH="/sys/bus/nvmem/devices/stm32-romem0/nvmem"

BRAIINS_BOARD_stm32mp157c_ii1_am2="braiins,stm32mp157c-ii1-am2"
BRAIINS_BOARD_stm32mp157c_ii1_am2_p03_a12="braiins,stm32mp157c-ii1-am2_p03_a12"
BRAIINS_BOARD_stm32mp157c_ii2_bmm1="braiins,stm32mp157c-ii2-bmm1"

EMMC_BOOT_DEV="mmcblk0boot0"
EMMC_BOOT_BACKUP_DEV="mmcblk0boot1"

EMMC_BOOT_BACKUP_SIZE=0x400000
EMMC_UBOOT_SIZE=0x700000
EMMC_UBOOT_BACKUP_OFFSET=0x100000
EMMC_UBOOT_BACKUP_SIZE=0x200000

PART_NAME_FIP="fip"

UBOOT_ENV_SIZE=0x2000
UBOOT_ENV_FULL_SIZE=0x4000

NVMEM_WORD_SIZE=4
NVMEM_OTP_MINER_HWID=63
NVMEM_OTP_WIFI_MAC=66

FACTORY_DEFAULT_TRUE_VAL="true"
FACTORY_DEFAULT_FALSE_VAL="false"

bos_build() {
	cat "$BOS_BUILD_PATH" 2>/dev/null
	return 0
}

bos_major() {
	cat "$BOS_MAJOR_PATH" 2>/dev/null
	return 0
}

bos_mode() {
	cat "$BOS_MODE_PATH" 2>/dev/null
	return 0
}

bos_platform() {
	cat "$BOS_PLATFORM_PATH" 2>/dev/null
	return 0
}

bos_version() {
	cat "$BOS_VERSION_PATH" 2>/dev/null
	return 0
}

bos_revision() {
	cat "$BOS_REVISION_PATH" 2>/dev/null
	return 0
}

miner_hwid() {
	cat "$MINER_HWID_PATH" 2>/dev/null
	return 0
}

wifi_mac() {
	cat "$WIFI_MAC_PATH" 2>/dev/null
	return 0
}

board_iface() {
	local bos_platform=$(bos_platform)
	echo ${bos_platform##*-}
	return 0
}

default_ssid() {
	MAC_ID=$(cat /sys/class/net/eth0/address | tr -d ':' | cut -c '10-')
	board=$(bos_platform)

	case "$board" in
		stm32mp157c-ii2-bmm1)
			echo "Mini Miner Setup [${MAC_ID}]"
			;;
		*)
			echo "BraiinsOS Setup [${MAC_ID}]"
			;;
	esac
}

is_factory_default() {
	if [ "$(cat ${FACTORY_DEFAULT_FLAG_PATH} 2>/dev/null)" = "${FACTORY_DEFAULT_TRUE_VAL}" ]; then
		echo yes
		return 0
	else
		echo no
		return 1
	fi
}

set_factory_default() {
	echo "${FACTORY_DEFAULT_TRUE_VAL}" > "${FACTORY_DEFAULT_FLAG_PATH}"
	sync "${FACTORY_DEFAULT_FLAG_PATH}"
}

unset_factory_default() {
	echo "${FACTORY_DEFAULT_FALSE_VAL}" > "${FACTORY_DEFAULT_FLAG_PATH}"
	sync "${FACTORY_DEFAULT_FLAG_PATH}"
}

get_env_config() {
	fw_printenv -n $1 2>/dev/null || echo ""
}

find_part_fip_dev() {
	local root_dev fip_dev

	root_dev=$(sed "s/root=\(.*\)p. .*/\1/g" /proc/cmdline)
	blkid \
		--match-token PARTLABEL="$PART_NAME_FIP" \
		--output device ${root_dev}p*
}

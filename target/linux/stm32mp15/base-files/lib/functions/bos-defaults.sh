#!/bin/sh

BOS_BUILD_PATH="/etc/bos_build"
BOS_MAJOR_PATH="/etc/bos_major"
BOS_MODE_PATH="/etc/bos_mode"
BOS_PLATFORM_PATH="/etc/bos_platform"
BOS_VERSION_PATH="/etc/bos_version"
MINER_HWID_PATH="/tmp/miner_hwid"
NVMEM_PATH="/sys/bus/nvmem/devices/stm32-romem0/nvmem"

BRAIINS_BOARD_stm32mp157c_ii1_am2="braiins,stm32mp157c-ii1-am2"

PART_NAME_FIP="fip"

NVMEM_WORD_SIZE=4
NVMEM_OTP_MINER_HWID=63

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

miner_hwid() {
	cat "$MINER_HWID_PATH" 2>/dev/null
	return 0
}

board_iface() {
	local bos_platform=$(bos_platform)
	echo ${bos_platform##*-}
	return 0
}

get_env_config() {
	fw_printenv -n $1 2>/dev/null || echo ""
}

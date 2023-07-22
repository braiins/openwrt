#!/bin/sh

BOARD_NAME_PATH="/tmp/sysinfo/board_name"
BOS_PLATFORM_PATH="/etc/bos_platform"
MINER_HWID_PATH="/tmp/miner_hwid"
NVMEM_PATH="/sys/bus/nvmem/devices/stm32-romem0/nvmem"

BOARD_NAME=$(cat "$BOARD_NAME_PATH")

PART_NAME_FIP="fip"

NVMEM_WORD_SIZE=4
NVMEM_OTP_MINER_HWID=63

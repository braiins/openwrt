#!/bin/sh

PART_NAME_FIP="fip"

NVMEM_PATH="/sys/bus/nvmem/devices/stm32-romem0/nvmem"
NVMEM_WORD_SIZE=4
NVMEM_OTP_MINER_HWID=63

MINER_HWID_PATH="/tmp/miner_hwid"

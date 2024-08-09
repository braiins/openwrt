# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024  Braiins Systems s.r.o.

include $(TOPDIR)/rules.mk

BOARDNAME:=Braiins Control Board (stm32mp15_ii2)
CPU_TYPE:=cortex-a7
CPU_SUBTYPE:=neon-vfpv4

BOARD_IFACE := bmm1

BOARD_REVISIONS :=

SUBTARGET_COMPATIBLES := \
	braiins,stm32mp157c-ii2-bmm1

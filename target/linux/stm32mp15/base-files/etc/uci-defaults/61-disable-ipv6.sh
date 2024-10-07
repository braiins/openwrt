#!/bin/sh

# This script disable IPv6-related network settings
# We don't want to have IPv6 enabled for now

. /lib/functions/bos-defaults.sh

board=$(bos_platform)

case "$board" in
	stm32mp157c-ii2-bmm1|stm32mp157c-ii1-am2)
		uci -q delete network.eth_lan6
		uci -q delete dhcp.odhcpd
	;;
esac

uci commit

exit 0

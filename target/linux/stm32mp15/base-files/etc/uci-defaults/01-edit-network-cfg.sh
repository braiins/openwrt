#!/bin/sh

# This script disable IPv6-related network settings
# We don't want to have IPv6 enabled for now

. /lib/functions/bos-defaults.sh

board=$(bos_platform)

case "$board" in
	stm32mp157c-ii2-bmm1|stm32mp157c-ii1-am2)
		# This is here for a special reason!
		# See comments in /etc/board.d/02_network for details.
		uci -q rename network.lan_temp='lan'

		# Remove IPv6 config, we don't want it for now.
		uci -q delete network.lan_temp6
		uci -q delete dhcp.odhcpd
	;;
esac

uci commit

exit 0

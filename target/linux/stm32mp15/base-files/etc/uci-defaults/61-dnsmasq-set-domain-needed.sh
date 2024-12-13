#!/bin/sh

# We want to keep this option disabled to be able to resolve
# `fp-braiins` from the local DNS cache

if [ "$(uci get dhcp.@dnsmasq[0].domainneeded)" != "0" ]; then
	uci set dhcp.@dnsmasq[0].domainneeded="0"
	uci commit dhcp
fi

exit 0

#!/bin/sh

# Captive portal configuration

enable_captive_portal() {
	local ip_addr="$1"

	# Redirect all DNS queries to the default IP in AP mode 
	uci batch << EOI
	set dhcp.@dnsmasq[0].nonwildcard='0'
	set dhcp.@dnsmasq[0].localservice='0'
	set dhcp.@dnsmasq[0].cachesize='0'            
	set dhcp.@dnsmasq[0].local_ttl='0'            
	add_list dhcp.@dnsmasq[0].address='/com/$ip_addr' 
	add_list dhcp.@dnsmasq[0].address='/us/$ip_addr'
	add_list dhcp.@dnsmasq[0].address='/info/$ip_addr'
	add_list dhcp.@dnsmasq[0].address='/net/$ip_addr'
	add_list dhcp.@dnsmasq[0].address='/html/$ip_addr'
	# Forces clients to use $ip_addr as DNS
	add_list dhcp.wifi_ap.dhcp_option="6,$ip_addr"
EOI

	uci commit
	
	return 0
}

disable_captive_portal() {
	uci batch << EOI
	set dhcp.@dnsmasq[0].nonwildcard='1'
	set dhcp.@dnsmasq[0].localservice='1'
	delete dhcp.@dnsmasq[0].cachesize            
	delete dhcp.@dnsmasq[0].local_ttl
	delete dhcp.@dnsmasq[0].address	
EOI

	uci delete dhcp.wifi_ap.dhcp_option

	uci commit
	
	return 0
}

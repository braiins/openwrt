#!/bin/sh

FACTORY_DEFAULT_AP_IP_ADDR="10.0.0.21"
FACTORY_DEFAULT_AP_IP_MASK="255.255.255.0"
FACTORY_DEFAULT_AP_INTF_NAME="wifi_ap"
FACTORY_DEFAULT_STA_INTF_NAME="wifi_sta"
FACTORY_DEFAULT_ETH_INTF_NAME="lan"

# Captive portal configuration

enable_captive_portal() {
	local ip_addr="$1"

	# Redirect all DNS queries to the default IP in AP mode 
	uci -q batch <<-EOF
		set dhcp.@dnsmasq[0].nonwildcard='0'
		set dhcp.@dnsmasq[0].localservice='0'
		set dhcp.@dnsmasq[0].cachesize='0'
		set dhcp.@dnsmasq[0].local_ttl='0'
		add_list dhcp.@dnsmasq[0].address='/com/$ip_addr'
		add_list dhcp.@dnsmasq[0].address='/us/$ip_addr'
		add_list dhcp.@dnsmasq[0].address='/info/$ip_addr'
		add_list dhcp.@dnsmasq[0].address='/net/$ip_addr'
		add_list dhcp.@dnsmasq[0].address='/html/$ip_addr'
		add_list dhcp.@dnsmasq[0].address='/network/$ip_addr'
		# Forces clients to use $ip_addr as DNS
		add_list dhcp.${FACTORY_DEFAULT_AP_INTF_NAME}.dhcp_option="6,$ip_addr"
	EOF

	uci commit
	
	return 0
}

disable_captive_portal() {
	uci -q batch <<-EOF
		set dhcp.@dnsmasq[0].nonwildcard='1'
		set dhcp.@dnsmasq[0].localservice='1'
		delete dhcp.@dnsmasq[0].cachesize
		delete dhcp.@dnsmasq[0].local_ttl
		delete dhcp.@dnsmasq[0].address
		delete dhcp.${FACTORY_DEFAULT_AP_INTF_NAME}.dhcp_option
	EOF

	uci commit
	
	return 0
}

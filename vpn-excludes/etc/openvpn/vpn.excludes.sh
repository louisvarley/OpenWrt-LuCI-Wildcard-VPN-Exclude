#!/bin/sh

# Author: Louis Varley
# louisvarley@googlemail.com. 

# For OpenWRT (Test on V17)
# This script aims to route a domain in a "wildcard" way to your main gateway in instances where you may be using a VPN and routing all traffic
# Example, issue occurs when you want to use the BBC Iplayer but you are using a VPN, even if you are in the UK. You Could! disable the VPN when you want to
# watch the iplayer, or just run the VPN from a local machine. But thats too much work! 
# The BBC iPlayer Checks your IP but there are so many sub domains used its impossible to find the exact IP you need to exclude from the VPN
# Set up your VPN so all traffic routes through your VPN, now install this script to run as a cron (how ever often you want)
# add to the wild.excludes file your domains
# TESTED and working (bbc.co.uk, bbc.com, bbci.co.uk, bbci.com)
# You must have DNS logging enabled and "dns.log" in this script points to your DNS log. 

# This script will check your list of domains, and then search the DNS log for any matching results (all sub domains)
# They will be added to found.wildcard.excludes 
# Then looped and routes to exclude from VPN added. Simple

# IMPORTANT: the DNS log file grows quickly and this script clears it once it has read it. Store your log on USB and run this script as often as you can. 

# NOTE: When you first visit a site, dont be alarmed if it doesnt pick it up, remember this script has to find, lookup and then apply the rules. Which may take
# as long as your next cron runs. 

#Find the Main Gateway
WAN_GW="$(. /lib/functions/network.sh; network_get_gateway ip wan; echo $ip)"

#Loop /etc/openvpn/vpn.excludes and copy to /etc/openvpn/found.vpn.excludes
while read domain; do
	echo $domain
	while read dnsline; do
		for s in $dnsline; do
			if case ${s} in *"${domain}"*) true;; *) false;; esac; then
				for s in $dnsline; do
					if case ${s} in *"query"*) true;; *) false;; esac; then
						#Should pull domain from log
						excludeDomain=`echo $dnsline | sed -e 's/.*[:]/ /g' | sed -e 's/[^ ]* *//' -e 's/[^ ]* *//' -e 's/ .*//'`
						if grep -q "$excludeDomain" "/etc/openvpn/found.vpn.excludes"; then
							echo "$domain already exists in found"
						else
							echo "Adding $excludeDomain"
							echo $excludeDomain >> /etc/openvpn/found.vpn.excludes
						fi
						
					fi
				done
			fi
		done         
	done </mnt/share/logs/dns.log  
done </etc/openvpn/vpn.excludes

#!Important, Now clear the dns log file. Keeps the DNS log file small
cat /dev/null > /mnt/share/logs/dns.log  

while read domain; do
	echo "Excluding $domain from TUN0 Gateway"
	#Route via gateway
	for ip in $(nslookup $domain | awk '/^Name:/,0{if (/^Addr/)print $3}'); do
		ip route add $ip via $WAN_GW
		echo $ip 
	done
done </etc/openvpn/found.vpn.excludes

# flush cache
ip route flush cache

exit 0
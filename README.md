Author: Louis Varley
louisvarley@googlemail.com. 

# OpenWrt-LuCI-Wildcard-VPN-Exclude
Exclude Domains from an all traffic VPN but auto gather from DNS any additional subdomains from root domain

# Tested on OpenWrt 18. 

Drop these files in the respective directories, 

ensure you have TUN0 set as your VPN (or change in .sh)

This is an alternative to using dnsmasq and IPSETs to exclude websites from a load balanced vpn setup using MWAN3. I created this as my router did not have enough on chip storage for dnsmasq-full and didnt want to run a root FS from a USB. 

This script aims to route a domain in a "wildcard" way to your main gateway in instances where you may be using a VPN and routing all traffic
Example, issue occurs when you want to use the BBC Iplayer but you are using a VPN, even if you are in the UK. You Could! disable the VPN when you want to

watch the iplayer, or just run the VPN from a local machine. But thats too much work! 
The BBC iPlayer Checks your IP but there are so many sub domains used its impossible to find the exact IP you need to exclude from the VPN
Set up your VPN so all traffic routes through your VPN, now install this script to run as a cron (how ever often you want)
add to the wild.excludes file your domains (bbc.co.uk, bbc.com, ibbc.com, ibbc.co.uk)
You must have DNS logging enabled and "dns.log" in this script points to your DNS log. 

This script will check your list of domains, and then search the DNS log for any matching results (all sub domains)
They will be added to found.wildcard.excludes 
Then looped and routes to exclude from VPN added. Simple

IMPORTANT: the DNS log file grows quickly and this script clears it once it has read it. Store your log on USB if you can and run this script as often as you can. 

NOTE: When you first visit a site, dont be alarmed if it doesnt pick it up, remember this script has to find, lookup and then apply the rules. Which may take as long as your next cron runs.


ADD the following to /etc/dnsmasq

    log-queries
    log-facility=/mnt/share/logs/dns.log


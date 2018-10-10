# OpenWrt-LuCI-Wildcard-VPN-Exclude
Exclude Domains from an all traffic VPN but auto gather from DNS any additional subdomains from root domain

Copy of my other script but with a Luci Front end

Tested on OpenWrt 18. 

Drop these files in the respective directories, 

ensure you have TUN0 set as your VPN (or change in .sh)

make sure to enable DNS logging. 

Run this script on a cronjob every 15 minutes or so. 

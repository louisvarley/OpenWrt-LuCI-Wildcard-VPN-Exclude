-- Copyright 2018 Louis Varley <louisvarley@googlemail.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.vpnexclude", package.seeall)

function index()
	if not nixio.fs.access("/etc/openvpn/") then
		return
	end

	if not nixio.fs.access("/etc/openvpn/vpn.excludes") then
		touch "/etc/openvpn/vpn.excludes"
	end

	local page

	page = entry({"admin", "services", "vpnexclude"}, form("vpnexclude"), _("VPN Excludes"), 45)
	page.dependant = false
	page.sysauth = "root"
	page.sysauth_authenticator = "htmlauth"

end

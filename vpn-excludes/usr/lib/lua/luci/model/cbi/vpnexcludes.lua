-- Copyright 2018 Louis Varley <louisvarley@googlemail.com>
-- Licensed to the public under the Apache License 2.0.

local fs  = require "nixio.fs"

f = SimpleForm("vpnexclude", translate("Domains to exclude from VPN"),
	translate("Root Level domains to exclude from VPN. Any Second level or above domains will be automaticly excluded when found in DNS"))

s = f:section(SimpleSection, "", translate("Download file"))	
	
f.reset = false
f.submit = "Save"	
	
t = f:field(TextValue, "vpnexclude")
t.rmempty = true
t.rows = 20


function t.cfgvalue(self, section)
	return fs.readfile("/etc/openvpn/vpn.excludes")
end

function t.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	fs.writefile("/etc/openvpn/vpn.excludes", value)
end



return f

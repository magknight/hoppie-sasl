local remoteServerDataref = globalPropertys("cpdlc/remoteServer")
local callsignDataref = globalPropertys("cpdlc/callsign")
local logonCodeDataref = globalPropertys("cpdlc/logonCode")

-- -----------------------------------------------------------------------------
-- base code in this section from
-- https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99
-- -----------------------------------------------------------------------------
local char_to_hex = function(c)
	return string.format("%%%02X", string.byte(c))
end

-- -----------------------------------------------------------------------------
-- Networking
-- -----------------------------------------------------------------------------
local network = {_version = "1"}

function network.getAsync(params, callback)
	local url = get(remoteServerDataref) .. "?logon=" .. get(logonCodeDataref) .. "&from=" .. get(callsignDataref)
	if not params.to then
		params.to = "SERVER"
	end
	if not params.type then
		logError("Cannot send message: no message type specified")
	end
	if params ~= nil then
		for key, value in pairs(params) do
			value = value:gsub(" ", "+")
			url = url .. "&" .. key .. "=" .. value
		end
	end
	print(url)
	sasl.net.downloadFileContentsAsync(url, callback)
end

return network

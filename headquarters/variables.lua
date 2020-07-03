-- -----------------------------------------------------------------------------
-- SECTION uplink values
-- -----------------------------------------------------------------------------
uplinkValues = {
	heading = 0,
	speed = 0,
	mach = false,
	altitude = 0
}
-- -----------------------------------------------------------------------------
-- Comm
-- -----------------------------------------------------------------------------
commClickResponse = 0
commAliases = {}
commMinGen = 1 -- message identifier generation
defineProperty("commReviewMessagesPage", 1) -- message identifier generation
defineProperty("commManagerPage", 1) -- message identifier generation
commPageSendText = ""
-- 0 - nothing did anything
-- 1 - success
-- 2 - INVALID FORMAT
CommPageLeftMouseIsClicked = 0
commPfdMessageId = 0
defineProperty("commPfdTimer", 0)
commMessageTable = {}
reviewMenuItems = {
	{line1 = "ATC", line2 = "UPLINKS...", line2Active = true, reviewId = 1, inactive = true},
	{line1 = "FLIGHT INFO", line2 = "UPLINKS...", line2Active = true, reviewId = 1, inactive = true},
	{line1 = "SENT...", line2 = "", line2Active = false, reviewId = 1, inactive = true},
	{line1 = "ATC", line2 = "DOWNLINKS...", line2Active = true, reviewId = 1, inactive = true},
	{line1 = "FLIGHT INFO", line2 = "DOWNLINKS...", line2Active = true, reviewId = 1, inactive = true},
	{line1 = "RECIEVED...", line2 = "", line2Active = false, reviewId = 1, inactive = true},
	{line1 = "WEATHER...", line2 = "", line2Active = false, reviewId = 1, inactive = true}
}

local network = require "network"
local commPriorityList = {
	telex = 1,
	inforeq = 1,
	atis = 2,
	weather = 2,
	cpdlc = 3
}

function addCommMessage(time, type, response, packet, facility, uplink)
	if packet == nil then
		return false
	end
	if type == "telex" or type == "inforeq" or type == "atis" or type == "weather" then
		-- print(network.wrap(packet)[1])
		local status = ""
		if not uplink then
			status = "SENT"
		else
			-- handleUplinkedValues(messageAttributes)
			local messageId = 0
			local messageAttributes = {}
			for index, value in ipairs(commAliases) do
				local thingToMatch = value.regex
				if packet:match(thingToMatch) then
					packetId = index
					local fields = value.fields
					local results = {packet:match(thingToMatch)}
					-- print(results[1])
					for key, value in pairs(results) do
						if fields[key] ~= nil then
							messageAttributes[fields[key]] = value
						else
							break
						end
					end
				end
			end
		end

		table.insert(commMessageTable, {time = string.format(time, "%f4.0"), message = packet, facility = facility, status = status, type = type, response = response or "", uplink = uplink or false})
	elseif type == "cpdlc" then
		-- /data2/4112//AN/READY?
		-- /data2/1832//R/CLR TO @LEPA@ RWY @27R@ DEP @MAXIT1F@ INIT CLB @6000ft@ SQUAWK @2262@ WHEN RDY CALL FREQ @121.700@ IF UNABLE CALL VOICE
		-- /data2/31/8/N/WILCO
		-- /data2/8//WU/MAINTAIN @M.75
		scheme, min, mrn, response, message = string.match(packet, "/(.-)/(.-)/(.-)/(.-)/(.+)$")
		if message == nil then
			logWarning("Invalid message sent to CPDLC")
			return
		end

		-- work out message id
		local messageId = 0
		local messageAttributes = {}
		if uplink then
			for index, value in ipairs(commAliases) do
				local thingToMatch = value.regex
				if message:match(thingToMatch) then
					messageId = index
					local fields = value.fields
					local results = {message:match(thingToMatch)}
					-- print(results[1])
					for key, value in pairs(results) do
						if fields[key] ~= nil then
							messageAttributes[fields[key]] = value
						else
							break
						end
					end
				end
			end
		-- handleUplinkedValues(messageAttributes)
		end
		-- print(messageAttributes.vhfFrequency)
		message = message:gsub("@", "")
		table.insert(commMessageTable, {time = string.format(time, "%f4.0"), message = message, facility = facility, status = "", type = "cpdlc", response = response, min = min, mrn = mrn, uplink = uplink or false, attributes = messageAttributes, cpdlcId = messageId})
	end
	if uplink then
		-- sasl.commandOnce(soundchimesMediumComm)
		reviewMenuItems[6].inactive = false
		if type == "cpdlc" then
			reviewMenuItems[1].inactive = false
		elseif type == "weather" then
			reviewMenuItems[7].inactive = false
		elseif type == "telex" or type == "atis" then
			reviewMenuItems[2].inactive = false
		end
	else
		reviewMenuItems[3].inactive = false
		if type == "cpdlc" then
			reviewMenuItems[4].inactive = false
		elseif type == "weather" then
			reviewMenuItems[7].inactive = false
		elseif type == "telex" or type == "atis" then
			reviewMenuItems[5].inactive = false
		end
	end
	if commPfdMessageId == 0 then -- no active pfd messages, add this one
		if type == "cpdlc" and uplink then
			commPfdMessageId = #commMessageTable
		end
	else
		if type == "cpdlc" and uplink then
			local currentMessagePrio = commPriorityList[commMessageTable[commPfdMessageId].type]
			local newMessagePrio = commPriorityList[commMessageTable[#commMessageTable].type]
			if newMessagePrio > currentMessagePrio then
				commPfdMessageId = #commMessageTable
			end
		end
	end
end

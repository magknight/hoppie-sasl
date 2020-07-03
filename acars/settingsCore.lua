----------------------------------------------------------------------------------
-- core setting defines
----------------------------------------------------------------------------------
local json = require "json"
local configPath = string.gsub(moduleDirectory, "/data/modules/", "") .. "/settings/config.json"
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Read
---- Define conversion tables from settings (pretty) to datarefs (not so pretty)
---- Specific read, livery, aircraft versions
----------------------------------------------------------------------------------
local configConversionTable = {
	use833 = use833Dataref,
	acarsLogonCode = acarsLogonCodeDataref,
	acarsRemoteServer = acarsRemoteServerDataref,
	acarsEnabled = acarsEnabledDataref,
	callsign = callsignDataref
}
local cConfigSettings
----------------------------------------------------------------------------------
-- Fire the error only once for missing global settings
----------------------------------------------------------------------------------
local errorOnce = false
function settingsSetup()
	globalConfigSettings = json.readAndParse(configPath)
	setSimSettings(globalConfigSettings)
	-- print(table.concat(globalConfigSettings), configPath)
end
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function setSimSettings(currentSettings)
	-- function to take the table and actually set the datarefs
	-- it loops through them all and sets them
	if not currentSettings then
		logError("invalid table sent to setSimSettings(), ending")
		return 0
	end
	for index, value in pairs(currentSettings) do
		if value == false then
			value = 0
		elseif value == true then
			value = 1
		-- else
		-- 	logError("invalid value for setting the settings, index " .. index) -- dealing with strings
		end
		print(index, value)
		local dataref = configConversionTable[index]
		set(dataref, value)
		print(get(dataref))
	end
end
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Write
---- Define conversion tables from settings (pretty) to datarefs (not so pretty)
---- Specific write, livery, aircraft versions
----------------------------------------------------------------------------------
local writeConfigConversionTable = {
	use833 = "use833",
	acarsLogonCodeDataref = "acarsLogonCode",
	acarsRemoteServerDataref = "acarsRemoteServer",
	acarsEnabledDataref = "acarsEnabled",
	callsignDataref = "callsign"
}
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function changeSettingValue(id, value, location, keepInt)
	if not keepInt then
		if value == 1 then
			value = true
		elseif value == 0 then
			value = false
		end
	end
	local position = writeConfigConversionTable[id]
	print("was " .. tostring(globalConfigSettings[position]))
	-- if the value sent to us is invalid, we need to error it
	if position == nil then
		logError("invalid id called to global settings: " .. id)
		return
	end
	-- set the valid values to the core table
	globalConfigSettings[position] = value
	logDebug("now " .. tostring(globalConfigSettings[position]))
	-- now, let's write it to the appropriate settings file
	writeSettingsToFile()
end
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function writeSettingsToFile()
	json.stringifyAndWrite(configPath, globalConfigSettings)
end

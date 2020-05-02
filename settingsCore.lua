----------------------------------------------------------------------------------
-- core setting defines
----------------------------------------------------------------------------------
local json = require "json"
local defaultGlobalSettingPath = sasl.getProjectPath() .. "/settings/defaultGlobalSettings.json"
local globalSettingPath = sasl.getProjectPath() .. "/settings/globalSettings.json"
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Read
---- Define conversion tables from settings (pretty) to datarefs (not so pretty)
---- Specific read, global versions
----------------------------------------------------------------------------------
local globalSettingsConversionTable = {
	remoteServer = remoteServerDataref,
	callsign = callsignDataref,
	logonCode = logonCodeDataref
}
local cGlobalSettings
----------------------------------------------------------------------------------
-- Fire the error only once for missing global settings
----------------------------------------------------------------------------------
local errorOnce = false
function settingsSetup()
	--- check if the default settings file exists (it must to make this work)
	if isFileExists(defaultGlobalSettingPath) == false then
		if errorOnce == false then
			logError("The default global settings file is missing. This file is required to load the plugin. \nPlease re-install from Github.")
			errorOnce = true
		end
		return
	end
	-- check if global settings exists. If not, make one.
	if isFileExists(globalSettingPath) == false then
		logInfo("Missing global settings file. Making one")
		local defaultBits = {}
		local defaultGlobalSettingsA = json.readAndParse(defaultGlobalSettingPath)
		defaultBits.comments = {
			"This is the global settings file for your hoppie-sasl",
			"It can be edited, but should always conform to JSON standards."
		}
		defaultBits.globalConfig = defaultGlobalSettingsA.defaultGlobalConfig
		json.stringifyAndWrite(globalSettingPath, defaultBits)
	end
	-- load in the default settings first, then overwrite them with global and livery specific user settings
	defaultGlobalSettings = json.readAndParse(defaultGlobalSettingPath)
	globalSettings = json.readAndParse(globalSettingPath)
	-- call the read settings function
	cGlobalSettings = readGlobalSettings()
	-- actually set the settings we've requested to the drefs
	setGlobalSimSettings(cGlobalSettings)
	logInfo("Settings are setup")
	return
end
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function readGlobalSettings()
	-- load the interesting bits of the settings tables
	local currentGlobalSettings = defaultGlobalSettings.defaultGlobalConfig
	-- take the stuff from the user's global config and overwrite the default settings
	if globalSettings.globalConfig ~= nil then
		for index, value in pairs(globalSettings.globalConfig) do
			currentGlobalSettings[index] = value
		end
	end
	-- return the livery settings and the global settings table
	return currentGlobalSettings
end
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function setGlobalSimSettings(currentGlobalSettings)
	-- function to take the table and actually set the datarefs
	-- it loops through them all and sets them
	if not currentGlobalSettings then
		logError("invalid table sent to setGlobalSimSettings(), ending")
		return 0
	end
	for index, value in pairs(currentGlobalSettings) do
		local drefToSet = globalSettingsConversionTable[index]
		-- change true/false into 1/0 to satisfy the datarefs

		if value == false then
			value = 0
		elseif value == true then
			value = 1
		-- else
		-- 	logError("invalid value for setting the settings, index " .. index)
		end
		-- print("setting " .. index .. " to " .. value)
		-- set the result to the dataref
		set(drefToSet, value)
	end
end
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Write
---- Define conversion tables from settings (pretty) to datarefs (not so pretty)
---- Specific write, livery, aircraft versions
----------------------------------------------------------------------------------
local writeGlobalSettingsConversionTable = {
	remoteServer = "remoteServerDataref",
	callsign = "callsignDataref",
	logonCode = "logonCodeDataref"
}
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function changeSettingValue(id, value)
	local position = writeGlobalSettingsConversionTable[id]
	print("was " .. tostring(cGlobalSettings[position]))
	-- if the value sent to us is invalid, we need to error it
	if position == nil then
		logError("invalid id called to global settings: " .. id)
		return
	end
	-- set the valid values to the core table
	cGlobalSettings[position] = value
	logDebug("now " .. tostring(cGlobalSettings[position]))
	-- now, let's write it to the appropriate settings file
	writeSettingsToFile(location)
end
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function writeSettingsToFile(location)
	-- take the settings table given to us, and write the file
	local table = {
		globalConfig = cGlobalSettings
	}
	json.stringifyAndWrite(globalSettingPath, table)
end

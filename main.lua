local setupHasRun = false
addSearchPath(moduleDirectory)

include "coreFunctions.lua"
include "colours.lua"
-- include "fonts.lua"

callsignDataref = createDatarefS("cpdlc/callsign", "")
logonCodeDataref = createDatarefS("cpdlc/logonCode", "")
remoteServerDataref = createDatarefS("cpdlc/remoteServer", "")

include "settingsCore.lua"
local network = require "network"
function printCallback(url, result, notError, error)
	if notError == false then
		logError(inError)
		return
	end
	logInfo(result)
end
cpdlcCorePopup =
	contextWindow {
	name = "CPDLC",
	position = {50, 50, 500, 500},
	noBackground = false,
	minimumSize = {300, 300},
	maximumSize = {1000, 1000},
	gravity = {0, 1, 0, 1},
	visible = true,
	noDecore = true,
	components = {
		corePopup {position = {0, 0, 500, 500}}
	}
}

function update()
	if not setupHasRun then
		setupHasRun = true
		settingsSetup()
	-- network.getAsync({type = "ping", destination = "SERVER"}, printCallback)
	end
end

function draw()
end

-- -----------------------------------------------------------------------------
-- Best option outside of dev mode, doesn't work in dev mode
-- -----------------------------------------------------------------------------
-- function onPlaneLoaded()
-- 	settingsSetup()
-- end
function menuHandler()
	print("called")
	if cpdlcCorePopup:isVisible() then
		cpdlcCorePopup:setIsVisible(false)
	else
		cpdlcCorePopup:setIsVisible(true)
	end
end
sasl.appendMenuItem(PLUGINS_MENU_ID, "CPDLC", menuHandler())

----------------------------------------------------------------------------------
-- Required search paths
----------------------------------------------------------------------------------
addSearchPath(moduleDirectory .. "/acars/pages/")
----------------------------------------------------------------------------------
-- Global variables
----------------------------------------------------------------------------------
CommMousePositionLeftX = 0
CommMousePositionLeftY = 0
CommPageLeftPosition = 0
local network = require "network"
----------------------------------------------------------------------------------
-- Local variables
----------------------------------------------------------------------------------
commLocationActive = {3, 235, 467, 3, 235, 467} -- The locations of the boxes at the top of the screen, X coord only
local commPageDefaultId = {20, 42, 5, 57, 59, 76} -- The locations of the boxes at the top of the screen, X coord only
commPagesThatArePossible = {}
----------------------------------------------------------------------------------
-- Pages
----------------------------------------------------------------------------------
commPagesThatArePossible[20] = {commAtcMenu {}}
commPagesThatArePossible[42] = {commFlightInfoMenu {}}
commPagesThatArePossible[43] = {commDepClearRequest {}}
commPagesThatArePossible[47] = {commWeatherRequest {}}
commPagesThatArePossible[48] = {commWeatherRequest {}}
commPagesThatArePossible[49] = {commWeatherRequest {}}
commPagesThatArePossible[57] = {commReviewMenu {}}
commPagesThatArePossible[58] = {commReviewMessages {}}
commPagesThatArePossible[59] = {commManagerMenu {}}
commPagesThatArePossible[76] = {commNewMessages {}}
commPagesThatArePossible[78] = {commMessagePage {}}
commPagesThatArePossible[1] = {commLogonStatus {}}
-- commPagesThatArePossible[5] = {commPagePAcore {}}
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--[[
function onKeyDown(component, char, key)
	print(component .. "," .. char .. "," .. key)
	if key == 8 then
		leftSysScratch = leftSysScratch:sub(0, -2)
		return 1
	elseif string.len(leftSysScratch) < 20 then
		leftSysScratch = leftSysScratch .. string.upper(string.char(char))
		return 1
	end
end--]]
include "commDrawingFunctions.lua"
local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")
function standardMessageResponse(url, result, notError, error)
	if notError then
		if string.sub(result, 1, 2) == "ok" then
			-- print("message is valid")
			local message = string.upper(string.gsub(result, "^.+{", ""))
			message = string.gsub(message, "}.+$", "")
			addCommMessage(os.date("!%H%M"), "telex", "NE", message, "SERVER", true)
		end
	else
		logError(error)
	end
end
function clearanceCallback(url, result, notError, error)
	if not notError then
		logError(error)
	end
end
function inforeqMessageResponse(url, result, notError, error)
	if notError then
		if string.sub(result, 1, 2) == "ok" then
			-- print("message is valid")
			local message = string.upper(string.gsub(result, "^.+{", ""))
			message = string.gsub(message, "}.+$", "")
			message = string.gsub(message, "%.%.", "")
			-- for work in string.gmatch(message, "%d(%s)%d") do
			--     print(work)
			-- end
			-- print(url)
			local type = "weather"
			if string.match(url, "vatatis+") then
				type = "atis"
			end
			local facility = url:sub(-4, -1)
			addCommMessage(os.date("!%H%M"), type, "NE", message, facility, true)
		end
	else
		logError(error)
	end
end
local empty = false
commTime = ""
defineProperty("activeMessage", 0)
function draw()
	commTime = os.date("!%H%M") .. "Z"
	-- print(string.upper(string.gsub("ok {server info {GATWICK INFORMATION", "^.+{", "")))
	----------------------------------------------------------------------------------
	-- Mouse Handling
	----------------------------------------------------------------------------------
	-- CommMousePositionLeftX = MousePositionX
	-- CommMousePositionLeftY = MousePositionY
	-- CommPageLeftMouseIsClicked = MouseIsClickedWith
	--print(CommPageLeftMouseIsClicked .. MouseIsClickedWith)
	if CommMousePositionLeftX > 0 and CommMousePositionLeftY > 0 and CommMousePositionLeftX < 700 and CommMousePositionLeftY < 1050 then
		set(commLeftScratchpadKeyboard, 1)
	else
		set(commLeftScratchpadKeyboard, 0)
	end
	----------------------------------------------------------------------------------
	-- Common
	----------------------------------------------------------------------------------
	sasl.gl.drawRectangle(0, 0, 700, 1050, colourBlack) -- standard black background
	sasl.gl.drawText(fontRMbold, 10, 895, commTime, 25, false, false, TEXT_ALIGN_LEFT, colourWhite)
	----------------------------------------------------------------------------------
	-- Draw buttons at top (grey)
	----------------------------------------------------------------------------------
	sasl.gl.drawTexture(greyMXImage, 3, 989, 230, 55, colourWhite)
	sasl.gl.drawTexture(greyMXImage, 235, 989, 230, 55, colourWhite)
	sasl.gl.drawTexture(greyMXImage, 467, 989, 230, 55, colourWhite)

	sasl.gl.drawTexture(greyMXImage, 3, 930, 230, 55, colourWhite)
	sasl.gl.drawTexture(greyMXImage, 235, 930, 230, 55, colourWhite)
	sasl.gl.drawTexture(greyMXImage, 467, 930, 230, 55, colourWhite)
	local newMessages = 0
	for key, value in pairs(commMessageTable) do
		if (value.status == "" or (value.response ~= "NE" and value.response ~= "" and value.status == "DISPLAYED")) and value.uplink then
			newMessages = newMessages + 1
		end
	end
	----------------------------------------------------------------------------------
	-- draw the green (active) button
	----------------------------------------------------------------------------------
	local CurrentSystemDisplay = get(commHeaderId)
	if CurrentSystemDisplay > 0 then
		if CurrentSystemDisplay < 4 then
			sasl.gl.drawTexture(greenMXImage, commLocationActive[CurrentSystemDisplay], 989, 230, 55, colourWhite)
		else
			sasl.gl.drawTexture(greenMXImage, commLocationActive[CurrentSystemDisplay], 930, 230, 55, colourWhite)
		end
	end
	-- print(newMessages)
	----------------------------------------------------------------------------------
	-- Draw the text for the buttons (after the green one)
	----------------------------------------------------------------------------------
	sasl.gl.drawText(fontRMbold, 118, 1009, "ATC", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
	sasl.gl.drawText(fontRMbold, 353, 1020, "FLIGHT", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
	sasl.gl.drawText(fontRMbold, 353, 998, "INFORMATION", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
	sasl.gl.drawText(fontRMbold, 585, 1009, "COMPANY", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
	-- sasl.gl.drawText(fontRMbold, 585, 1009, "COMPANY", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)

	sasl.gl.drawText(fontRMbold, 118, 950, "REVIEW", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
	sasl.gl.drawText(fontRMbold, 353, 950, "MANAGER", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
	sasl.gl.drawText(fontRMbold, 585, 950, "NEW MESSAGES", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)

	if newMessages == 0 then
		sasl.gl.drawRectangle(467, 930, 230, 55, colourCyan)
		sasl.gl.drawRectangle(471, 934, 222, 47, colourBlack)
		sasl.gl.drawText(fontRMbold, 585, 950, "NEW MESSAGES", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
	end

	if get(acarsActiveDataref) == 0 then
		sasl.gl.drawRectangle(8, 989, 225, 55, colourCyan)
		sasl.gl.drawRectangle(12, 993, 217, 47, colourBlack)
		sasl.gl.drawRectangle(235, 989, 230, 55, colourCyan)
		sasl.gl.drawRectangle(239, 993, 222, 47, colourBlack)
		sasl.gl.drawText(fontRMbold, 118, 1009, "ATC", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)

		sasl.gl.drawText(fontRMbold, 353, 1020, "FLIGHT", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
		sasl.gl.drawText(fontRMbold, 353, 998, "INFORMATION", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
	end
	----------------------------------------------------------------------------------
	-- Mouse handling
	----------------------------------------------------------------------------------

	--print(CommMousePositionLeftX .. "," .. CommMousePositionLeftY .. "," .. MouseIsClickedWith)
	if CommMousePositionLeftX > 0 and CommMousePositionLeftY > 930 and CommMousePositionLeftX < 700 and CommMousePositionLeftY < 1050 then
		for key, value in pairs(commLocationActive) do
			local MinxPos = commLocationActive[key]
			local MinyPos = 0
			local MaxxPos = 0
			local MaxyPos = 0
			if key < 4 then
				MinyPos = 989
				MaxxPos = commLocationActive[key] + 230
				MaxyPos = 989 + 55
			else
				MinyPos = 930
				MaxxPos = commLocationActive[key] + 230
				MaxyPos = 930 + 55
			end

			if (CommMousePositionLeftX > MinxPos and CommMousePositionLeftX < MaxxPos) and (CommMousePositionLeftY > MinyPos and CommMousePositionLeftY < MaxyPos) then
				--sasl.gl.drawRectangle(MinxPos, MinyPos, MaxxPos - MinxPos, 55, colourPink)
				if key == 6 and newMessages == 0 then
					break
				end
				if get(acarsActiveDataref) == 1 or key > 2 then
					sasl.gl.drawWidePolyLine({MinxPos, MinyPos, MinxPos, MaxyPos, MaxxPos, MaxyPos, MaxxPos, MinyPos, MinxPos - 2, MinyPos}, 3, colourPink)
					--! disabled as not ready for use currently
					if CommPageLeftMouseIsClicked == 1 then
						if get(commPageId) == 78 and commMessageTable[get(activeMessage)].status == "" then
							commMessageTable[get(activeMessage)].status = "DISPLAYED"
						end
						set(commHeaderId, key)
						set(commPageId, commPageDefaultId[key])
						set(commReviewMessagesPage, 1)
						set(commManagerPage, 1)
					end
				end
			end
		end
	end

	sasl.gl.drawRectangle(0, 0, 700, 66, colourGrey)
	if get(commLeftScratchpadKeyboard) == 1 then
		sasl.gl.drawRectangle(131, 16, 438, 40, colourPink)
	else
		sasl.gl.drawRectangle(131, 16, 438, 40, colourWhite)
	end
	sasl.gl.drawRectangle(135, 20, 430, 32, colourBlack)
	sasl.gl.drawText(fontInconsolata, 149, 27, get(commLeftScratchpad), 26, false, false, TEXT_ALIGN_LEFT, colourWhite)
	-- if not commPagesThatArePossible[thingToDraw] then
	--     logError("The requested type of system display is invalid")
	--     return
	-- end
	if commPagesThatArePossible[get(commPageId)] == nil then -- doesn't exist,
		set(commPageId, 76)
	end
	drawAll(commPagesThatArePossible[get(commPageId)])

	-- if CommMousePositionLeftX > 160 and CommMousePositionLeftY > 10 and CommMousePositionLeftX < 640 and CommMousePositionLeftY < 200 and CommPageLeftMouseIsClicked == 1 then
	--     if thingToDraw > 1 then
	--         if get(commLeftScratchpadKeyboard) == 1 then
	--             set(commLeftScratchpadKeyboard, 0)
	--         else
	--             set(commLeftScratchpadKeyboard, 1)
	--         end
	--     end
	-- end
	local variable = ""
	-- drawTextEntry(168, 300, 23, false, variable, false, "FREE TEXT:")
	-- drawTextEntry(168, 250, 23, false, 12, false)
	-- drawTextEntry(168, 200, 23, false, 12, false)
	-- drawMenuEntry(168, 150, 10, 10, variable, {{"MENU ITEM 1", false}, {"MENU ITEM 2", false}, {"MENU ITEM 3", false}}, false, "THIS IS IT:")
	CommPageLeftMouseIsClicked = 0
end
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Pages
-- -----------------------------------------------------------------------------
-- 34 - LOGON/STATUS

-- -----------------------------------------------------------------------------
-- deal keyboard entry
-- -----------------------------------------------------------------------------
function onKeyDown(component, char, key)
	print(component)
	if get(commLeftScratchpadKeyboard) == 0 then
		return false
	end
	if char == 8 then -- backspace
		set(commLeftScratchpad, string.sub(get(commLeftScratchpad), 1, -2))
		return 1
	elseif char > 42 and char < 58 and char ~= 44 then -- number, /, +, -, .
		set(commLeftScratchpad, get(commLeftScratchpad) .. string.char(char))
		return 1
	elseif char > 65 and char < 91 then -- upper case
		set(commLeftScratchpad, get(commLeftScratchpad) .. string.char(char))
		return 1
	elseif char > 96 and char < 123 then
		set(commLeftScratchpad, get(commLeftScratchpad) .. string.upper(string.char(char)))
		return 1
	elseif key == 46 then -- delete
		if get(commLeftScratchpad) == "" then
			set(commLeftScratchpad, "DELETE")
		else
			set(commLeftScratchpad, "")
		end
		return 1
	end
end
function onMouseDown(component, x, y, button)
	local visible = acarsPopup:isVisible()
	local isPoppedOut = acarsPopup:isPoppedOut()
	if visible == true then
		CommMousePositionLeftX = x
		CommMousePositionLeftY = y
		CommPageLeftMouseIsClicked = 1
		print(x, y)
	end
end
function onMouseUp(component, x, y, button)
	CommPageLeftMouseIsClicked = 0
end
function onMouseMove(component, x, y)
	CommMousePositionLeftX = x
	CommMousePositionLeftY = y
	-- print(component)
	return 0
	-- cduAPageLeftMouseIsClicked = MouseIsClickedWith
end
function onMouseLeave()
	set(commLeftScratchpadKeyboard, 0)
	-- print("eys")
end

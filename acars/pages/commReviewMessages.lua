include "commDrawingFunctions.lua"
defineProperty("atisAirport", "")
network = require "network"

-- status
-- 0 = new (unread)
-- 1 = aborted
-- 2 = accepted
-- 3 = accepting
-- 4 = displayed
-- 5 = response recieved
-- 6 = rejected
-- 7 = rejecting
-- 8 = sending
-- 9 = sent
--
local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")
-- addCommMessage(1200, "telex", "NE", "HELLO STEVENS POINT", "LIV")
function draw()
    -- sasl.gl.drawText(fontRM, 350, 480, "ATC COMM", 50, false, false, TEXT_ALIGN_CENTER, colourWhite)
    -- -----------------------------------------------------------------------------
    -- Header
    -- -----------------------------------------------------------------------------
    local messageTable = {}
    local pageHeader = "ATC UPLINKS"
    local pageType = get(commReviewMessagesPage)
    if pageType == 2 then
        pageHeader = "FLIGHT INFO UPLINKS"
    elseif pageType == 3 then
        pageHeader = "SENT MESSAGES"
    elseif pageType == 4 then
        pageHeader = "ATC DOWNLINKS"
    elseif pageType == 5 then
        pageHeader = "FLIGHT INFO DOWNLINKS"
    elseif pageType == 6 then
        pageHeader = "RECIEVED"
    elseif pageType == 7 then
        pageHeader = "WEATHER"
    end
    -- print(pageType)
    for key, value in pairs(commMessageTable) do
        value.id = key
        if pageType == 1 then
            -- pageHeader = "ATC UPLINKS"
            if value.type == "cpdlc" and value.uplink then
                table.insert(messageTable, value)
            end
        elseif pageType == 2 then
            -- pageHeader = "FLIGHT INFO UPLINKS"
            if (value.type == "telex" or value.type == "atis") and value.uplink then
                table.insert(messageTable, value)
            end
        elseif pageType == 3 then
            -- pageHeader = "SENT MESSAGES"
            if not value.uplink then
                table.insert(messageTable, value)
            end
        elseif pageType == 4 then
            -- pageHeader = "ATC DOWNLINKS"
            if value.type == "cpdlc" and (not value.uplink) then
                table.insert(messageTable, value)
            end
        elseif pageType == 5 then
            -- pageHeader = "FLIGHT INFO DOWNLINKS"
            if (value.type == "telex" or value.type == "atis") and (not value.uplink) then
                table.insert(messageTable, value)
            end
        elseif pageType == 6 then
            -- pageHeader = "RECIEVED"
            if value.uplink then
                table.insert(messageTable, value)
            end
        elseif pageType == 7 then
            -- pageHeader = "WEATHER"
            if value.type == "weather" then
                table.insert(messageTable, value)
            end
        end
    end
    sasl.gl.drawText(fontRMbold, 350, 895, pageHeader, 25, false, false, TEXT_ALIGN_CENTER, colourWhite)
    sasl.gl.drawText(fontRMbold, 10, 895, commTime, 25, false, false, TEXT_ALIGN_LEFT, colourWhite)

    local rowNumber = 0
    for key, value in pairs(messageTable) do
        local y = 800 - (rowNumber * 75)
        local x = 25
        local xM = 25 + 650
        local yM = y + 70

        sasl.gl.drawRectangle(25, y, 650, 70, colourWhite)
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawRectangle(25, y, 650, 70, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                set(activeMessage, value.id)
                -- set(commReviewMessagesPage, 0)
                set(commPageId, 78)
            end
        end
        local message = network.wrap(value.message)
        sasl.gl.drawRectangle(29, y + 4, 642, 62, colourBlack)
        sasl.gl.drawText(fontInconsolata, 105, y + 40, value.time .. "Z", 25, false, false, TEXT_ALIGN_RIGHT, colourWhite)
        sasl.gl.drawText(fontInconsolata, 660, y + 40, value.facility, 25, false, false, TEXT_ALIGN_RIGHT, colourWhite)
        sasl.gl.drawText(fontInconsolata, 660, y + 15, value.status, 25, false, false, TEXT_ALIGN_RIGHT, colourWhite)
        sasl.gl.drawText(fontInconsolata, 130, y + 40, message[1], 25, false, false, TEXT_ALIGN_LEFT, colourWhite)
        if message[2] then
            sasl.gl.drawText(fontInconsolata, 130, y + 15, message[2], 25, false, false, TEXT_ALIGN_LEFT, colourWhite)
        end
        if message[3] then
            sasl.gl.drawText(fontInconsolata, 130, y + 15, message[2], 25, false, false, TEXT_ALIGN_LEFT, colourWhite)
        end
        rowNumber = rowNumber + 1
        if rowNumber == 9 then
            break
        end
    end
end

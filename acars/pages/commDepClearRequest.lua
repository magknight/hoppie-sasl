include "commDrawingFunctions.lua"
defineProperty("commAtcFacility", "")
defineProperty("commDepAirport", "")
defineProperty("commDesAirport", "")
defineProperty("commAtisLetter", "")
defineProperty("commGate", "")
network = require "network"
function sendDepClearanceRequest(flightNumber, atcFacility, dep, dest, gate, atis)
    local packet = "REQUEST PREDEP CLEARANCE%0D" .. flightNumber .. " B789 TO " .. dest .. "%0DAT " .. dep .. " STAND " .. gate .. "%0DATIS " .. atis

    network.getAsync({to = atcFacility, type = "telex", packet = packet}, clearanceCallback)
    addCommMessage(os.date("!%H%M"), "telex", "Y", packet, atcFacility, false)
    -- network.post(
    --     {
    --         from = flightNumber,
    --         to = atcFacility,
    --         type = "telex",
    --         packet = packet
    --     },

    -- )
end

local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")
function draw()
    -- -----------------------------------------------------------------------------
    -- Header
    -- -----------------------------------------------------------------------------
    sasl.gl.drawText(fontRMbold, 350, 895, "DEPARTURE CLEARANCE REQUEST", 25, false, false, TEXT_ALIGN_CENTER, colourWhite)

    -- -----------------------------------------------------------------------------
    -- Selection boxes
    -- -----------------------------------------------------------------------------
    drawAlignedText(350, 815, get(flightNumber), "FLT NUMBER:", false)
    local pageIsComplete = {
        drawTextEntry(350, 765, 4, true, commAtcFacility, false, "ATC FACILITY:", "^%u%u%u+$"),
        drawTextEntry(350, 680, 4, true, commDepAirport, false, "DEPARTURE:", "^%u%u%u%u$"),
        drawTextEntry(350, 630, 4, true, commDesAirport, false, "DESTINATION:", "^%u%u%u%u$"),
        drawTextEntry(350, 580, 5, true, commGate, false, "GATE:", "^%w+$"),
        drawTextEntry(350, 530, 1, true, commAtisLetter, false, "ATIS:", "^%u$")
    }
    local sum = 0
    for key, value in pairs(pageIsComplete) do
        sum = sum + value
    end
    local atcCommLowerOptions = {
        {line1 = "SEND", functionId = 0, inactive = true, x = 1}, -- 2 - send
        {line1 = "RESET", functionId = 2, inactive = false, x = 5}, -- 5 - reset current page
        {line1 = "EXIT", functionId = 1, inactive = false, x = 6} -- 0 - exit and clear
    }
    if sum == 5 then
        atcCommLowerOptions[1].inactive = false
    end
    -- if CommMousePositionLeftX < 890 and CommMousePositionLeftY > 0 and CommMousePositionLeftX < 700 and CommMousePositionLeftY < 1050 then
    for key, value in pairs(atcCommLowerOptions) do
        local MinxPos = ((value.x - 1) * 115) + 7
        local MinyPos = 70
        local MaxxPos = 0
        local MaxyPos = 80 + 55
        MaxxPos = MinxPos + 110
        if value.inactive then
            sasl.gl.drawWidePolyLine({MinxPos + 1, MinyPos + 1, MinxPos + 1, MaxyPos - 1, MaxxPos - 1, MaxyPos - 1, MaxxPos - 1, MinyPos + 1, MinxPos - 2, MinyPos + 1}, 5, colourCyan)
            if value.line2Active then
                sasl.gl.drawText(fontRMbold, MinxPos + 55, MinyPos + 38, value.line1, 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
                sasl.gl.drawText(fontRMbold, MinxPos + 55, MinyPos + 13, value.line2, 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
            else
                sasl.gl.drawText(fontRMbold, MinxPos + 55, MinyPos + 24, value.line1, 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
            end
        else
            sasl.gl.drawTexture(greyMXImage, MinxPos, MinyPos, 110, 65, colourWhite)
            if value.line2Active then
                sasl.gl.drawText(fontRMbold, MinxPos + 55, MinyPos + 38, value.line1, 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
                sasl.gl.drawText(fontRMbold, MinxPos + 55, MinyPos + 13, value.line2, 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
            else
                sasl.gl.drawText(fontRMbold, MinxPos + 55, MinyPos + 24, value.line1, 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
            end

            if (CommMousePositionLeftX > MinxPos and CommMousePositionLeftX < MaxxPos) and (CommMousePositionLeftY > MinyPos and CommMousePositionLeftY < MaxyPos) then
                --sasl.gl.drawRectangle(MinxPos, MinyPos, MaxxPos - MinxPos, 55, colourPink)
                sasl.gl.drawWidePolyLine({MinxPos, MinyPos, MinxPos, MaxyPos, MaxxPos, MaxyPos, MaxxPos, MinyPos, MinxPos - 2, MinyPos}, 3, colourPink)
                if CommPageLeftMouseIsClicked == 1 then
                    if value.functionId == 0 then
                        sendDepClearanceRequest(get(flightNumber), get(commAtcFacility), get(commDepAirport), get(commDesAirport), get(commGate), get(commAtisLetter))
                        set(commPageId, 76)
                    elseif value.functionId == 1 then -- RETURN
                        set(commPageId, 42)
                    elseif value.functionId == 2 then -- RESET
                        set(commAtcFacility, "")
                        set(commDepAirport, "")
                        set(commDesAirport, "")
                        set(commAtisLetter, "")
                        set(commGate, "")
                    end
                end
            end
        end
    end
end

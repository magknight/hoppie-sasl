include "commDrawingFunctions.lua"
defineProperty("weatherAirport", "")
network = require "network"
function sendAtisRequest(airport)
    if airport == "" then -- invalid
        return
    end
    addCommMessage(os.date("!%H%M"), "atis", "Y", "REQ ATIS " .. airport, airport, false)
    network.getAsync({type = "infoReq", packet = "vatatis " .. airport}, inforeqMessageResponse)
end
function sendMetarRequest(airport)
    if airport == "" then -- invalid
        return
    end
    addCommMessage(os.date("!%H%M"), "weather", "Y", "REQ METAR " .. airport, airport, false)
    network.getAsync({type = "infoReq", packet = "metar " .. airport}, inforeqMessageResponse)
end
function sendTafRequest(airport)
    if airport == "" then -- invalid
        return
    end
    addCommMessage(os.date("!%H%M"), "weather", "Y", "REQ TAF " .. airport, airport, false)
    network.getAsync({type = "infoReq", packet = "taf " .. airport}, inforeqMessageResponse)
end

local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")
function draw()
    -- -----------------------------------------------------------------------------
    -- Header
    -- -----------------------------------------------------------------------------
    page = "ATIS REQUEST"
    if get(commPageId) == 48 then
        page = "METAR REQUEST"
    elseif get(commPageId) == 49 then
        page = "TAF REQUEST"
    end

    sasl.gl.drawText(fontRMbold, 350, 895, page, 25, false, false, TEXT_ALIGN_CENTER, colourWhite)

    -- -----------------------------------------------------------------------------
    -- Selection boxes
    -- -----------------------------------------------------------------------------
    local atcCommLowerOptions = {
        {line1 = "SEND", functionId = 0, inactive = false, x = 1}, -- 2 - send
        {line1 = "RESET", functionId = 2, inactive = false, x = 5}, -- 5 - reset current page
        {line1 = "EXIT", functionId = 1, inactive = false, x = 6} -- 0 - exit and clear
    }

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
                        if get(commPageId) == 48 then
                            sendMetarRequest(get(weatherAirport))
                        elseif get(commPageId) == 49 then
                            sendTafRequest(get(weatherAirport))
                        else
                            sendAtisRequest(get(weatherAirport))
                        end
                        set(commPageId, 76)
                    elseif value.functionId == 1 then -- RETURN
                        set(commPageId, 42)
                    elseif value.functionId == 2 then -- RESET
                        set(weatherAirport, "")
                    end
                end
            end
        end
    end
    drawTextEntry(350, 835, 4, false, weatherAirport, false, "AIRPORT:")
end

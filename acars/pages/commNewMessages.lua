include "commDrawingFunctions.lua"
defineProperty("atisAirport", "")
network = require "network"

local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")
-- addCommMessage(1200, "telex", "NE", "HELLO STEVENS POINT", "LIV", false)
function draw()
    -- sasl.gl.drawText(fontRM, 350, 480, "ATC COMM", 50, false, false, TEXT_ALIGN_CENTER, colourWhite)
    -- -----------------------------------------------------------------------------
    -- Header
    -- -----------------------------------------------------------------------------
    sasl.gl.drawText(fontRMbold, 350, 895, "NEW MESSSAGES", 25, false, false, TEXT_ALIGN_CENTER, colourWhite)

    -- -----------------------------------------------------------------------------
    -- Selection boxes
    -- -----------------------------------------------------------------------------
    local atcCommLowerOptions = {
        {line1 = "EXIT", line2 = "MENU", line2Active = true, pageId = 0, inactive = false, x = 6} -- 0 - exit and clear
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
                        -- sendAtisRequest(get(atisAirport))
                        --! just skedaddle
                        set(commPageId, 0)
                    elseif value.functionId == 1 then -- RETURN
                        --! save data entered
                        set(commPageId, 0)
                    elseif value.functionId == 2 then --
                        --! save and send data entered
                        set(commPageId, 0)
                    end
                end
            end
        end
    end
    local rowNumber = 0
    for key, value in pairs(commMessageTable) do
        -- print(value.type ~= "NE" and value.type ~= "" and value.status == "DISPLAYED", value.type)

        if (value.status == "" or (value.response ~= "NE" and value.response ~= "" and value.status == "DISPLAYED")) and value.uplink then -- new message
            local y = 800 - (rowNumber * 75)
            local x = 25
            local xM = 25 + 650
            local yM = y + 70

            sasl.gl.drawRectangle(25, y, 650, 70, colourWhite)
            if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
                sasl.gl.drawRectangle(25, y, 650, 70, colourPink)
                if CommPageLeftMouseIsClicked == 1 then
                    set(activeMessage, key)
                    set(commReviewMessagesPage, 0)
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
    if rowNumber == 0 then
        sasl.gl.drawText(fontRMbold, 350, 805, "NO MESSAGES", 25, false, false, TEXT_ALIGN_CENTER, colourWhite)
    end
end

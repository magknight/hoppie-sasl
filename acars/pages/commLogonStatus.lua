include "commDrawingFunctions.lua"
defineProperty("acarsRemote", "")
defineProperty("acarsFlightNumber", "")
defineProperty("acarsFiledDepTime", "")
defineProperty("acarsFiledDepDate", "")
function draw()
    local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
    local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")

    -- sasl.gl.drawText(fontRM, 350, 480, "ATC COMM", 50, false, false, TEXT_ALIGN_CENTER, colourWhite)
    -- -----------------------------------------------------------------------------
    -- Header
    -- -----------------------------------------------------------------------------
    sasl.gl.drawText(fontRMbold, 350, 895, "LOGON/STATUS", 25, false, false, TEXT_ALIGN_CENTER, colourWhite)

    -- -----------------------------------------------------------------------------
    -- Selection boxes
    -- -----------------------------------------------------------------------------
    local atcCommLowerOptions = {
        {line1 = "SEND", functionId = 2, inactive = false, x = 1}, -- 2 - send
        {line1 = "ADS", line2 = "MANAGER", line2Active = true, functionId = 9, inactive = true, x = 3}, -- 6 - ADS manager page
        {line1 = "RETURN", functionId = 1, inactive = false, x = 5}, -- 1 - return and save
        {line1 = "EXIT", functionId = 0, inactive = false, x = 6} -- 0 - exit and clear
        -- {line1 = "SEND", functionId = 2, inactive = false, x = 1}, -- 2 - send
        -- {line1 = "PRINT", functionId = 6, inactive = true, x = 3}, -- 6 - print
        -- {line1 = "RESET", functionId = 5, inactive = false, x = 4}, -- 5 - reset current page
        -- {line1 = "RETURN", pageId = 1, inactive = false, x = 5}, -- 1 - return and save
        -- {line1 = "EXIT", pageId = 0, inactive = false, x = 6} -- 0 - exit and clear
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
    local variable = ""
    drawTextEntry(350, 835, 4, false, acarsRemote, false, "LOGON TO:")
    drawTextEntry(350, 755, 7, false, acarsFlightNumber, false, "FLIGHT NUMBER:")
    drawTextEntry(350, 705, 4, false, acarsFiledDepTime, false, "FILED DEPARTURE TIME:", "%d%d%d%d")
    drawTextEntry(350, 655, 9, false, acarsFiledDepDate, false, "FILED DEPARTURE DATE:", "%d%d%-%u%u%u%-%d%d", "--:--:--")
    drawAlignedText(230, 605, "KLAX", "ORIGIN:", false)
    drawAlignedText(530, 605, "EGKK", "DESTINATION:", false)
    drawAlignedText(350, 545, "ESTABILISHED", "ATC CONNECTION:", false)
    drawAlignedText(350, 495, "KZAK", "ACTIVE CENTER:", false)
    drawAlignedText(350, 445, "EGTT", "NEXT CENTER:", false)
    drawAlignedText(350, 395, "3 SEC", "MAX UPLINK DELAY:", false)
    drawAlignedText(350, 345, "ACTIVE", "ADS STATUS:", false)
end

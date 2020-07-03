local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")
function draw()
    -- -----------------------------------------------------------------------------
    -- Header
    -- -----------------------------------------------------------------------------
    sasl.gl.drawText(fontRMbold, 350, 895, "ATC", 25, false, false, TEXT_ALIGN_CENTER, colourWhite)

    -- -----------------------------------------------------------------------------
    -- Selection boxes
    -- -----------------------------------------------------------------------------
    local atcCommOptions = {
        {line1 = "ALTITUDE", line2 = "REQUEST", line2Active = true, pageId = 20, inactive = true},
        {line1 = "WHEN CAN WE", line2 = "EXPECT...", line2Active = true, pageId = 20, inactive = true},
        {line1 = "EMERGENCY", line2 = "REPORT", line2Active = true, pageId = 20, inactive = true},
        {line1 = "ROUTE", line2 = "REQUEST", line2Active = true, pageId = 20, inactive = true},
        {line1 = "VOICE CONTACT", line2 = "REQUEST", line2Active = true, pageId = 20, inactive = true},
        {line1 = "REQUESTED", line2 = "REPORTS", line2Active = true, pageId = 20, inactive = true},
        {line1 = "SPEED", line2 = "REQUEST", line2Active = true, pageId = 20, inactive = true},
        {line1 = "FREE TEXT", line2 = "MESSAGE", line2Active = true, pageId = 20, inactive = true},
        {line1 = "CONDITIONAL", line2 = "CLEARANCES", line2Active = true, pageId = 20, inactive = true},
        {line1 = "CLEARANCE", line2 = "REQUEST", line2Active = true, pageId = 20, inactive = true},
        {line1 = "LOGON/STATUS", line2 = "", line2Active = false, pageId = 1, inactive = true},
        {line1 = "POSITION", line2 = "REPORT", line2Active = true, pageId = 20, inactive = true}
    }

    -- if CommMousePositionLeftX < 890 and CommMousePositionLeftY > 0 and CommMousePositionLeftX < 700 and CommMousePositionLeftY < 1050 then
    for key, value in pairs(atcCommOptions) do
        local MinxPos = commLocationActive[key]
        local MinyPos = 0
        local MaxxPos = 0
        local MaxyPos = 0
        local line = math.floor(key / 3.001) -- nearly but not quite 3 to ensure it splits onto a new line appropriately
        MinyPos = 810 - (line * 72)
        MaxyPos = MinyPos + 65
        if key - (line * 3) == 1 then
            MinxPos = 7
        elseif key - (line * 3) == 2 then
            MinxPos = 240
        else
            MinxPos = 473
        end
        MaxxPos = MinxPos + 220
        if value.inactive then
            sasl.gl.drawWidePolyLine({MinxPos + 1, MinyPos + 1, MinxPos + 1, MaxyPos - 1, MaxxPos - 1, MaxyPos - 1, MaxxPos - 1, MinyPos + 1, MinxPos - 2, MinyPos + 1}, 5, colourCyan)
            if value.line2Active then
                sasl.gl.drawText(fontRMbold, MinxPos + 15, MinyPos + 38, value.line1, 22, false, false, TEXT_ALIGN_LEFT, colourCyan)
                sasl.gl.drawText(fontRMbold, MinxPos + 15, MinyPos + 13, value.line2, 22, false, false, TEXT_ALIGN_LEFT, colourCyan)
            else
                sasl.gl.drawText(fontRMbold, MinxPos + 110, MinyPos + 24, value.line1, 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
            end
        else
            sasl.gl.drawTexture(greyMXImage, MinxPos, MinyPos, 220, 65, colourWhite)
            if value.line2Active then
                sasl.gl.drawText(fontRMbold, MinxPos + 15, MinyPos + 38, value.line1, 22, false, false, TEXT_ALIGN_LEFT, colourWhite)
                sasl.gl.drawText(fontRMbold, MinxPos + 15, MinyPos + 13, value.line2, 22, false, false, TEXT_ALIGN_LEFT, colourWhite)
            else
                sasl.gl.drawText(fontRMbold, MinxPos + 110, MinyPos + 24, value.line1, 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
            end

            if (CommMousePositionLeftX > MinxPos and CommMousePositionLeftX < MaxxPos) and (CommMousePositionLeftY > MinyPos and CommMousePositionLeftY < MaxyPos) then
                --sasl.gl.drawRectangle(MinxPos, MinyPos, MaxxPos - MinxPos, 55, colourPink)
                sasl.gl.drawWidePolyLine({MinxPos, MinyPos, MinxPos, MaxyPos, MaxxPos, MaxyPos, MaxxPos, MinyPos, MinxPos - 2, MinyPos}, 3, colourPink)
                if CommPageLeftMouseIsClicked == 1 then
                    set(commPageId, value.pageId)
                end
            end
        end
    end
end

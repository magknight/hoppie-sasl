local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")
defineProperty("numberNE")
function draw()
    if get(commManagerPage) == 1 then -- menu page
        -- wideClickBox(16, 775, true, "GPWS CALLOUTS", 2)
        -- wideClickBox(352, 775, true, "ACARS", 2)
        -- wideClickBox(352, 825, true, "ACARS", 2)
        -- wideClickBox(10, 825, true, "ACARS", 1)
        -- -----------------------------------------------------------------------------
        -- Header
        -- -----------------------------------------------------------------------------
        sasl.gl.drawText(fontRMbold, 350, 895, "MANAGER", 25, false, false, TEXT_ALIGN_CENTER, colourWhite)

        -- -----------------------------------------------------------------------------
        -- Selection boxes
        -- -----------------------------------------------------------------------------
        wideClickBox(16, 825, true, "ACARS", 2)
        -- wideClickBox(352, 825, true, "AIRPLANE CONFIG DATA", 3)
        wideClickBox(16, 775, true, "ADS", 4)
    elseif get(commManagerPage) == 2 then -- acars page
        sasl.gl.drawText(fontRMbold, 350, 895, "ACARS", 25, false, false, TEXT_ALIGN_CENTER, colourWhite)
        drawTextEntry(300, 815, 7, false, flightNumber, false, "CALLSIGN:")
        drawAlignedText(300, 765, "HOPPIE", "REMOTE SERVER:", false)
        drawTextEntry(300, 715, 15, false, acarsLogonCodeDataref, false, "LOGON CODE:")
        pasteButton(575, 715, true, acarsLogonCodeDataref, "^%w%w%w%w%w%w%w%w%w%w+$")
        saveButton(
            6,
            true,
            {
                {"callsignDataref", get(callsignDataref), 2},
                {"acarsLogonCodeDataref", get(acarsLogonCodeDataref), 2},
                {"acarsEnabledDataref", get(acarsEnabledDataref), 2}
            }
        )
        drawNonExclusiveButton(250, 670, acarsEnabledDataref, false, "ACARS ENABLED")
    elseif get(commManagerPage) == 4 then -- ADS page
        sasl.gl.drawText(fontRMbold, 350, 895, "ADS", 25, false, false, TEXT_ALIGN_CENTER, colourWhite)
        drawExclusiveButtonSet(
            {
                {x = 50, y = 830, isBlue = false, label = "ADS ARM", value = 1},
                {x = 370, y = 830, isBlue = false, label = "ADS OFF", value = 0}
            },
            numberNE
        )
        drawExclusiveButtonSet(
            {
                {x = 50, y = 780, isBlue = true, label = "ADS EMERGENCY", value = 1},
                {x = 370, y = 780, isBlue = false, label = "ADS EMERGENCY OFF", value = 0}
            },
            0
        )
    end
end

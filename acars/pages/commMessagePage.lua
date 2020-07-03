include "commDrawingFunctions.lua"
local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")
function draw()
    -- -----------------------------------------------------------------------------
    -- Header
    -- -----------------------------------------------------------------------------
    sasl.gl.drawText(fontRMbold, 350, 895, "MESSAGE", 25, false, false, TEXT_ALIGN_CENTER, colourWhite)

    -- -----------------------------------------------------------------------------
    -- Selection boxes
    -- -----------------------------------------------------------------------------
    local messageOfInterest = commMessageTable[get(activeMessage)]
    -- print(messageOfInterest.response)
    -- print(messageOfInterest.response)
    if messageOfInterest.response == "WU" or messageOfInterest.response == "AN" then
        acceptButton(1, true, get(activeMessage))
        standbyButton(4, false, get(activeMessage))
        rejectReasonsButton(5, false, get(activeMessage))
        rejectButton(6, true, get(activeMessage))
    elseif messageOfInterest.response == "NE" or messageOfInterest.response == "" or messageOfInterest.uplink == false then
        local page = 58
        if get(commReviewMessagesPage) == 0 then
            page = 76
        end
        cancelButton(6, true, get(activeMessage), page)
    elseif messageOfInterest.response == "R" then
        acceptButton(1, true, get(activeMessage))
        rejectButton(5, true, get(activeMessage))
        local page = 58
        if get(commReviewMessagesPage) == 0 then
            page = 76
        end
        cancelButton(6, true, get(activeMessage), page)
    end
    if messageOfInterest.status ~= commPageSendText and commPageSendText ~= "" then
        messageOfInterest.status = commPageSendText
    end

    sasl.gl.drawText(fontRMbold, 670, 895, messageOfInterest.status, 25, false, false, TEXT_ALIGN_RIGHT, colourWhite)
    local facilityText = "FROM "
    if not messageOfInterest.uplink then
        facilityText = "TO "
    end
    sasl.gl.drawText(fontRMbold, 670, 870, facilityText .. messageOfInterest.facility, 25, false, false, TEXT_ALIGN_RIGHT, colourWhite)
    for key, value in pairs(network.wrap(messageOfInterest.message)) do
        local y = 780 - ((key - 1) * 25)
        local x = 25
        sasl.gl.drawText(fontInconsolata, 100, y + 15, value, 25, false, false, TEXT_ALIGN_LEFT, colourWhite)
    end
end

local greyMXImage = loadImage("globalAssets/textures/standardButton.png")
local greenMXImage = loadImage("globalAssets/textures/standardButtonGreen.png")
local nonExclusiveButtonClickedImage = loadImage("globalAssets/textures/nonExclusiveButtonClicked.png")
local nonExclusiveButtonImage = loadImage("globalAssets/textures/nonExclusiveButton.png")
local leftSideImage = loadImage("globalAssets/textures/leftEntryBox.png")
local rightSideImage = loadImage("globalAssets/textures/rightEntryBox.png")
local centralImage = loadImage("globalAssets/textures/entryBox.png")
local wideButtonImage = loadImage("globalAssets/textures/wideButton.png")
local exclusiveButtonImage = loadImage("globalAssets/textures/exclusiveButton.png")
local exclusiveButtonBlueImage = loadImage("globalAssets/textures/exclusiveButtonBlue.png")
local exclusiveButtonClickedImage = loadImage("globalAssets/textures/exclusiveButtonClicked.png")
local network = require "network"
include "acarsHandlers.lua"
-- -----------------------------------------------------------------------------
-- Text entry function (good)
-- -----------------------------------------------------------------------------
function drawTextEntry(x, y, length, isRequired, variable, isBlue, label, formatRegex, defaultFormat)
    local textColour = colourWhite
    if isBlue then
        textColour = colourCyan
    end
    local character = "-"
    local font = fontInconsolata

    if label then
        sasl.gl.drawText(fontInconsolata, x - 18, y + 13, label, 25, false, false, TEXT_ALIGN_RIGHT, colourWhite)
    end
    local width = (length * 13) + 42
    sasl.gl.drawTexture(leftSideImage, x, y, 9, 45, colourWhite)
    sasl.gl.drawTexture(rightSideImage, x + width + 9, y, 9, 45, colourWhite)
    sasl.gl.drawTexture(centralImage, x + 9, y, width, 45, colourWhite)
    local textToDraw = get(variable)
    if textToDraw == "" then -- if field is empty, show the empty string
        if isRequired then
            character = "▯"
            -- font = fontLato
            font = fontShare
        end
        textToDraw = string.rep(character, length)
    end
    sasl.gl.drawText(font, x + 30, y + 13, defaultFormat or textToDraw, 25, false, false, TEXT_ALIGN_LEFT, colourWhite)
    -- highlight

    if not isBlue then
        local xM = x + width + 18
        local yM = y + 45
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x, y + 1}, 2, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                local scratchpad = get(commLeftScratchpad)
                if scratchpad == "" then --
                elseif scratchpad:len() <= length then -- valid entry by length
                    if (formatRegex ~= nil and string.match(scratchpad, formatRegex) ~= nil) or formatRegex == nil then
                        set(variable, scratchpad)
                        set(commLeftScratchpad, "")
                    else
                        set(commLeftScratchpad, "FORMAT ERROR")
                    end
                else
                    set(commLeftScratchpad, "FORMAT ERROR")
                end
            end
        end
    end
    if isRequired then
        if get(variable) ~= "" then
            return 1
        else
            return 0
        end
    else
        return 1
    end
end
-- -----------------------------------------------------------------------------
-- aligned text to these fields, nothing exciting
-- -----------------------------------------------------------------------------
function drawAlignedText(x, y, variable, label, isBlue)
    local textColour = colourWhite
    if isBlue then
        textColour = colourCyan
    end
    if label then
        sasl.gl.drawText(fontInconsolata, x - 18, y + 13, label, 25, false, false, TEXT_ALIGN_RIGHT, colourWhite)
    end
    sasl.gl.drawText(fontInconsolata, x + 30, y + 13, variable, 25, false, false, TEXT_ALIGN_LEFT, colourWhite)
end
-- H:\Git-active\Future\plugins\SASL\data\modules\globalAssets\textures
-- -----------------------------------------------------------------------------
-- Menu function (not great)
-- -----------------------------------------------------------------------------
function drawMenuEntry(page, id, x, y, length, dropdownLength, variable, dropdownItems, isBlue, label)
    local textColour = colourWhite
    if isBlue then
        textColour = colourCyan
    end
    if label then
        sasl.gl.drawText(fontInconsolata, x - 18, y + 13, label, 25, false, false, TEXT_ALIGN_RIGHT, colourWhite)
    end
    local width = (length * 13) + 42
    local dropdownWidth = (dropdownLength * 13) + 10
    sasl.gl.drawTexture(leftSideImage, x, y, 9, 30, colourWhite)
    sasl.gl.drawTexture(rightSideImage, x + width + 9, y, 9, 30, colourWhite)
    sasl.gl.drawTexture(centralImage, x + 9, y, width, 30, colourWhite)
    local textToDraw = "MENU ITEM 1"
    sasl.gl.drawText(fontInconsolata, x + 30, y + 13, textToDraw, 19, false, false, TEXT_ALIGN_LEFT, colourWhite)
    for index, value in ipairs(dropdownItems) do
        local dropdownx = x + width + 20
        local dropdowny = y - ((index - 1) * 32)
        sasl.gl.drawTexture(leftSideImage, dropdownx, dropdowny, 9, 30, colourWhite)
        sasl.gl.drawTexture(rightSideImage, dropdownx + dropdownWidth + 9, dropdowny, 9, 30, colourWhite)
        sasl.gl.drawTexture(centralImage, dropdownx + 9, dropdowny, dropdownWidth, 30, colourWhite)
        local textToDraw = "----------"
        sasl.gl.drawText(fontInconsolata, dropdownx + 12, dropdowny + 8, value[1], 19, false, false, TEXT_ALIGN_LEFT, colourWhite)
    end
end

function cancelButton(x, isActive, activeMessage, pageToReturnTo)
    x = ((x - 1) * 115) + 7
    local xM = x + 110
    local y = 70
    local yM = 80 + 55
    if isActive then
        sasl.gl.drawTexture(greyMXImage, x, y, 110, 65, colourWhite)
        sasl.gl.drawText(fontRMbold, x + 55, y + 24, "CANCEL", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x, y, x, yM, xM, yM, xM, y, x - 2, y}, 3, colourPink)

            if CommPageLeftMouseIsClicked == 1 then
                if get(activeMessage) == commPfdMessageId then
                    sasl.commandOnce(mcpCancelCpdlc)
                end
                if commMessageTable[get(activeMessage)].status == "" then
                    commMessageTable[get(activeMessage)].status = "DISPLAYED"
                end
                set(commPageId, pageToReturnTo)
            end
        end
    else
        sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x - 2, y + 1}, 5, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 24, "CANCEL", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
    end
end

function acceptButton(x, isActive, activeMessage)
    x = ((x - 1) * 115) + 7
    local xM = x + 110
    local y = 70
    local yM = 80 + 55
    if commPageSendText ~= "ACCEPTING" and commPageSendText ~= "ACCEPTED" and commPageSendText ~= "DISPLAYED" and commPageSendText ~= "" then
        isActive = false
    end
    if isActive then
        if commPageSendText ~= "ACCEPTING" and commPageSendText ~= "ACCEPTED" then
            sasl.gl.drawTexture(greyMXImage, x, y, 110, 65, colourWhite)
            sasl.gl.drawText(fontRMbold, x + 55, y + 24, "ACCEPT", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
        else
            sasl.gl.drawText(fontRMbold, x + 55, y + 24, commPageSendText, 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
            return
        end
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x, y, x, yM, xM, yM, xM, y, x - 2, y}, 3, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                -- set(commPageId, pageToReturnTo)
                -- print("ACCEPT")
                if commPageSendText ~= "ACCEPTING" and commPageSendText ~= "ACCEPTED" then
                    acceptMessage(activeMessage, false)
                end
            end
        end
    else
        sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x - 2, y + 1}, 5, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 24, "ACCEPT", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
    end
end
function standbyButton(x, isActive, activeMessage)
    x = ((x - 1) * 115) + 7
    local xM = x + 110
    local y = 70
    local yM = 80 + 55
    if isActive then
        if commPageSendText ~= "REJECTING" and commPageSendText ~= "REJECTED" then
            sasl.gl.drawTexture(greyMXImage, x, y, 110, 65, colourWhite)
            sasl.gl.drawText(fontRMbold, x + 55, y + 24, "STANDBY", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
        else
            sasl.gl.drawText(fontRMbold, x + 55, y + 24, commPageSendText, 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
            return
        end

        sasl.gl.drawTexture(greyMXImage, x, y, 110, 65, colourWhite)
        sasl.gl.drawText(fontRMbold, x + 55, y + 24, "STANDBY", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x, y, x, yM, xM, yM, xM, y, x - 2, y}, 3, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                -- set(commPageId, pageToReturnTo)
                print("STANDBY")
            end
        end
    else
        sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x - 2, y + 1}, 5, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 24, "STANDBY", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
    end
end

function rejectButton(x, isActive, activeMessage)
    x = ((x - 1) * 115) + 7
    local xM = x + 110
    local y = 70
    local yM = 80 + 55
    if commPageSendText ~= "REJECTING" and commPageSendText ~= "REJECTED" and commPageSendText ~= "DISPLAYED" and commPageSendText ~= "" then
        isActive = false
    end
    if isActive then
        if commPageSendText ~= "REJECTING" and commPageSendText ~= "REJECTED" then
            sasl.gl.drawTexture(greyMXImage, x, y, 110, 65, colourWhite)
            sasl.gl.drawText(fontRMbold, x + 55, y + 24, "REJECT", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
        else
            sasl.gl.drawText(fontRMbold, x + 55, y + 24, commPageSendText, 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
            return
        end
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x, y, x, yM, xM, yM, xM, y, x - 2, y}, 3, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                if commPageSendText ~= "REJECTING" and commPageSendText ~= "REJECTED" then
                    rejectMessage(activeMessage, false)
                end
            end
        end
    else
        sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x - 2, y + 1}, 5, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 24, "REJECT", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
    end
end
function rejectReasonsButton(x, isActive, activeMessage)
    x = ((x - 1) * 115) + 7
    local xM = x + 110
    local y = 70
    local yM = 80 + 55
    if isActive then
        sasl.gl.drawTexture(greyMXImage, x, y, 110, 65, colourWhite)
        sasl.gl.drawText(fontRMbold, x + 55, y + 38, "REJECT", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
        sasl.gl.drawText(fontRMbold, x + 55, y + 13, "REASONS", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x, y, x, yM, xM, yM, xM, y, x - 2, y}, 3, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                -- set(commPageId, pageToReturnTo)
                print("REJECT REASONS")
            end
        end
    else
        sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x - 2, y + 1}, 5, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 38, "REJECT", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 13, "REASONS", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
    end
end

-- 6 8  694
function wideClickBox(x, y, isActive, text, managerPageId)
    local xM = x + 332
    local yM = y + 47
    if isActive then
        sasl.gl.drawTexture(wideButtonImage, x, y, 332, 47, colourWhite)
        sasl.gl.drawText(fontRMbold, x + 20, y + 16, text, 22, false, false, TEXT_ALIGN_LEFT, colourWhite)
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x, y, x, yM, xM, yM, xM, y, x - 2, y}, 3, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                set(commManagerPage, managerPageId)
            -- print("REJECT REASONS")
            end
        end
    else
        sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x - 2, y + 1}, 5, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 38, "REJECT", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 13, "REASONS", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
    end
end
function pasteButton(x, y, isActive, variable, regex)
    local xM = x + 110
    local yM = y + 45
    if isActive then
        sasl.gl.drawTexture(greyMXImage, x, y, 110, 45, colourWhite)
        sasl.gl.drawText(fontRMbold, x + 55, y + 14, "PASTE", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x, y, x, yM, xM, yM, xM, y, x - 2, y}, 3, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                local clipboard = sasl.getClipboardText()
                if clipboard ~= "" and clipboard ~= nil then
                    if clipboard:match(regex) then
                        set(variable, clipboard)
                    end
                end
            end
        end
    else
        sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x - 2, y + 1}, 5, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 14, "PASTE", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
    end
end
function saveButton(x, isActive, settingsToSave)
    x = ((x - 1) * 115) + 7
    local xM = x + 110
    local y = 70
    local yM = 80 + 55
    if isActive then
        sasl.gl.drawTexture(greyMXImage, x, y, 110, 65, colourWhite)
        sasl.gl.drawText(fontRMbold, x + 55, y + 24, "SAVE", 22, false, false, TEXT_ALIGN_CENTER, colourWhite)
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x, y, x, yM, xM, yM, xM, y, x - 2, y}, 3, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                for key, value in pairs(settingsToSave) do
                    changeSettingValue(value[1], value[2], value[3])
                end
            end
        end
    else
        sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x - 2, y + 1}, 5, colourCyan)
        sasl.gl.drawText(fontRMbold, x + 55, y + 24, "SAVE", 22, false, false, TEXT_ALIGN_CENTER, colourCyan)
    end
end
local nonExclusiveButtonClickedImage = loadImage("globalAssets/textures/nonExclusiveButtonClicked.png")
local nonExclusiveButtonImage = loadImage("globalAssets/textures/nonExclusiveButton.png")
function drawNonExclusiveButton(x, y, variable, isBlue, label)
    local textColour = colourWhite
    if isBlue then
        textColour = colourCyan
    end
    if label then
        sasl.gl.drawText(fontInconsolata, x + 32 + 20, y + 10, label, 25, false, false, TEXT_ALIGN_LEFT, textColour)
    end
    if isBlue then
        sasl.gl.drawRectangle(x - 2, y - 2, 36, 36, colourBlack)
        sasl.gl.drawRectangle(x + 1, y + 1, 30, 30, colourBlack)
    else
        sasl.gl.drawTexture(nonExclusiveButtonImage, x, y, 32, 32, colourWhite)
        if get(variable) == 1 then
            sasl.gl.drawTexture(nonExclusiveButtonClickedImage, x, y, 32, 32, colourWhite)
        end
    end

    if not isBlue then
        local xM = x + 32
        local yM = y + 32
        if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
            sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x, y + 1}, 2, colourPink)
            if CommPageLeftMouseIsClicked == 1 then
                if get(variable) == 1 then
                    set(variable, 0)
                else
                    set(variable, 1)
                end
            end
        end
    end
end

function drawExclusiveButtonSet(buttonTable, variable)
    for key, button in pairs(buttonTable) do
        local x = button.x
        local y = button.y
        local isBlue = button.isBlue
        local label = button.label

        local textColour = colourWhite
        if isBlue then
            textColour = colourCyan
        end
        if label then
            sasl.gl.drawText(fontInconsolata, x + 32 + 20, y + 10, label, 25, false, false, TEXT_ALIGN_LEFT, textColour)
        end
        if isBlue then
            sasl.gl.drawTexture(exclusiveButtonBlueImage, x + 3, y - 5, 26, 40, colourWhite)
        else
            sasl.gl.drawTexture(exclusiveButtonImage, x + 3, y - 5, 26, 40, colourWhite)
            if get(variable) == button.value then
                sasl.gl.drawTexture(exclusiveButtonClickedImage, x + 3, y - 5, 26, 40, colourWhite)
            end
        end

        if not isBlue then
            y = y - 7
            local xM = x + 32
            local yM = y + 44
            if (CommMousePositionLeftX > x and CommMousePositionLeftX < xM) and (CommMousePositionLeftY > y and CommMousePositionLeftY < yM) then
                sasl.gl.drawWidePolyLine({x + 1, y + 1, x + 1, yM - 1, xM - 1, yM - 1, xM - 1, y + 1, x, y + 1}, 2, colourPink)
                if CommPageLeftMouseIsClicked == 1 then
                    if get(variable) ~= button.value then
                        set(variable, button.value)
                    end
                end
            end
        end
    end
end

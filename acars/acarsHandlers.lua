function acceptMessageCallback(url, result, notError, error)
    if notError and string.sub(result, 1, 2) == "ok" then
        if commMessageTable[commPfdMessageId].status == "ACCEPTING" then
            commMessageTable[commPfdMessageId].status = "ACCEPTED"
        end
        commPageSendText = "ACCEPTED"
    else
        if commMessageTable[commPfdMessageId].status == "ACCEPTING" then
            commMessageTable[commPfdMessageId].status = "ABORTED"
        end
        commPageSendText = "ABORTED"
        logError(error, result)
    end
    -- print(commPageSendText)
end

function rejectMessageCallback(url, result, notError, error)
    if notError and string.sub(result, 1, 2) == "ok" then
        if commMessageTable[commPfdMessageId].status == "REJECTING" then
            commMessageTable[commPfdMessageId].status = "REJECTED"
            commMessageTable[commPfdMessageId].status = "REJECTED"
            set(commPfdTimer, 6)
        end
        commPageSendText = "REJECTED"
    else
        if commMessageTable[commPfdMessageId].status == "REJECTING" then
            commMessageTable[commPfdMessageId].status = "ABORTED"
        end
        commPageSendText = "ABORTED"
        logError(error, result)
    end
end

function acceptMessage(activeMessage, requiresResponse)
    if commPageSendText ~= "ACCEPTING" and commPageSendText ~= "ACCEPTED" then
        local messageToAccept = commMessageTable[get(activeMessage)]
        local responseString = "N"
        local messageString = "ROGER"
        local min = commMinGen
        -- print(commMinGen, messageToAccept.min)

        if requiresResponse then
            responseString = "Y"
        end
        if messageToAccept.response == "WU" then -- WILCO/UNABLE
            messageString = "WILCO"
        elseif messageToAccept.response == "AN" then -- AFFIRM/NEGATIVE
            messageString = "AFFIRM"
        end
        local string = "/data2/" .. commMinGen .. "/"
        -- print("he", string, messageToAccept.min)
        string = string .. messageToAccept.min .. "/" .. responseString .. "/" .. messageString
        -- print(string)
        if get(activeMessage) == commPfdMessageId then
            commMessageTable[commPfdMessageId].status = "ACCEPTING"
        end
        commPageSendText = "ACCEPTING"
        -- print(string)
        commMinGen = commMinGen + 1

        addCommMessage(os.date("!%H%M"), "cpdlc", "N", string, messageToAccept.facility, false)
        network.getAsync({to = messageToAccept.facility, type = "cpdlc", packet = string}, acceptMessageCallback)
    end
end

function rejectMessage(activeMessage, requiresResponse)
    if commPageSendText ~= "REJECTING" and commPageSendText ~= "REJECTED" then
        local messageToAccept = commMessageTable[get(activeMessage)]
        local responseString = "N"
        local messageString = "UNABLE"
        local min = commMinGen
        -- print(commMinGen, messageToAccept.min)

        if requiresResponse then
            responseString = "Y"
        end
        if messageToAccept.response == "WU" then -- WILCO/UNABLE
            messageString = "UNABLE"
        elseif messageToAccept.response == "AN" then -- AFFIRM/NEGATIVE
            messageString = "NEGATIVE"
        end
        local string = "/data2/" .. commMinGen .. "/"
        -- print("he", string, messageToAccept.min)
        string = string .. messageToAccept.min .. "/" .. responseString .. "/" .. messageString
        -- print(string)
        if get(activeMessage) == commPfdMessageId then
            commMessageTable[commPfdMessageId].status = "REJECTING"
        end
        commPageSendText = "REJECTING"
        -- print(string)
        commMinGen = commMinGen + 1

        addCommMessage(os.date("!%H%M"), "cpdlc", "N", string, messageToAccept.facility, false)
        network.getAsync({to = messageToAccept.facility, type = "cpdlc", packet = string}, rejectMessageCallback)
    end
end

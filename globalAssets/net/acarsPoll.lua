local network = require "network"
local timerForPoll = 0
local connected = true
local json = require "json"
function pollAcarsResponse(url, result, notError, error)
    if notError then
        if result == "ok " then
            return true
        end

        if string.sub(result, 1, 3) == "ok " then
            message = string.gsub(result, "^ok", "")
            local messageTable = {}
            for row in string.gmatch(message, " {.-}}") do
                row = string.gsub(row, "{%d- ", "{")
                from, type, packet = string.match(row, "{(%w-) (%w-) {(.-)}")
                if packet ~= "" then
                    addCommMessage(os.date("!%H%M"), type, nil, packet, from, true)
                end
            end
        end
    else
        logError(error)
    end
end
function pollAcars()
    -- pollAcarsResponse("hoppie", "ok {LOVV cpdlc {/data2/15//WU/CONTACT @WIEN SOUTH CTR@ @133.80}}", true)
    -- pollAcarsResponse("hoppie", "ok {EGLL cpdlc {/data2/1832//R/CLR TO @LEPA@ RWY @27R@ DEP @MAXIT1F@ INIT CLB @6000ft@ SQUAWK @2262@ WHEN RDY CALL FREQ @121.700@ IF UNABLE CALL VOICE}} {BAW22 telex {SYSTEM TEST A}} {BAW22 posreq {}} {BAW22 cpdlc {/data2/4112//AN/READY?} {BAW22 cpdlc {/data2/4112//AN/READY?}", true)
    network.getAsync({type = "poll", from = get(flightNumber)}, pollAcarsResponse)
end
function pollForAcars()
    if get(acarsActiveDataref) == 1 then
        timerForPoll = timerForPoll - get(frameTime)
        if timerForPoll < 0 then
            timerForPoll = 20
            pollAcars()
        end
    end
    -- -------------------------------------------------------------------------
    -- deal with the eicas messages
    -- -------------------------------------------------------------------------
    local key = #commMessageTable
    local cpdlcFire = false
    local commFire = false
    while key > 0 do
        local message = commMessageTable[key]
        if message.status == "" then
            if message.type == "cpdlc" then
                cpdlcFire = true
            else
                commFire = true
            end
        -- elseif message.status == "DISPLAYED" then --! come back to this later
        --     if message.type == "cpdlc" then
        --         cpdlcFire = true
        --     end
        end
        if commFire and cpdlcFire then
            break
        end
        key = key - 1
        if key < #commMessageTable - 8 then
            break
        end
    end

    if cpdlcFire then
        addEicasCommMessage(1)
    end
    if commFire then
        addEicasCommMessage(2)
    end
end
local aliasFile = sasl.getAircraftPath() .. "/settings/acarsAliases.json"
function loadAcarsAliases()
    commAliases = json.readAndParse(aliasFile)
end
function handleUplinkedValues(tab)
    if tab.vhfFrequency then
        mfrScratchpads[1] = "UL " .. tab.vhfFrequency
    end
    if tab.speed then
        uplinkValues["speed"] = tab.speed
        uplinkValues["mach"] = false
    end
    if tab.initialClimbft then
        uplinkValues["altitude"] = tab.initialClimbft
    end
    if tab.mach then
        uplinkValues["speed"] = tab.mach
        uplinkValues["mach"] = true
    end
    if tab.qnh then --! don't know what to do
    end
end

----------------------------------------------------------------------------------
-- Update loop moved to end to allow it to take advantage of the functions/drefs
-- which are created above
----------------------------------------------------------------------------------
function update()
    -- -------------------------------------------------------------------------
    -- Set ACARS status
    -- -------------------------------------------------------------------------
    if get(acarsLogonCodeDataref) ~= "" and get(flightNumber) ~= "-------" and get(acarsEnabledDataref) == 1 then
        set(acarsActiveDataref, 1)
    else
        set(acarsActiveDataref, 0)
    end
    eicasCommTable = {}
    updateAll(components)
end

-- -----------------------------------------------------------------------------
-- Temp fix to sasl logging issue
-- -----------------------------------------------------------------------------
function logDebug(message)
	-- print(message)
end
-- -----------------------------------------------------------------------------
include "acars/acarsDatarefs.lua"
require "extraMaths"
network = require("network")
include "acars/acarsHandlers.lua"
include "settingsCore.lua"

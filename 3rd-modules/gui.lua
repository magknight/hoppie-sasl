-- -----------------------------------------------------------------------------
-- Data entry
-- -----------------------------------------------------------------------------
local gui = {_version = "1"}

function createDataEntryBox(id, type, x, y, w, h, dataref)
	table.insert(
		dataEntryBoxes,
		{
			id = "",
			type = type,
			x = x,
			y = y,
			w = w,
			h = h,
			dataref = dataref
		}
	)
end

return gui

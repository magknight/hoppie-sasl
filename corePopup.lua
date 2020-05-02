dataEntryBoxes = {}
local gui = require "gui"

function draw()
	-- -------------------------------------------------------------------------
	-- Draw basis
	-- -------------------------------------------------------------------------
	sasl.gl.drawRectangle(0, 0, 500, 450, colourWhite)
	sasl.gl.drawRectangle(0, 450, 500, 50, colourBrandNavy)
	sasl.gl.drawText(fontSourceSemiBold, 250, 465, "CPDLC", 30, false, false, TEXT_ALIGN_CENTER, colourWhite)
	sasl.gl.drawCircle(20, 475, 10, true, colourBrandMagenta)
	sasl.gl.drawRectangle(470, 465, 20, 20, colourBrandTeal)
	-- -------------------------------------------------------------------------
	--
	-- -------------------------------------------------------------------------
end

-- -----------------------------------------------------------------------------
-- Is it positive, or negative?
-- -----------------------------------------------------------------------------
function math.sign(v)
	return (v >= 0 and 1) or -1
end
-- -----------------------------------------------------------------------------
-- Round stuff, but properly
-- -----------------------------------------------------------------------------
function math.round(v, bracket)
	bracket = bracket or 1
	local sign = math.sign(v)
	local value = math.floor(v / bracket + math.sign(v) * 0.5) * bracket
	if sign == -1 then
		value = math.ceil(v / bracket + math.sign(v) * 0.5) * bracket
	end
	return value
end
-- -----------------------------------------------------------------------------
-- Do the rounding as usual, just add the trailing zeros
-- -----------------------------------------------------------------------------
function math.prettyRound(v, bracket, pretty)
	local result = math.round(v, bracket)
	return string.format("%." .. (pretty or 0) .. "f", result)
end

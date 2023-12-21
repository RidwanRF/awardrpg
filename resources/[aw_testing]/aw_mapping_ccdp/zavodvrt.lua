
local parkgate1 = createObject( 986, 2497.3, 2769.3, 11.5, 0, 0, 90 )
local parkgate2 = createObject( 985, 2497.3, 2777.2, 11.5, 0, 0, 90 )
local parkCol = createColCuboid(2490.588867, 2764.020508, 8.5, 14, 17, 6)
local openingTimer, opening, opened, closing

function openGates()
	if opened or opening then return end
	if closing then
		if isTimer(openingTimer) then killTimer(openingTimer) end
		openingTimer = setTimer(openGates, 500, 1)
		return
	end
	opening = true
	moveObject(parkgate1, 2000, 2497.3, 2763.9, 11.5, 0, 0, 0, "InOutQuad")
	moveObject(parkgate2, 2000, 2497.3, 2782.5, 11.5, 0, 0, 0, "InOutQuad")
	setTimer(function()
		opened = true
		opening = false
	end, 2000, 1)
    setTimer(closeGates, 5000, 1)
end
addEventHandler("onColShapeHit", parkCol, openGates)

function closeGates()
	if (#getElementsWithinColShape(parkCol, "vehicle") > 0) or (#getElementsWithinColShape(parkCol, "player") > 0) then
		setTimer(closeGates, 1000, 1)
	else
		moveObject(parkgate1, 2000, 2497.3, 2769.3, 11.5, 0, 0, 0, "InOutQuad")
		moveObject(parkgate2, 2000, 2497.3, 2777.2, 11.5, 0, 0, 0, "InOutQuad")
		opened = false
		closing = true
		setTimer(function() closing = false end, 2000, 1)
	end
end


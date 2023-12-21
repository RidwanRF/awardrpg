local vehicleped = {}

addEvent("destroyPed", true)
addEventHandler("destroyPed", getRootElement(),
	function(vehicle)
		if isElement(vehicleped[vehicle]) then
			destroyElement(vehicleped[vehicle])
			vehicleped[vehicle] = nil
		end
	end
)

addEventHandler("onVehicleExit", getRootElement(),
	function(_, seat)
		if seat == 0 and getVehicleType(source) == "Automobile" then
			local pos = getElementData(source, "wheel_pos")
			if pos then
				local x, y, z = getElementPosition(source)
				if not isElement(vehicleped[source]) then
					vehicleped[source] = createPed(0, x, y, z + 5)
					setElementAlpha(vehicleped[source], 0)
				end
				setElementData(vehicleped[source], "wheel_pos", pos)
				warpPedIntoVehicle(vehicleped[source], source)
				setVehicleDoorOpenRatio(source, (seat + 2), 0, 360)
			end
		end
	end
)

addEventHandler("onElementDestroy", getRootElement(),
	function()
		if vehicleped[source] then
			destroyElement(vehicleped[source])
			vehicleped[source] = nil
		end
	end
)
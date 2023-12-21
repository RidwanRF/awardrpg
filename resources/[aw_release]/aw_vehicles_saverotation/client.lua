local vehicleped = {}

addEventHandler("onClientVehicleStartEnter", getRootElement(),
	function(_, seat)
		if seat == 0 and getVehicleType(source) == "Automobile" then
			if not isVehicleLocked(source) then
				triggerServerEvent("destroyPed", localPlayer, source)
			end
		end
	end
)

addEventHandler("onClientKey", getRootElement(),
	function(button, press)
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if vehicle and getVehicleController(vehicle) == localPlayer then
			if button == "arrow_l" and press then
				if getVehicleType(vehicle) == "Automobile" then
					setElementData(vehicle, "wheel_pos", "vehicle_left")
					toggleControl("vehicle_left", false)
					toggleControl("vehicle_right", false)
					setControlState("vehicle_right", false)
					setControlState("vehicle_left", true)
				end
			elseif button == "arrow_r" and press then
				if getVehicleType(vehicle) == "Automobile" then
					setElementData(vehicle, "wheel_pos", "vehicle_right")
					toggleControl("vehicle_left", false)
					toggleControl("vehicle_right", false)
					setControlState("vehicle_left", false)
					setControlState("vehicle_right", true)
				end
			elseif (button == "w" or button == "a" or button == "s" or button == "d") and press then
				if getElementData(vehicle, "wheel_pos") then
					setElementData(vehicle, "wheel_pos", nil)
				end
				setControlState("vehicle_left", false)
				setControlState("vehicle_right", false)
				toggleControl("vehicle_left", true)
				toggleControl("vehicle_right", true)
			end
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
    function()
    	if getElementType(source) == "ped" then
    		local pos = getElementData(source, "wheel_pos")
    		if pos then
    			setPedControlState(source, pos, true)
    		end
    	end
	end
)
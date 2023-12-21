
------------------------------------------------

	addEvent('onClientVehicleScreenStreamIn', true)
	streamedVehicles = {}

------------------------------------------------

	addEventHandler('onClientElementStreamIn', root, function()
		if source.type == 'vehicle' then
			streamedVehicles[source] = true
		end
	end)

------------------------------------------------

	function handleStreamOut()
		if source.type == 'vehicle' then
			streamedVehicles[source] = nil
		end
	end

	addEventHandler('onClientElementDestroy', root, handleStreamOut)
	addEventHandler('onClientElementStreamOut', root, handleStreamOut)

------------------------------------------------

	addEventHandler('onClientRender', root, function()

		for vehicle in pairs( streamedVehicles ) do

			if isElementOnScreen(vehicle) and getDistanceBetween( vehicle, localPlayer ) < 50 then

				triggerEvent('onClientVehicleScreenStreamIn', vehicle)
				streamedVehicles[vehicle] = nil

			end

		end

	end)

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
			streamedVehicles[vehicle] = true
		end

	end)

------------------------------------------------



local ekxMarkers = {

	[ createMarker(1075.7331542969,1748.1522216797,10.827075958252-1, "cylinder", 3.0, 150, 90, 90, 50) ] = true,

	[ createMarker(1050.7457275391,1748.0714111328,10.827750205994-1, "cylinder", 3.0, 150, 90, 90, 50) ] = true,
	
	[ createMarker(1051.3033447266,1772.923828125,10.822277069092-1, "cylinder", 3.0, 150, 90, 90, 50) ] = true,

	[ createMarker(1075.6960449219,1772.3286132812,10.822532653809-1, "cylinder", 3.0, 150, 90, 90, 50) ] = true,


}
createBlip(1075.7331542969,1748.1522216797,10.827075958252, 24, 2, 255, 0, 0, 255, 0, 350)


-- Маркеры открытия панели
addEventHandler("onMarkerHit", resourceRoot, function(player)
	if (ekxMarkers[source]) and (getElementType(player) == "player") and (getPedOccupiedVehicleSeat(player) == 0) then
		local vehicle = getPedOccupiedVehicle(player)
		if (vehicle) and getElementData(vehicle, "owner") then
			setElementVelocity(vehicle, 0, 0, 0)
			triggerClientEvent(player, "openPanel", resourceRoot)
		end		
	end
end)
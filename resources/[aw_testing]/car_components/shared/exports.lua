function getVehiclePaintjobs(vehicle)
	if not isElement(vehicle) then
		return false
	end
	return PaintjobsTable[vehicle.model] or {}
end

function getXenonColors()
	return Config.xenonColors
end

function isVehiclePaintjobAllowed(vehicle)
	return not not (PaintjobsAllowed[vehicle.model] or PaintjobsTable[vehicle.model])
end

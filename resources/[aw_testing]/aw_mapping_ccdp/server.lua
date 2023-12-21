
addEventHandler("onResourceStart", resourceRoot, function()
	local mapsToSetAllDimensions = {
		"Aero_LS.map",
		"benzin.map",
		"redring_box.map",
	}
	for _, mapName in ipairs(mapsToSetAllDimensions) do
		for _, element in ipairs(getElementsByType("object", getResourceMapRootElement(resource, mapName))) do
			setElementDimension(element, -1)
		end
	end
end)

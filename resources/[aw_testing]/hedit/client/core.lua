--
--	CLIENTSIDE RESOURCE START PROCEDURE
--
local colshapes = {}
local function resourceStart()
	--Load the clientside configuration file, or create a new one if it does not exist.
	local rootNode = xmlLoadFile(client_config_file) or xmlCreateFile(client_config_file, "config")
	
	--Ensure all important setting nodes exist.
	for settingKey, defaultValue in pairs(setting) do
		if not xmlFindChild(rootNode, settingKey, 0) then
			local newNode = xmlCreateChild(rootNode, settingKey)
			xmlNodeSetValue(newNode, tostring(defaultValue))
		end
	end
	
	--Remove deprecated/unused setting nodes.
	for _, subNode in ipairs(xmlNodeGetChildren(rootNode)) do
		local nodeName = xmlNodeGetName(subNode)
		if not setting[nodeName] then
			xmlDestroyNode(subNode)
		end
	end
	
	xmlSaveFile(rootNode)
	xmlUnloadFile(rootNode)

	--Cache the client-side handling saves.
	cacheClientSaves()

	--Query the server for admin rights.
	triggerServerEvent("requestRights", root)
	
	--Build the GUI.
	startBuilding()
	
	-- Создаем коробочки внутри сто ЧЕНДЖ
	colshapes = {
		createColCuboid(-2056.71,   151.32, 27.8,   16.5, 31, 5.5),	-- СФ
		createColCuboid( 2920.62, -1104.26, 11.34,  16.5, 31, 5.5),	-- ЛС
		createColCuboid( 2880.15,  2219.5,  10.94,  16.5, 31, 5.5),	-- ЛВ
		createColCuboid(  997.5 , -1370.3 , 12.3,   20, 14.5, 5.5),	-- ЛС в центре
		createColCuboid(-3686.878, -378.358, 9.236, 20, 11.0, 5.5),	-- Красное Кольцо
		createColCuboid(-3713.001, -378.413, 9.237, 20, 11.0, 5.5),	-- Красное Кольцо
		createColCuboid(-1720.9, -367.86, 12, 8.5, 20.2, 5.5),	-- Аэро СФ -347.6
		createColCuboid(2458, 1324, 9, 13, 38, 5.5),	-- Re-Styling
		createColPolygon(-2421, 1971.7,
						-2420.8, 1959.2, 
						-2440.8, 1979.3,
						-2430.2, 1991.9,
						-2409.1, 1970),	-- Рублевка #2
	}
	-- /ЧЕНДЖ
end
addEventHandler("onClientResourceStart", resourceRoot, resourceStart)

function isVehicleInsideRepairStation(pVehicle)
	local ok = false
	for _, colShape in ipairs(colshapes) do
		local vehTable = getElementsWithinColShape(colShape, "vehicle")
		for _, veh in ipairs(vehTable) do
			if pVehicle == veh then
				ok = true
				break
			end
		end
		if ok == true then
			break
		end
	end
	return ok
end

function isPlayerInsideRepairStation(checkingPlayer)
	local ok = false
	for _, colShape in ipairs(colshapes) do
		local playerTable = getElementsWithinColShape(colShape, "player")
		for _, player in ipairs(playerTable) do
			if checkingPlayer == player then
				ok = true
				break
			end
		end
		if ok == true then
			break
		end
	end
	return ok
end

--
--	CLIENTSIDE RESOURCE STOP PROCEDURE
--
local function resourceStop()
	--Unload the clientside configuration file.
	xmlUnloadFile(client_handling_file)
end
addEventHandler("onClientResourceStop", resourceRoot, resourceStop)
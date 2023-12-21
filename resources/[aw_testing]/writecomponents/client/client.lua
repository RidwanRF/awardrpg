------------------------------------
--//          Skynet            //--
--//   vk.com/studioskynet     //--
-----------------------------------

local isVehicleComponent = function (vehicle, name)
	for id = 0, 15 do
		for k in pairs (getVehicleComponents (vehicle)) do
			if k == name..id then
				return true
			end
		end
	end
	return false
end

local writeVehicleComponents = function (vehicle)
	local config = '['..vehicle.model..'] = {\n'
	local IDC = 1
	for i,v in pairs(skynet.componentsFromData) do
		if isVehicleComponent(vehicle, i) then
			config = config..'\t["'..i..'"] = {\n'
			config = config..'\t\t[0] = { name = "Сток", price = 0},\n'
			for id = 1, 20 do
				for name in pairs(getVehicleComponents(vehicle)) do
					if name == i..id then
						config = config..'\t\t['..id..'] = { name = "'..skynet.componentsFromData[i]..' №'..id..'", price = 15000},\n'
					end
				end
			end
			config = config..'\t},\n'
			IDC = IDC + 1
		end
	end
	config = config..'},'

	triggerServerEvent('saveFileComponents', resourceRoot, 'assets/vehicles/'..vehicle.model..'.lua', config)
	
	outputChatBox('[Info] Данные выгружены в путь: assets/vehicles/'..vehicle.model..'.lua', 255, 255, 255)
end

--// Команда
addCommandHandler(skynet.commands, function ()
	if localPlayer.vehicle then
		writeVehicleComponents(localPlayer.vehicle)
	else
		outputChatBox("[Info] Вы должны быть в авто!", 255, 255, 255)
	end
end)

------------------------------------
--//          Skynet            //--
--//   vk.com/studioskynet     //--
-----------------------------------
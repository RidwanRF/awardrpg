
local vehicles = {}
function startTaxiJob(player, pos, price)
	takePlayerMoney(player, price)
	vehicles[player] = createVehicle(pos[1], pos[2], pos[3], pos[4], 0, 0, pos[5])
	setVehicleColor(vehicles[player], 255, 159, 9)
	setVehicleHandling(vehicles[player], "driveType", "awd")
	setVehicleHandling(vehicles[player], "maxVelocity", "260")
	setVehicleHandling(vehicles[player], "engineAcceleration", "15")
	setElementData(vehicles[player], "paintjob", "camry_taxi")	
	setElementData(player, "player:vehicle:taxi", vehicles[player])
	warpPedIntoVehicle(player, vehicles[player])
	setElementData(vehicles[player], "job.nomer", isResourceRunning("car_system") and exports.car_system:generateNumberplate("i") or "i-aa00199")	
	setElementData(vehicles[player], "vehicle:taxi", {owner = player})
	setElementData(vehicles[player], "vehicle:fuel", 10000)
	setElementData(vehicles[player], "vehicle:mileage", math.random(1000, 10000))
end
addEvent("startTaxiJob", true)
addEventHandler("startTaxiJob", resourceRoot, startTaxiJob)

function stopTaxiJob(player)
	if isElement(vehicles[player]) then
		destroyPedTaxi(player)
		destroyElement(vehicles[player])
	end
end
addEvent("stopTaxiJob", true)
addEventHandler("stopTaxiJob", resourceRoot, stopTaxiJob)


addEventHandler("onPlayerQuit", root, function()
	triggerClientEvent(resourceRoot, "stopJob", source)
end)

local peds = {}

onPlayerAcceptTaxiOrder = function (x, y, z)
	if peds[client] and isElement(peds[client]) then destroyElement(peds[client]) end
	peds[client] = createPed(config.skins[math.random(1, #config.skins)], x, y, z, 0)
end
addEvent("onPlayerAcceptTaxiOrder", true)
addEventHandler("onPlayerAcceptTaxiOrder", resourceRoot, onPlayerAcceptTaxiOrder)

function warpPedIntoVehicleTaxi()
	if peds[client] and isElement(peds[client]) then
		local vehicle = getPedOccupiedVehicle(client)
		if getVehicleOccupant(vehicle, 1) then
			removePedFromVehicle(getVehicleOccupant(vehicle, 1))
		end
		warpPedIntoVehicle(peds[client], vehicle, 1)
	end
end
addEvent("warpPedIntoVehicleTaxi", true)
addEventHandler("warpPedIntoVehicleTaxi", resourceRoot, warpPedIntoVehicleTaxi)

function destroyPedTaxi(player, pay)
	if peds[player] and isElement(peds[player]) then destroyElement(peds[player]) end
	if pay and tonumber(pay) and tonumber(pay) >= 0 then
		--givePlayerMoney(player, pay)
		exports.bank:givePlayerBankMoney(player, pay, "RUB")
	end
end
addEvent("destroyPedTaxi", true)
addEventHandler("destroyPedTaxi", resourceRoot, destroyPedTaxi)

addEventHandler("onVehicleStartEnter", root, function (player, seat)
 	if getElementData(source, "vehicle:taxi") and seat == 0 then
 		local data = getElementData(source, "vehicle:taxi")
		if data.owner ~= player then
 			cancelEvent()
 		end
 	end
 end)

 -- Проверка, что ресурс запущен
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end
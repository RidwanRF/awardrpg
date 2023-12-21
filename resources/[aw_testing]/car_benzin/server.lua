
local actualFuelTable = {}
local fuelTableChanges = {}

local actualOdometerTable = {}


function toggleEngine(player)
    local vehicle = getPedOccupiedVehicle(player)
    if (vehicle) and (getVehicleController(vehicle) == player) then
        local state = getVehicleEngineState(vehicle)
		if state then
			setVehicleEngineState(vehicle, false)
			outputChatBox('Машина заглушена', player, 50, 255, 50)
		else
			if getCarFuel(vehicle) <= 0.01 then
				outputChatBox('Нет бензина!', player, 255, 50, 50)
				return
			end
			if getElementData(vehicle, "isBroken") then
				outputChatBox("Машина разбита в погоне!", player, 255,50,50)
				return
			end
			setVehicleEngineState(vehicle, true)
			outputChatBox('Машина заведена', player, 50, 255, 50)
		end
    end
end
addCommandHandler("engine", toggleEngine)

function getCarFuel(vehicle)
	if isElement(vehicle) then
		return actualFuelTable[vehicle] or getElementData(vehicle, "fuel") or 0
	end
	return 0
end

function getCarOdometer(vehicle)
	if isElement(vehicle) then
		return actualOdometerTable[vehicle] or getElementData(vehicle, "odometer") or 0
	end
	return 0
end

function vehicleDriedOff(vehicle)
	if isElement(vehicle) then
		setElementData(vehicle, "fuel", 0)
		actualFuelTable[vehicle] = 0
		fuelTableChanges[vehicle] = nil
		setVehicleEngineState(vehicle, false)
	end
end
addEvent("vehicleDriedOff", true)
addEventHandler("vehicleDriedOff", resourceRoot, vehicleDriedOff)


function catchFuelDelta(vehicle, delta, odometerDelta)
	fuelTableChanges[vehicle] = delta
	if isElement(vehicle) then
		actualFuelTable[vehicle] = (getElementData(vehicle, "fuel") or 0) + delta
		actualOdometerTable[vehicle] = (getElementData(vehicle, "odometer") or 0) + odometerDelta
	end
end
addEvent("catchFuelDelta", true)
addEventHandler("catchFuelDelta", resourceRoot, catchFuelDelta)

function renewCarDatas()
	for vehicle, delta in pairs(fuelTableChanges) do
		if isElement(vehicle) then
			setElementData(vehicle, "fuel", actualFuelTable[vehicle])
			setElementData(vehicle, "odometer", actualOdometerTable[vehicle])
		end
		fuelTableChanges[vehicle] = nil
	end
	triggerClientEvent("resetDelta", resourceRoot)
	for vehicle, value in pairs(actualFuelTable) do
		if not isElement(vehicle) then
			actualFuelTable[vehicle] = nil
			actualOdometerTable[vehicle] = nil
		end
	end
end
setTimer(renewCarDatas, 30000, 0)



-- ==========	Заправка	==========

local refuellingTimers = {}
local refuelParam = {}	-- Параметры заправки
-- refuelParam[player] = {money, fueled, carParam = {tank, consumption, fuel}, fuelParam = {price, octane,	fType}, refuelSpeed, vehicle, stationID, fuelType}

function startRefuelling(vehicle, fuelType, liters, stationID)
	if (not isElement(vehicle)) or (not fuels[fuelType]) then return end
	local model = getElementModel(vehicle)
	local carParam = carData[model] or carData[0]
	local fuelParam = fuels[fuelType]
	local refuelSpeed = getRefuelSpeedFromCapacity(carParam.tank)
	refuelParam[client] = {money = 0, fueled = 0, carParam = carParam, fuelParam = fuelParam, refuelSpeed = refuelSpeed, vehicle = vehicle, stationID = stationID, fuelType = fuelType}
	if not isTimer(refuellingTimers[client]) then
		refuellingTimers[client] = setTimer(refuelling, 1000, 1, client, fuelType, liters)
	end
end
addEvent("startRefuelling", true)
addEventHandler("startRefuelling", resourceRoot, startRefuelling)


function refuelling(player, fuelType, liters)
	-- params = {money, fueled, carParam = {tank, consumption, fuel, maxSpd}, fuelParam = {price, octane, fType}, refuelSpeed, vehicle, stationID, fuelType}
	local params = refuelParam[player]
	if (not params) then return end
	
	local vehicle = params.vehicle
	
	if isElement(player) and isElement(vehicle) then
		if (getVehicleController(vehicle) == player) then
			local currentFuel = getCarFuel(vehicle)
			local currentOctane = (getElementData(vehicle, "fuelOctane") or params.fuelParam.octane)
			local tankOfStation = getTankOfStation(params.stationID, params.fuelType)
			if (currentFuel >= params.carParam.tank) then stopRefuelling(player) return end		-- Если бак переполнен, то заправлять не надо
			if (getPlayerMoney(player) <= 0) then stopRefuelling(player) return end				-- Если денег вообще нет, то заправлять не надо
			if (tankOfStation <= 0) then 														-- Если станция пуста, то заправлять не надо
				stopRefuelling(player)	
				outputChatBox("Данный вид топлива на этой заправке закончился!", player, 255,50,50)						
				return
			end
			
			local fuelToFill = params.refuelSpeed	-- Изначально устанавливаем кол-во топлива равное максимальной скорости заливки
			if (liters < fuelToFill) then			-- Срезаем литры, если нам осталось залить меньше, чем предполагали
				fuelToFill = liters
			end
			if (currentFuel+fuelToFill > params.carParam.tank) then		-- Срезаем литры, если до конца бака осталось немного
				fuelToFill = params.carParam.tank - currentFuel
			end
			local money = fuelToFill*params.fuelParam.price
			if (getPlayerMoney(player) < money) then					-- Срезаем литры, если у игрока маловато деняк
				fuelToFill = getPlayerMoney(player) / params.fuelParam.price
				money = fuelToFill*params.fuelParam.price
			end
			if (tankOfStation < fuelToFill) then						-- Срезаем литры, если на станции мало
				fuelToFill = tankOfStation
				money = fuelToFill*params.fuelParam.price
			end
			
			if (fuelToFill < 0) then									-- Если какого-то хуя отрицательные литры, то что-то не так..
				outputDebugString("[CAR_BENZIN][ERROR] fuelToFill="..tostring(fuelToFill)..", params.refuelSpeed="..tostring(params.refuelSpeed)..", liters="..tostring(liters)
					..", params.carParam.tank="..tostring(params.carParam.tank)..", currentFuel="..tostring(currentFuel)..", getPlayerMoney(player)="..tostring(getPlayerMoney(player))
					..", tankOfStation="..tostring(tankOfStation))
				stopRefuelling(player)
				return
			end
			
			-- (Кол-во раньше * октан раньше + нового * новый октан) / новый объем
			local newOctane = (currentFuel*currentOctane + fuelToFill*params.fuelParam.octane) / (currentFuel+fuelToFill)
			
			local licensep = getElementData(vehicle, "licensep") or ""
			if (licensep:sub(1, 1) ~= "b") then
				takePlayerMoney(player, money)
			end
			giveCarFuel(vehicle, player, fuelToFill, newOctane, params.carParam.fuel)
			takeFuelFromStation(params.stationID, params.fuelType, fuelToFill)
			liters = liters - fuelToFill
			
			refuelParam[player].money = params.money + money
			refuelParam[player].fueled = params.fueled + fuelToFill
			
			if (liters > 0) then
				refuellingTimers[player] = setTimer(refuelling, 1000, 1, player, fuelType, liters)
			else
				stopRefuelling(player)
			end
		else
			stopRefuelling(player)
		end
	else
		refuelParam[player] = nil
	end
end

function giveCarFuel(vehicle, player, amount, newOctane, idealFuel)
	local oldFuel = actualFuelTable[vehicle] or getElementData(vehicle, "fuel") or 0
	local newFuel = oldFuel + amount
	setElementData(vehicle, "fuel", newFuel)
	setElementData(vehicle, "fuelOctane", newOctane)
	setOctaneDependentParameters(vehicle, newOctane, idealFuel)
	-- setVehicleHandling(vehicle, "maxVelocity", (refuelParam[player].carParam.maxSpd or carData[0].maxSpd) * getMultiplerFromOctane(newOctane, idealFuel))
	
	actualFuelTable[vehicle] = newFuel
	fuelTableChanges[vehicle] = nil
	triggerClientEvent(player, "resetDelta", resourceRoot)
end

function setOctaneDependentParameters(vehicle, octane, idealFuel)	-- octane, idealFuel передавать не обязательно
	local model = getElementModel(vehicle)
	local thisCarData = carData[model] or carData[0]
	idealFuel = idealFuel or thisCarData.fuel
	octane = octane or getElementData(vehicle, "fuelOctane") or 92.0
	setVehicleHandling(vehicle, "maxVelocity", (thisCarData.maxSpd) * getMultiplerFromOctane(octane, idealFuel))
end

function stopRefuelling(player)
	if isTimer(refuellingTimers[player]) then killTimer(refuellingTimers[player]) end
	local stats = refuelParam[player]
	if isElement(player) and (stats) then
		
		outputChatBox("Вы успешно заправили машину на $ "..math.round2(stats.money)..", залив "..math.ceil(stats.fueled).."л. топлива", player, 50,255,50)
	end
	refuelParam[player] = nil
end
addEvent("stopRefuelling", true)
addEventHandler("stopRefuelling", resourceRoot, stopRefuelling)

function math.round2(number)
	return math.floor(number*100)/100
end



function killPlayerOnDrowning()
	killPed(client, nil, 53)
end
addEvent("ImVeryDrown", true)
addEventHandler("ImVeryDrown", resourceRoot, killPlayerOnDrowning)

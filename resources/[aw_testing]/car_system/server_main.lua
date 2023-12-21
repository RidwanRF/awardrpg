
-- Кастомные мигалки на машинах
local customSirens = {
	[479] = {	-- BMW M5 F90
		licensepType = "police",
		sirenType = 3, allDirections = true, checkLOS = true, useRandom = false, silent = false,
		{pos = {x = -0.070, y = -0.346, z = 0.737}, color = {r = 255, g = 0, b = 0}, alpha = 255, minAlpha = 0},
		{pos = {x = -0.245, y = -0.346, z = 0.737}, color = {r = 255, g = 0, b = 0}, alpha = 255, minAlpha = 0},
		{pos = {x = -0.485, y = -0.346, z = 0.737}, color = {r = 255, g = 0, b = 0}, alpha = 255, minAlpha = 0},
		{pos = {x =  0.485, y = -0.346, z = 0.737}, color = {r = 0, g = 0, b = 255}, alpha = 255, minAlpha = 0},
		{pos = {x =  0.245, y = -0.346, z = 0.737}, color = {r = 0, g = 0, b = 255}, alpha = 255, minAlpha = 0},
		{pos = {x =  0.070, y = -0.346, z = 0.737}, color = {r = 0, g = 0, b = 255}, alpha = 255, minAlpha = 0},
	},
	[542] = {	-- Lamborghini Aventador
		licensepType = "police",
		sirenType = 3, allDirections = true, checkLOS = true, useRandom = false, silent = false,
		{pos = {x = -0.070, y = -0.346, z = 0.737}, color = {r = 255, g = 0, b = 0}, alpha = 255, minAlpha = 0},
		{pos = {x = -0.245, y = -0.346, z = 0.737}, color = {r = 255, g = 0, b = 0}, alpha = 255, minAlpha = 0},
		{pos = {x = -0.485, y = -0.346, z = 0.737}, color = {r = 255, g = 0, b = 0}, alpha = 255, minAlpha = 0},
		{pos = {x =  0.485, y = -0.346, z = 0.737}, color = {r = 0, g = 0, b = 255}, alpha = 255, minAlpha = 0},
		{pos = {x =  0.245, y = -0.346, z = 0.737}, color = {r = 0, g = 0, b = 255}, alpha = 255, minAlpha = 0},
		{pos = {x =  0.070, y = -0.346, z = 0.737}, color = {r = 0, g = 0, b = 255}, alpha = 255, minAlpha = 0},
	},
	noSiren = {
		licensepType = "normal",
		sirenType = 1, allDirections = false, checkLOS = false, useRandom = false, silent = true,
		{pos = {x=0, y=0, z=0}, color = {r=0, g=0, b=0}, alpha=0, minAlpha=0},
	},
}
customSirens[416] = customSirens.noSiren	-- Ambulance
customSirens[490] = customSirens.noSiren	-- Range Rover SVAutobiography
customSirens[596] = customSirens.noSiren	-- Audi A8 D4
customSirens[598] = customSirens.noSiren	-- Mercedes-Benz E63 AMG
customSirens[599] = customSirens.noSiren	-- Toyota Land Cruiser 200

local teleportBlockCoords = {x = -2730, y = 1827, radius = 200}


local _createVehicle = createVehicle
function createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    local veh
    if model >= 400 and model <= 611 then
        veh = _createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    else
        veh = _createVehicle(411, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    end

    setElementData(veh, "vehicle:model", model)

    return veh
end

-- В логах для всех машин указывать: ID, licensep, owner, опционально model, modelName

local vehiclesByID = {}		-- Таблица машин по их ID

function onResourceStart()
	if isResourceRunning("mysql") then
		local continue = prepareTables()
		if (continue) then continue = checkAndUpdateTables() end
		if (continue) then checkAndUpdatePaintjobs() end
	else
		outputChatBox("[CAR_SYSTEM][ERROR] mysql is not running!", root, 255,0,0)
		setTimer(onResourceStart, 5000, 1)
	end
end
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

function getModelTable (salon, id)
	local res = false
	for i, v in ipairs (shopTable[salon].cars) do
		if v.model == id then
			res = i
			break
		end
	end
	if not res then
		--print (salon, id)
	end
	return res
end

addEvent("dbCallback", false)
addEventHandler("dbCallback", resourceRoot, function(queryResult, callbackFunctionName, callbackArguments)
	_G[callbackFunctionName](queryResult, callbackArguments)
end)


-- ==========     Отправка списка машин     ==========
function updateVehicleInfo(player)
	player = player or client
	if not isElement(player) then return end
	local accName = getAccountName(getPlayerAccount(player))
	if isResourceRunning("mysql") then
		exports.mysql:dbQueryAsync("updateVehicleInfoCallback", {player=player, accName=accName}, "vehicle", "SELECT ID, model, licensep, userOrder, fuel FROM ?? WHERE owner = ?;", accName)
	else
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot updateVehicleInfo - mysql is not active", 2)
	end
end
function updateVehicleInfoCallback(result, args)
	if not isElement(args.player) then return end
	triggerClientEvent(args.player, "refreshCarList", resourceRoot, result, colshapes.usedauto, colshapes.nomerchange)
	
	setElementData(args.player, "VehicleInfo", result)
	
	if isResourceRunning("house") then
		triggerClientEvent(args.player, "catchParkingLotsCount", resourceRoot, getUsedParkLots(args.accName), exports.house:getPlayerParkingLots(args.accName))
	else
		triggerClientEvent(args.player, "catchParkingLotsCount", resourceRoot, getUsedParkLots(args.accName), 0)
	end
end
addEvent("clientStartsResource", true)
addEventHandler("clientStartsResource", resourceRoot, updateVehicleInfo)

function removeAllMyVehicle()
	for i,v in ipairs (getElementsByType("vehicle")) do
		if getElementData (v, "owner") == getAccountName(getPlayerAccount(client)) then
			if not getElementData(v, "job_taxi.isTaxi") and not getElementData(v, "hasIllegalItems") then
				destroyVehicle(v)
			end
		end
	end
	exports.aw_interface_notify:alert (client, "ok", "F3", "Все машины убраны.", 8000)
	--outputCarSystemInfo("Все машины убраны.", client)
end
addEvent("removeAllMyVehicle", true)
addEventHandler("removeAllMyVehicle", resourceRoot, removeAllMyVehicle)

-- Получение количества занятых парковочных мест
function getUsedParkLots(accName)
	if isResourceRunning("mysql") then
		local result = exports.mysql:dbQuery(-1, "vehicle", "SELECT COUNT(ID) AS count FROM ?? WHERE owner = ? AND model NOT IN ("..notSlottingCarsList..");", accName)
		return ((result and result[1] and result[1].count) or 0)
	else
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot getUsedParkLots - mysql is not active", 2)
		return 0
	end
end

-- ==========     Респавн машины     ==========
function respawnMyVehicleFunc(id)
	local vehicle = vehiclesByID[id]
	if isElement(vehicle) then
		if getElementData(vehicle, "hasIllegalItems") then
			outputCarSystemError("Вы не можете респавнить данное транспортное средство, так как в нем находятся незаконные предметы", client)
			return
		end
		if getElementData(vehicle, "job_taxi.isTaxi") then
			outputCarSystemError("Вы не можете респавнить данное транспортное средство, так как оно используется в такси.", client)
			return
		end
		triggerEvent("saveAccountShtorka", getRootElement(), vehicle)
		destroyVehicle(vehicle)
	end
	spawnVehicle(id, client, true, false)
end
addEvent("respawnMyVehicle", true)
addEventHandler("respawnMyVehicle", resourceRoot, respawnMyVehicleFunc)

-- ==========     Спавн машины     ==========
function checkVeh (pl)
local count = 0
local acc = getAccountName (getPlayerAccount (pl))
for i, v in ipairs (getElementsByType ("vehicle")) do
	if getElementData (v, "owner") == acc then
		count = count + 1
	end
end
return count
end

function spawnVehicle(id, player, showMessage, warpInto)
	if isElement(vehiclesByID[id]) then return end
	if isResourceRunning("mysql") then
		if checkVeh (player) + 1 > 2 then outputCarSystemError ("Можно спавнить только 2 машины.", player) return end
		local secondTableName = exports.mysql:getTableName("handling")
		local callbackArguments = {player=player, showMessage=showMessage, requestedID=id, warpInto=warpInto}
		-- "vehicle", "SELECT * FROM ?? AS veh, ?? AS han WHERE veh.ID = ? AND han.ID = ?;", secondTableName, id, id
		exports.mysql:dbQueryAsync("spawnVehicleCallback", callbackArguments, "vehicle", "SELECT * FROM ?? AS veh LEFT JOIN ?? AS han ON (veh.ID = han.ID) WHERE veh.ID = ?;", secondTableName, id)
	else
		outputCarSystemError("Невозможно заспавнить машину - системная ошибка. Сообщите об этом администратору.", player)
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot spawn car - mysql is not active", 2)
	end
end
function spawnVehicleCallback(result, args)
	if not isElement(args.player) then return end
	if (not result) or (#result < 1) then
		outputCarSystemError("Возникла проблема с транспортом id "..tostring(args.requestedID)..", сообщите об этом администратору.", args.player)
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot spawn car - problem with id "..tostring(args.requestedID), 2)
		return
	end
	if (getElementInterior(args.player) ~= 0) then return end
	local dimension = getElementDimension(args.player)
	if (dimension > 10) then return end
	
	result = result[1]
	result.ID = tonumber(result.ID) or tonumber(args.requestedID)
	result.model = tonumber(result.model)
	
	if isElement(vehiclesByID[result.ID]) then return end
	
	if (getAccountName(getPlayerAccount(args.player)) ~= result.owner) then
		outputDebugString(string.format("[CAR_SYSTEM] Cannot spawn car - wrong owner. %s found, %s expected. Car: %s, lic %s, model %s",
			tostring(getAccountName(getPlayerAccount(args.player))), tostring(result.owner), tostring(result.ID), tostring(result.licensep), tostring(result.model)
		), 1)
		return
	end
	
	if (result.flag == "police") then
		if not isResourceRunning("police_ccd") or not exports.police_ccd:isActivePoliceman(args.player) then
			outputCarSystemError("Вы не можете заспавнить этот автомобиль, пока не начнете смену в полиции.", args.player)
			return
		end
	end
	
	local vehicle = createVehicle(result.model, result.x, result.y, result.z, 0, 0, result.rotZ)

	
	
	setElementData(vehicle, "ID", result.ID)
	setElementData(vehicle, "owner", result.owner)
	setElementData(vehicle, "fuel", result.fuel)
	setElementData(vehicle, "fuelOctane", result.fuelOctane)
	setElementData(vehicle, "odometer", result.odometer)
	setElementData(vehicle, "licensep", result.licensep)

	triggerEvent("loadAccountShtorka", getRootElement(), vehicle)
	
    triggerEvent("loadAccountStrob", getRootElement(), vehicle)

	triggerEvent("loadAccountStickers", getRootElement(), vehicle)

	local color = split(result.colors, ',')
	local r1 = color[1] or 255
	local g1 = color[2] or 255
	local b1 = color[3] or 255
	local r2 = color[4] or 255
	local g2 = color[5] or 255
	local b2 = color[6] or 255
	setVehicleColor(vehicle, r1, g1, b1, r2, g2, b2)
	
	local health = tonumber(result.HP) or 1000
	if health <= 255.5 then health = 255 end
	setElementHealth(vehicle, health)
	
	if (result.model ~= 462) and (result.handling) and (result.handling ~= "") then
		for property, value in pairs(fromJSON(result.handling)) do
			if (property ~= "suspensionUpperLimit") then
				setVehicleHandling(vehicle, property, value)
			end
		end
	end
	
	local paintjob = result.paintjob
	if (paintjob ~= "3") and (paintjob ~= 3) and (paintjob ~= "") then
		setElementData(vehicle, "paintjob", paintjob)
	end
	
	local customTuning = fromJSON(result.customTuning)
	local stage = customTuning.stage
	if (customTuning) then
		local toner = customTuning.toner
		local xenon = customTuning.xenon
		local smokecolor = customTuning.smokecolor
		local sgu = customTuning.sgu
		local shtorka = customTuning.shtorka
		if (toner) then
			setElementData(vehicle, "tint_front", toner[1])
			setElementData(vehicle, "tint_side", toner[2])
			setElementData(vehicle, "tint_rear", toner[3])
		end
		if (xenon) then
			xenon[1] = tonumber(xenon[1]) or 255
			xenon[2] = tonumber(xenon[2]) or 255
			xenon[3] = tonumber(xenon[3]) or 255
			setVehicleHeadLightColor(vehicle, xenon[1], xenon[2], xenon[3])
			setElementData(vehicle, "xenon", xenon[1]..","..xenon[2]..","..xenon[3])
		else
			setVehicleHeadLightColor(vehicle, 255, 255, 255)
			setElementData(vehicle, "xenon", "255,255,255")
		end
		if (smokecolor) then
			setElementData(vehicle, "SmokeColor", {smokecolor[1], smokecolor[2], smokecolor[3]})
		end
		if (shtorka) then
			setElementData(vehicle, "shtorka", shtorka)
		end
		if (sgu) then
			local pos = fromJSON(sgu.pos)
			setElementData(vehicle, "sgu_config", tonumber(sgu.state))
			if pos[1] and pos[2] and pos[3] and pos[4] then
				setElementData(vehicle, "sgu", sgu.pos)
			end
		end
		if (stage) then
			setElementData(vehicle, 'stage', stage)
		end
	end
	
	if (hasActiveHeadlights[result.model]) then
		setVehicleOverrideLights(vehicle, 1)
	end	
	
	vehiclesByID[result.ID] = vehicle
	
	local upgrades = split(tostring(result.upgrades), ';')
	for _, upgrade in ipairs(upgrades) do
		local upgrParts = split(upgrade, ',')
		if not tonumber(upgrParts[1]) then
			setElementData(vehicle, upgrParts[1], (tonumber(upgrParts[2]) or upgrParts[2]))
		else
			local detal = oldUpgradesToNew[ tonumber(upgrParts[1]) ]
			if (detal) then
				setElementData(vehicle, detal[1], tonumber(detal[2]))
			end
		end
	end
	
	if isResourceRunning("car_benzin") then
		exports.car_benzin:setOctaneDependentParameters(vehicle)
	end
	
	setElementDimension(vehicle, dimension)
	
	local vehType = getVehicleType(result.model)
	if (vehType == "Automobile") or (vehType == "Boat") then
		setElementData(vehicle, "hasInventory", true)
	end
	
	triggerClientEvent("forceUpdateVehicleComponents", vehicle)
	
	if (customSirens[result.model]) then
		local sirensData = customSirens[result.model]
		if licensepMatch(result.licensep, sirensData.licensepType) then
			removeVehicleSirens(vehicle)
			addVehicleSirens(vehicle, #sirensData, sirensData.sirenType, sirensData.allDirections, sirensData.checkLOS, sirensData.useRandom, sirensData.silent)
			for siren, data in ipairs(sirensData) do
				setVehicleSirens(vehicle, siren, data.pos.x,data.pos.y,data.pos.z, data.color.r,data.color.g,data.color.b, data.alpha, data.minAlpha)
			end
		end
	end

	
	if (args.showMessage) then
	--	outputCarSystemInfo("#ffffffВаш транспорт заспавнен.", args.player)
		exports.aw_interface_notify:showInfobox(client,"info", "Личный транспорт", "Ваш транспорт заспавнен.", getTickCount(), 8000)
	end
	
	if (args.warpInto) then
		setTimer(warpPedIntoVehicle, 50, 1, args.player, vehicle, 0)
	end
end

function licensepMatch(licensep, licType)
	if (licType == "normal") then
		return (tostring(licensep):sub(1, 1) ~= "b")
	elseif (licType == "police") then
		return (tostring(licensep):sub(1, 1) == "b")
	else
		outputDebugString("[CAR_SYSTEM] Unknown licType on licensepMatch. licensep: "..inspect(licensep)..", licType: "..inspect(licType))
	end
end


-- ==========     Убрать машину     ==========
function removeMyVehicle(id)
	local vehicle = vehiclesByID[id]
	if isElement(vehicle) then
		if getElementData(vehicle, "job_taxi.isTaxi") then
			exports.aw_interface_notify:showInfobox(client,"info", "Личный транспорт", "Вы не можете убрать данное транспортное средство, так как оно используется в такси.", getTickCount(), 8000)
		--	outputCarSystemError("Вы не можете убрать данное транспортное средство, так как оно используется в такси.", client)
			return
		elseif getElementData(vehicle, "hasIllegalItems") then
			exports.aw_interface_notify:showInfobox(client,"info", "Личный транспорт", "Вы не можете убрать данное транспортное средство, так как в нем находятся незаконные предметы", getTickCount(), 8000)
			return
		end
		exports.aw_interface_notify:showInfobox(client,"info", "Личный транспорт", "Ваш транспорт убран.", getTickCount(), 8000)
	--	exports.aw_interface_notify:alert (client, "ok", "F3", "Ваш транспорт убран.", getTickCount(), 8000)
		--outputCarSystemInfo("Ваш транспорт #цв#"..getVehicleModName(getElementModel(vehicle)).." #FFFFFFубран.", client)
		
		destroyVehicle(vehicle)
	else
	--	outputCarSystemInfo("Ваш транспорт #FF0000не заспавнен", client)
		exports.aw_interface_notify:showInfobox(client,"info", "Личный транспорт", "Ваш транспорт не заспавнен.", getTickCount(), 8000)
	end
end
addEvent("removeMyVehicle", true)
addEventHandler("removeMyVehicle", resourceRoot, removeMyVehicle)

-- ==========     Убирание машины     ==========
function destroyVehicle(theVehicle)
	if isElement(theVehicle) then
		saveCarData(theVehicle)
		for _, element in ipairs( getAttachedElements(theVehicle) ) do
			if isElement(element) and (getElementType(element) == "blip") then
				destroyElement(element)
			end
		end
		local id = getElementData(theVehicle, "ID")
		vehiclesByID[id] = nil
		destroyElement(theVehicle)
	end
end

-- ==========     Сохранение данных машины     ==========
function saveCarData(vehicle)
	if not isElement(vehicle) then return end
	if not getElementData(vehicle, "owner") then return end
	
	if isResourceRunning("mysql") then
		local x, y, z = getElementPosition(vehicle)
		local _, _, rz = getElementRotation(vehicle)
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
		local color = table.concat({r1, g1, b1, r2, g2, b2}, ",")
		local paintjob = getElementData(vehicle, "paintjob") or ""
		local id = getElementData(vehicle, "ID")
		local fuel = getElementData(vehicle, "fuel")
		local fuelOctane = getElementData(vehicle, "fuelOctane")
		local odometer = getElementData(vehicle, "odometer")
		local HP = getElementHealth(vehicle)
		
		local tintFront = getElementData(vehicle, "tint_front") or false
		local tintSide = getElementData(vehicle, "tint_side") or false
		local tintRear = getElementData(vehicle, "tint_rear") or false
		local xenonData = getElementData(vehicle, "xenon")
		local xenon = xenonData and split(xenonData, ",") or {255, 255, 255}
		local paint = {getElementData(vehicle, "colorType"), getElementData(vehicle, "colorTypeRGB")}
		
		local smokecolor = {255, 255, 255}
		if getElementData (vehicle, "SmokeColor") and type (getElementData (vehicle, "SmokeColor")) == "table" then
			local colorsmoke = getElementData (vehicle, "SmokeColor")
			smokecolor = {colorsmoke[1], colorsmoke[2], colorsmoke[3]}
		end
		
		local posSGU = getElementData(vehicle, "sgu") or toJSON({false, false, false, false, false, false}) -- Положение сгу 
		local buyedSGU = getElementData (vehicle, "sgu_config") or 0
		local buyedShtorka = getElementData (vehicle, "shtorka") or 0
		
		local dirtLevel = 1
		if isResourceRunning ("moika") then
			dirtLevel = exports.moika:getVehicleDirtLevel (vehicle)
		end
		
		local customTuning = toJSON({toner = {tintFront, tintSide, tintRear}, 
									xenon = xenon, 
									smokecolor = smokecolor,
									paint = paint,
									shtorka = shtorka,
									dirt = dirtLevel,
									sgu = {
										state = tostring(buyedSGU), 
										pos = posSGU
										},
									}, true)
		
		local upgrades = {}
		for _, upgrade in pairs(upgradeVariants) do
			local installed = getElementData(vehicle, upgrade)
			if (installed) and (installed ~= 0) then
				table.insert(upgrades, upgrade..","..tostring(installed))
			end
		end
		upgrades = table.concat(upgrades, ";")
		
		exports.mysql:dbExec("vehicle", [[UPDATE ?? SET x=?, y=?, z=?, rotZ=?, colors = ?, upgrades = ?,
			paintjob = ?, HP = ?, fuel=?, customTuning = ?, fuelOctane = ?, odometer = ? WHERE ID = ?;]],
			x, y, z, rz, color, upgrades, paintjob, HP, fuel, customTuning, fuelOctane, odometer, id)
		
		if (getElementModel(vehicle) ~= 462) then
			local handling = getVehicleHandling(vehicle)
			if getElementData (vehicle, "zimaHandling") then
				for k, v in pairs (fromJSON(getElementData (vehicle, "zimaHandling"))) do
					handling[k] = v
				end
			end
			local handlingJSON = toJSON(handling, true)
			--exports.mysql:dbExec("handling", "UPDATE ?? SET handling = ? WHERE ID = ?;", handling, id)
			exports.mysql:dbExec("handling", "REPLACE INTO ?? (ID, handling) VALUES(?, ?);", id, handlingJSON)
		end
	else
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot save car data - mysql is not active", 2)
	end
end
-- Исправление проебанных записей о хэндлинге
-- INSERT INTO car_system_handling (ID, handling) SELECT ID, "" AS handling FROM car_system_vehicle AS t1 WHERE model != 462 AND NOT EXISTS (SELECT ID FROM car_system_handling WHERE ID = t1.id);

-- Сохранение машины при выходе водителя
function saveVehicleOnExitFromIt(_, seat, _) 
	if isElement(source) then
		if getElementType(source) == "vehicle" then
			if getElementData(source, "ID") and (seat == 0) then
				saveCarData(source)
			end
		end
	end
end


addEventHandler("onVehicleExit", root, saveVehicleOnExitFromIt)


function giveVehicleForPlayer(player, model, r1, g1, b1, r2, g2, b2, shopID, region)
	client = player
	return giveNewVehicle(model, r1, g1, b1, r2, g2, b2, shopID, region)
end

function giveNewVehicle(model, r1, g1, b1, r2, g2, b2, shopID, region)
	region = tonumber(region)

	
	local acc = getPlayerAccount(client)
	local accName = getAccountName(acc)

	if not isResourceRunning("mysql") then
		outputCarSystemError("Невозможно купить машину - системная ошибка. Сообщите об этом администратору.", client)
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot buy car - mysql is not active", 2)
		return false
	end

	local newID = getFreeID()
	if (not newID) then
		outputDebugString("[CAR-SYSTEM] Cannot getFreeID(): result="..tostring(newID), 1)
		return false
	end
	local color = table.concat({r1, g1, b1, r2, g2, b2}, ",")
	local fuel = math.random(10, 25)
	local paintjob = stockPaintjobs[model] or ""
	
	local vehicleType = getVehicleType(model)
	local licensePlate = generateNumberplate("a", region)
	if (vehicleType == "Bike") or (vehicleType == "Quad") or (vehicleType == "BMX") then
		licensePlate = generateNumberplate("c", region)
	elseif (vehicleType == "Boat") then
		licensePlate = generateNumberplate("boat")
	elseif (vehicleType == "Helicopter") then
		licensePlate = generateNumberplate("helicopter")
	end
	-- Остаются Automobile: Cars, vans and trucks, Plane, Train, Trailer: A trailer for a truck, Monster Truck
	local shop = shopTable[shopID] or {}

	local parking = getAccountData(acc, 'donat:parking') or 0
	setAccountData(acc, 'donat:parking', parking + 1)
	exports.mysql:dbExec("vehicle", [[INSERT INTO ?? (ID, owner, model, x, y, z, rotZ, colors, upgrades, paintjob, HP, fuel, licensep, customTuning, fuelOctane, odometer, userOrder)
		VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);]],
		newID, accName, model, shop.spwnPosX, shop.spwnPosY, shop.spwnPosZ, shop.spwnRotZ, color, "", paintjob, 1000.0, fuel, licensePlate, toJSON({toner = {false, false, false}}, true), "92.0", math.random(0, 12), getNextUserOrderValue(accName)
	)
	if (model ~= 462) then
		exports.mysql:dbExec("handling", "REPLACE INTO ?? (ID, handling) VALUES(?, ?);", newID, "")
	end

	updateVehicleInfo(client)
	
	return true
end




function buyVehicleForPlayer(player, model, r1, g1, b1, r2, g2, b2, shopID, region)
	client = player
	return buyNewVehicle(model, r1, g1, b1, r2, g2, b2, shopID, region)
end

-- ==========     Покупка машины из салона     ==========
function buyNewVehicle(model, r1, g1, b1, r2, g2, b2, shopID, region)
	region = tonumber(region)
	
	local cost, currency = getCarPrice(model)
	if isResourceRunning("bank") then
		if exports.bank:getPlayerBankMoney(client, currency) < cost then
			exports.aw_interface_notify:alert (client, "ok", "Автосалон", "У вас недостаточно средств на банковском счету.", getTickCount(), 8000)
			--outputCarSystemError("У вас недостаточно средств на банковском счету.", client)
			return false
		end
	else
		if (getPlayerMoney(client) < cost) or (currency) then
			exports.aw_interface_notify:alert (client, "ok", "Автосалон", "У вас недостаточно средств.", getTickCount(), 8000)
			--outputCarSystemError("У вас недостаточно средств.", client)
			return false
		end
	end
	
	local accName = getAccountName(getPlayerAccount(client))
	if (not notSlottingCar[model]) and isResourceRunning("house") then
		local availableParkingLots = exports.house:getPlayerParkingLots(accName) --getElementData(client, "customSlots") or 0
		local usedParkingLots = getUsedParkLots(accName)
		if (usedParkingLots > availableParkingLots) then
			exports.aw_interface_notify:alert (client, "ok", "Автосалон", "Вы не можете купить больше "..(availableParkingLots+1).." машин.", getTickCount(), 8000)
			exports.aw_interface_notify:alert (client, "ok", "Автосалон", "У вас недостаточно парковочных мест.", getTickCount(), 8000)
			exports.aw_interface_notify:alert (client, "ok", "Автосалон", "В данный момент у вас "..usedParkingLots.." машин.", getTickCount(), 8000)
			return false
		end
	end

	if not isResourceRunning("mysql") then
		outputCarSystemError("Невозможно купить машину - системная ошибка. Сообщите об этом администратору.", client)
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot buy car - mysql is not active", 2)
		return false
	end
	
	if (getThisModelCarsCount(accName, model) > 10) then
		exports.aw_interface_notify:alert (client, "ok", "Автосалон", "У вас уже слишком много таких машин.", getTickCount(), 8000)
		--outputCarSystemError("У вас уже слишком много таких машин.", client)
		return false
	end

	local newID = getFreeID()
	if (not newID) then
		outputDebugString("[CAR-SYSTEM] Cannot getFreeID(): result="..tostring(newID), 1)
		return false
	end
	local color = table.concat({r1, g1, b1, r2, g2, b2}, ",")
	local fuel = math.random(10, 25)
	local paintjob = stockPaintjobs[model] or ""
	
	local vehicleType = getVehicleType(model)
	local licensePlate = generateNumberplate("a", region)
	if (vehicleType == "Bike") or (vehicleType == "Quad") or (vehicleType == "BMX") then
		licensePlate = generateNumberplate("c", region)
	end
	-- Остаются Automobile: Cars, vans and trucks, Plane, Train, Trailer: A trailer for a truck, Monster Truck
	local shop = shopTable[shopID] or {}

	exports.mysql:dbExec("vehicle", [[INSERT INTO ?? (ID, owner, model, x, y, z, rotZ, colors, upgrades, paintjob, HP, fuel, licensep, customTuning, fuelOctane, odometer, userOrder)
		VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);]],
		newID, accName, model, shop.spwnPosX, shop.spwnPosY, shop.spwnPosZ, shop.spwnRotZ, color, "", paintjob, 1000.0, fuel, licensePlate, toJSON({toner = {false, false, false}}, true), "92.0", math.random(0, 12), getNextUserOrderValue(accName)
	)
	if (model ~= 462) then
		exports.mysql:dbExec("handling", "REPLACE INTO ?? (ID, handling) VALUES(?, ?);", newID, "")
	end
	
	local moneyText = ""
	if isResourceRunning("bank") then
		exports.bank:takePlayerBankMoney(client, cost, currency)
		exports.aw_interface_notify:alert (client, "ok", "Автосалон", "Вы купили "..getVehicleModName(model).." за "..explodeNumber(cost)..currencyToSymbol(currency), 8000)
		--outputCarSystemInfo("Вы купили #цв#"..getVehicleModName(model).." #FFFFFFза #цв#"..explodeNumber(cost)..currencyToSymbol(currency), client)
		moneyText = string.format("bank %i%s", exports.bank:getPlayerBankMoney(client, currency), (currency or "RUB"))
	else
		takePlayerMoney(client, cost)
		outputCarSystemInfo("Вы купили #цв#"..getVehicleModName(model).." #FFFFFFза #цв#"..explodeNumber(cost).." руб.", client)
		moneyText = "money "..getPlayerMoney(client)
	end
	
	outputDebugString(string.format("[CAR-SHOP][BUY] %s (acc %s, %s) bought %s (%i, %s, %i) for %i", getPlayerName(client), accName,moneyText, getVehicleModName(model), newID,licensePlate,tostring(model), tostring(cost)))

	spawnVehicle(newID, client, false, true)
	updateVehicleInfo(client)
	
	return true
end
addEvent("onBuyNewVehicle", true)
addEventHandler("onBuyNewVehicle", resourceRoot, buyNewVehicle)

function getNextUserOrderValue(owner)
	local order = exports.mysql:dbQuery(-1, "vehicle", "SELECT MAX(userOrder)+1 AS `order` FROM ?? WHERE owner=?", owner)
	return order and order[1] and order[1].order or 1
end

-- Получение количества машин данной модели
function getThisModelCarsCount(accName, model)
	local count = exports.mysql:dbQuery(-1, "vehicle", "SELECT COUNT(ID) AS count FROM ?? WHERE owner = ? AND model = ?", accName, model)
	return count and count[1] and count[1].count or 0
end

-- Получение свободного ID машины
function getFreeID()
	local result = exports.mysql:dbQuery(-1, "vehicle", "SELECT * FROM ??")
	local id = nil
	for i, v in ipairs (result) do
		if i ~= v["ID"] then
			id = i
			break
		end
	end
	if not id then id = #result + 1 end
	return id
end

-- Генерация номера по заданному шаблону
function generateNumberplate(plateType, selectedRegion)
	local licCh = {"a", "b", "e", "k", "m", "h", "o", "p", "c", "t", "y", "x"}
	local licReg = {50,150,750, 77,177,777, 90,190,790, 97,197,797, 99,199,799}
	local newPlate
	if (not plateType) or (plateType == "a") then
		repeat
			local region = selectedRegion or licReg[math.random(#licReg)]
			if (region < 100) then
				newPlate = string.format("a-%s%i%i%i%s%s%02i", licCh[math.random(#licCh)], math.random(0,9), math.random(0,9), math.random(0,9), licCh[math.random(#licCh)], licCh[math.random(#licCh)], region)
			else
				newPlate = string.format("a-%s%i%i%i%s%s%03i", licCh[math.random(#licCh)], math.random(0,9), math.random(0,9), math.random(0,9), licCh[math.random(#licCh)], licCh[math.random(#licCh)], region)
			end
		until (not nomerIs000(newPlate)) and (not checkNomerExistance(newPlate)) and (not nomerIsPHA(newPlate)) -- Истина - выход из цикла
		return newPlate
		
	elseif (plateType == "b") then
		return string.format("b-%s%i%i%i%i%02i", licCh[math.random(#licCh)], math.random(0,9), math.random(0,9), math.random(0,9), math.random(0,9), string.sub(licReg[math.random(#licReg)], -2, -1))
		
	elseif (plateType == "c") then
		repeat
			local region = string.sub( (selectedRegion or licReg[math.random(#licReg)]), -2, -1)
			newPlate = string.format("c-%i%i%i%i%s%s%02i", math.random(0,9), math.random(0,9), math.random(0,9), math.random(0,9), licCh[math.random(#licCh)], licCh[math.random(#licCh)], region)
		until (not nomerIs0000(newPlate)) and (not checkNomerExistance(newPlate)) -- Истина - выход из цикла
		return newPlate
		
	elseif (plateType == "i") then
		return "i-"..licCh[math.random(#licCh)]..licCh[math.random(#licCh)]..math.random(0,9)..math.random(0,9)..math.random(0,9)..string.sub(licReg[math.random(#licReg)], -2, -1)
		
	elseif (plateType == "boat") then
		return "h-Boat"
		
	elseif (plateType == "helicopter") then
		return "h-Helicopter"
		
	end
end
function nomerIs000(plate)
	return (tonumber( string.sub(plate, 4, 6) ) == 0)
end
function nomerIs0000(plate)
	return (tonumber( string.sub(plate, 3, 6) ) == 0)
end
function nomerIsPHA(plate)
	return (string.sub(plate, 3, 3) == "p") and (string.sub(plate, 7, 7) == "h") and (string.sub(plate, 8, 8) == "a")
end

-- Проверка на наличие номера
function checkNomerExistance(nomer)
	local data = exports.mysql:dbQuery(-1, "vehicle", "SELECT licensep, owner, model FROM ?? WHERE licensep = ?;", nomer) or {}
	
	if isResourceRunning("car_usedauto") then
		local _, dataFrom = exports.car_usedauto:checkNomerExistance(nomer)
		for _, row in ipairs(dataFrom) do
			row.usedauto = true
			table.insert(data, row)
		end
	end
	if isResourceRunning("car_nomerchange") then
		local _, dataFrom = exports.car_nomerchange:checkNomerExistance(nomer)
		for _, row in ipairs(dataFrom) do
			table.insert(data, row)
		end
	end
	
	return (#data > 0), data
end

-- ==========     Покупка машины с б/у рынка     ==========
function BuyVehicleByUsed(player, data, position)
	local accName = getAccountName(getPlayerAccount(player))

	if isResourceRunning("bank") then
		if (exports.bank:getPlayerBankMoney(player, "RUB") < data.price) then
			outputCarSystemError("У вас недостаточно средств на рублёвом банковском счету.", player)
			return false
		end
	else
		if (getPlayerMoney(player) < data.price) then
			outputCarSystemError("У вас недостаточно средств.", player)
			return false
		end
	end
	
	if not isResourceRunning("mysql") then
		outputCarSystemError("Невозможно купить машину - системная ошибка. Сообщите об этом администратору.", client)
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot buy used car - mysql is not active", 2)
		return
	end
	
	if (getThisModelCarsCount(accName, data.model) > 1) then
		outputCarSystemError("У вас уже слишком много таких машин.", player)
		return false
	end
	
	if (not notSlottingCar[data.model]) and isResourceRunning("house") then
		local availableParkingLots = exports.house:getPlayerParkingLots(accName)+(tonumber(getElementData(player, "customSlots")) or 0) --getElementData(client, "customSlots") or 0
		local usedParkingLots = getUsedParkLots(accName)
		if (usedParkingLots > availableParkingLots) then
			outputCarSystemError("Вы не можете купить больше "..(availableParkingLots+1).." машин.", player)
			outputCarSystemError("У вас недостаточно парковочных мест.", player)
			outputCarSystemError("В данный момент у вас "..usedParkingLots.." машин.", player)
			return false
		end
	end
	
	local newID = getFreeID()
	if (not newID) then
		outputDebugString("[CAR-SYSTEM] Cannot getFreeID(): result="..tostring(newID), 1)
		return false
	end
	data.fuelOctane = tonumber(data.fuelOctane) or 92.0
	
	exports.mysql:dbExec("vehicle", [[INSERT INTO ?? (ID, owner, model, x, y, z, rotZ, colors, upgrades, paintjob, HP, fuel, licensep, customTuning, fuelOctane, odometer, userOrder)
		VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);]],
		newID, accName, data.model, position.x, position.y, position.z, position.rotZ, data.colors, data.upgrades, data.paintjob, 1000, math.random(10, 25), data.licensep, data.customTuning, data.fuelOctane, data.odometer, getNextUserOrderValue(accName)
	)
	exports.mysql:dbExec("handling", "REPLACE INTO ?? (ID, handling) VALUES(?, ?);", newID, data.handling)
	
	local moneyText = ""
	if isResourceRunning("bank") then
		exports.bank:takePlayerBankMoney(player, data.price, "RUB")
		outputCarSystemInfo("Вы купили #цв#"..getVehicleModName(data.model).." #FFFFFFза #цв#"..explodeNumber(data.price).." руб.", player)
		moneyText = "bank "..exports.bank:getPlayerBankMoney(player, "RUB").."RUB"
	else
		takePlayerMoney(player, data.price)
		outputCarSystemInfo("Вы купили #цв#"..getVehicleModName(data.model).." #FFFFFFза #цв#"..data.price.." руб.", player)
		moneyText = "money "..getPlayerMoney(player)
	end
	
	outputDebugString(string.format("[CAR-SHOP][BUY_USED] %s (acc %s, %s) bought %s (%i, %s, %i) for %i from used carshop",
		getPlayerName(player), accName,moneyText, getVehicleModName(data.model), newID,data.licensep,data.model, data.price))

	spawnVehicle(newID, player, false, true)
	setElementInterior(player, 0)
	setElementDimension(player, 0)

	updateVehicleInfo(player)
	return true	
end

-- ==========     Продажа машины на б/у рынок     ==========
function sellVehicle(id, money)
	if isResourceRunning("mysql") then
		local secondTableName = exports.mysql:getTableName("handling")
		local callbackArguments = {
			player = client,
			id = id,
			money = math.floor(money),
			vehicle = getVehicleByID(id)
		}
		if isElement(callbackArguments.vehicle) then
			saveCarData(vehicle)
		end
		exports.mysql:dbQueryAsync("sellVehicleCallback", callbackArguments, "vehicle", "SELECT * FROM ?? AS veh LEFT JOIN ?? AS han ON (veh.ID = han.ID) WHERE veh.ID = ?;", secondTableName, id)
	else
		outputCarSystemError("Невозможно продать машину - системная ошибка. Сообщите об этом администратору.", client)
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot sell car - mysql is not active", 2)
	end
end
local vehicleIsSold = {}
function sellVehicleCallback(result, args)
	if not isElement(args.player) then return end
	if (not result) or (#result < 1) then
		outputCarSystemError("Возникла проблема с транспортом id "..tostring(args.id)..", сообщите об этом администратору.", args.player)
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot sell car - problem with id "..tostring(args.id), 2)
		return
	end
	
	result = result[1]
	if not checkCarInColshape(args.vehicle, result, args.player) then return end
	
	result.model = tonumber(result.model)
	local accName = getAccountName(getPlayerAccount(args.player))
	if (result.owner ~= accName) then
		outputCarSystemError("Возникла проблема с продажей транспорта id "..tostring(args.id)..", сообщите об этом администратору.", args.player)
		outputDebugString(string.format("[CAR_SYSTEM][ERROR] Cannot sell car - owner does not match: %s (acc %s money %s) car %s (%i, %s, %i, owner %s) price %i",
			getPlayerName(args.player), accName,getPlayerMoney(args.player), getVehicleModName(result.model), tostring(args.id),result.licensep,result.model,result.owner, tostring(args.money)), 1)
		return
	end
	
	if (vehicleIsSold[args.id]) then
		outputDebugString(string.format("[CAR_SYSTEM][ERROR] Cannot sell car - it is already sold: %s (acc %s money %s) car %s (%i, %s, %i, owner %s) price %i",
			getPlayerName(args.player), accName,getPlayerMoney(args.player), getVehicleModName(result.model), tostring(args.id),result.licensep,result.model,result.owner, tostring(args.money)), 1)
		return
	end
	
	if (tostring(result.flag) == "donate") or (tostring(result.flag) == "police") then
		outputCarSystemError("Вы не можете продать этот автомобиль.", args.player)
		return
	end
	
	local _, _, minPrice, maxPrice = getAllSellingPrices(result.model)
	if (not minPrice) then
		outputCarSystemError("Невозможно продать автомобиль. Банковские операции недоступны.", args.player)
		return
	end
	if (args.money < minPrice) then
		outputCarSystemError("Нельзя поставить цену меньше "..minPrice.." руб.")
		return
	end
	if (args.money > maxPrice) then
		outputCarSystemError("Нельзя поставить цену больше "..maxPrice.." руб.")
		return
	end
	if overPricedCar[result.model] then
		args.money = 0
	end

	if isElement(args.vehicle) then destroyVehicle(args.vehicle) end
	if (not notSoldableCar[result.model]) and (not overPricedCar[result.model]) and (not isBoat[result.model]) and (not isHeli[result.model]) and isResourceRunning("car_usedauto") then
		if (args.money*1.2 >= 100000) then
			result.handling = result.handling or ""
			exports.car_usedauto:addCarToUsedShop(result, math.floor(args.money*1.2), args.player)
		else
			outputCarSystemWarning("Внимание! Б/у автосалон не выставляет на продажу автомобили дешевле #цв#100 000 рублей#FFFFFF.", args.player)
		end
	end	

	exports.mysql:dbExec("vehicle", "DELETE FROM ?? WHERE ID = ?", args.id)
	exports.mysql:dbExec("handling", "DELETE FROM ?? WHERE ID = ?", args.id)

	exports.bank:givePlayerBankMoney(args.player, args.money, "RUB")
	outputCarSystemInfo("Вы продали Ваш транспорт за #цв#"..explodeNumber(args.money).." руб#FFFFFF. Деньги переведены на ваш банковский счет.", args.player)
	
	outputDebugString(string.format("[CAR-SHOP][SELL] %s (acc %s bank %s) sold %s (%i, %s, %i) for %i",
		getPlayerName(args.player), accName,exports.bank:getPlayerBankMoney(args.player, "RUB"), getVehicleModName(result.model), (result.ID or args.id),result.licensep,result.model, args.money))

	updateVehicleInfo(args.player)
	
	vehicleIsSold[args.id] = true
	setTimer(removeVehicleFromSold, 60000, 1, args.id)
end
addEvent("SellMyVehicle", true)
addEventHandler("SellMyVehicle", resourceRoot, sellVehicle)

function removeVehicleFromSold(id)
	vehicleIsSold[id] = nil
end

function getVehicleByID(id)
	return vehiclesByID[ tonumber(id) ]
end

function checkCarInColshape(vehicle, carData, player)
	if not isElementWithinColShape(player, colshapes.usedauto) then
		outputCarSystemError("Невозможно продать автомобиль. Вы должны находиться на б/у рынке.", player)
		return false
	end
	if isElement(vehicle) then
		if not isElementWithinColShape(vehicle, colshapes.usedauto) then
			outputCarSystemError("Невозможно продать автомобиль. Его нужно пригнать на б/у рынок.", player)
			return false
		end
	else
		local colX, colY = getElementPosition(colshapes.usedauto)
		if (getDistanceBetweenPoints2D(colX, colY, carData.x, carData.y) > 75) then
			outputCarSystemError("Невозможно продать автомобиль. Его нужно пригнать на б/у рынок.", player)
			return false
		end
	end
	return true
end

-- ==========     Установка блипа на машину     ==========
function blipMyVehicle(id)
	local vehicle = vehiclesByID[id]
	if not isElement(vehicle) then
		outputCarSystemInfo("Ваш транспорт #FF0000не заспавнен", client)
		return
	end
	if not getElementData(vehicle, "ABlip") then
		setElementData(vehicle, "ABlip", true)
		createBlipAttachedTo(vehicle, 41, 2, 255, 0, 0, 255, 0, 65535, client)
		outputCarSystemInfo("Ваш транспорт отмечен на карте. Используйте F11 чтобы найти его.", client)
	else
		local attached = getAttachedElements(vehicle)
		if (attached) then
			for k,element in ipairs(attached) do
				if getElementType(element) == "blip" then
					destroyElement(element)
				end
			end
		end
		setElementData(vehicle, "ABlip", false)
		outputCarSystemInfo("С вашего транспорта снят маркер.", client)
	end
end
addEvent("BlipMyVehicle", true)
addEventHandler("BlipMyVehicle", resourceRoot, blipMyVehicle)

-- ==========     Фриз машины     ==========
function freezeMyVehicle(id, houseData)
	local vehicle = vehiclesByID[id]
	if not isElement(vehicle) then
		outputCarSystemInfo("Ваш транспорт #FF0000не заспавнен", client)
		return
	end
	if isElementFrozen ( vehicle ) then
		setElementFrozen ( vehicle, false )
		setVehicleDamageProof(vehicle, false)
		setVehicleEngineState ( vehicle, true )
		outputCarSystemInfo("Движение вашего транспорта #00FF00разрешено", client)
	else
		-- if getAccountData(getPlayerAccount(client), "car-system.cannotFreezeCar") then
			-- outputCarSystemError("Ты не можешь блокировать свой автомобиль!", client)
			-- return
		-- end
		local carX,carY,carZ = getElementPosition(vehicle)
		local sx, sy, sz = getElementVelocity(vehicle)
		local speed = math.floor(((sx^2 + sy^2 + sz^2)^(0.5))*180)
		if speed > 5 then
			outputCarSystemInfo("Остановите машину перед блокировкой.", client)
		elseif (getDistanceToNearestHouse(houseData, carX,carY,carZ) > 50) then
			outputCarSystemInfo("Блокировать машину можно только возле дома.", client)
		-- elseif (getElementModel(vehicle) == 462) then
			-- outputCarSystemInfo("Мопед блокировать нельзя.", client)
		else
			setElementFrozen ( vehicle, true )
			setVehicleDamageProof(vehicle, true)
			setVehicleEngineState ( vehicle, false )
			outputCarSystemInfo("Движение вашего транспорта #00FF00заблокировано", client)
		end
	end
end
addEvent("FreezeMyVehicle", true)
addEventHandler("FreezeMyVehicle", resourceRoot, freezeMyVehicle)

function getDistanceToNearestHouse(houseData, x,y,z)
	local minimalDist = 300
	for _, house in ipairs(houseData) do
		local dist = getDistanceBetweenPoints3D(house.x, house.y, house.z, x,y,z)
		if (not minimalDist) or (dist < minimalDist) then
			minimalDist = dist
		end
	end
	return minimalDist
end

-- ==========     Закрытие дверей машины     ==========
addEvent("LockMyVehicle", true)
addEventHandler("LockMyVehicle", resourceRoot, function(id)
	local vehicle = vehiclesByID[id]
	if not isElement(vehicle) then
		outputCarSystemInfo("Ваш транспорт #FF0000не заспавнен", client)
		return
	end
	local x,y,z = getElementPosition(client)
	local carX,carY,carZ = getElementPosition(vehicle)
	if (getDistanceBetweenPoints3D(x,y,z, carX,carY,carZ) > 100) then
		outputCarSystemError("Ваша машина слишком далеко.", client)
		return
	end
	local wasLocked = isVehicleLocked(vehicle)
	if not wasLocked then
		setVehicleLocked(vehicle, true)
		setVehicleDoorsUndamageable(vehicle, true)
		setVehicleDoorState(vehicle, 0, 0)
		setVehicleDoorState(vehicle, 1, 0)
		setVehicleDoorState(vehicle, 2, 0)
		setVehicleDoorState(vehicle, 3, 0) 
		outputCarSystemInfo("Ваш транспорт закрыт.", client)
	else
		setVehicleLocked(vehicle, false)
		setVehicleDoorsUndamageable(vehicle, false)
		outputCarSystemInfo("Ваш транспорт открыт.", client)
	end
	if isResourceRunning("car_movparts") then
		exports.car_movparts:setVehicleMovpartsState(client, vehicle, wasLocked)
	end
end)

-- ==========     Сброс хандлинга     ==========
function resetVehicleHandling(id)
	local vehicle = vehiclesByID[id]
	local destroy, vehModel = false
	if isElement(vehicle) then
		if getElementData(vehicle, "job_taxi.isTaxi") then
			outputCarSystemError("Вы не можете респавнить данное транспортное средство, так как  оно используется в такси.", client)
			return
		end
		vehModel = getElementModel(vehicle)
		destroyVehicle(vehicle)
		destroy = true
	end
	if not isResourceRunning("mysql") then
		outputCarSystemError("Невозможно сбросить хандлинг - системная ошибка. Сообщите об этом администратору.", client)
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot reset handling - mysql is not active", 2)
		return
	end
	exports.mysql:dbExec("handling", "UPDATE ?? SET handling = ? WHERE ID = ?;", "", id)
	if destroy then
		outputCarSystemInfo("Вы успешно сбросили настройки этого авто.", client)
		spawnVehicle(id, client, false, false)
	else
		outputCarSystemInfo("Вы успешно сбросили настройки этого авто.", client)
	end
end
addEvent("ResetVehicleHandling", true)
addEventHandler("ResetVehicleHandling", resourceRoot, resetVehicleHandling)

-- ==========     Телепорт машины     ==========
function warpMyVehicle(id, warpMe)
	if isPedInVehicle(client) then
		outputCarSystemError("Не можем пригнать ваш транспорт. Пожалуйста, выйдите из другого транспорта.", client)
		return
	end		
	if (getElementInterior(client) ~= 0) then
		outputCarSystemError("Невозможно пригнать автомобиль внутрь здания.", client)
		return
	end
	local vehicle = vehiclesByID[id]
	if isElement(vehicle) then
		if getElementData(vehicle, "hasIllegalItems") then
			outputCarSystemError("Вы не можете телепортировать данное транспортное средство, так как в нем находятся незаконные предметы", client)
			return
		end
		for _, player in pairs(getVehicleOccupants(vehicle)) do
			if getElementData(player, "isChased") then
				outputCarSystemError("Вы не можете телепортировать данное транспортное средство, так как в нем сидит игрок, за которым ведется погоня", client)
				return
			end
		end
		local x, y, z = getElementPosition(client)
		if (getDistanceBetweenPoints2D(x,y, teleportBlockCoords.x, teleportBlockCoords.y) < teleportBlockCoords.radius) then
			outputCarSystemError("Невозможно доставить автомобиль на охраняемую территорию.", client)
			return
		end
		if getElementData(vehicle, "job_taxi.isTaxi") then
			local carX, carY, carZ = getElementPosition(vehicle)
			if getDistanceBetweenPoints3D(x, y, z, carX, carY, carZ) > 50 then
				outputCarSystemError("Вы не можете телепортировать данное транспортное средство, так как оно используется в такси и находится слишком далеко.", client)
				return
			end
		end
		if getDistanceBetweenPoints3D (Vector3(getElementPosition (vehicle)), Vector3(getElementPosition (client))) > 200 or warpMe then
			local _,_,rotz = getElementRotation ( client, "ZYX" )
			setElementFrozen ( vehicle, false )
			setVehicleDamageProof(vehicle, false)
			setElementRotation ( vehicle, 0, 0, rotz+90, "ZYX")
			local dist = 3.5
			rotz = math.rad(rotz+90)
			x = x+3.5*math.cos(rotz)
			y = y+3.5*math.sin(rotz)
			setElementPosition(vehicle, x, y, z+1.0)
		--	exports.aw_interface_notify:alert (client, "ok", "Автосалон", "Ваш транспорт доставлен к вам.", 8000)
			exports.aw_interface_notify:showInfobox(client,"info", "Личный транспорт", "Ваш транспорт доставлен к вам.", getTickCount(), 8000)
			--outputCarSystemInfo("Ваш транспорт #цв#"..getVehicleModName(getElementModel(vehicle)).."#FFFFFF доставлен к вам.", client)
		end
	else
		outputCarSystemInfo("Транспорт #FF0000не заспавнен", client)
	end
end
addEvent("WarpMyVehicle", true)
addEventHandler("WarpMyVehicle", resourceRoot, warpMyVehicle)

-- ==========     Убирание машин при выходе игрока, при стопе ресурса     ==========
function onPlayerQuit()
	if isResourceRunning("mysql") then
		exports.mysql:dbQueryAsync("onPlayerQuitCallback", {}, "vehicle", "SELECT ID FROM ?? WHERE owner = ?", getAccountName(getPlayerAccount(source)))
	else
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot get list of cars to destroy - mysql is not active", 2)
	end
end
function onPlayerQuitCallback(result, args)
	for _, row in ipairs(result) do
		destroyVehicle(vehiclesByID[row.ID])
	end
end
addEventHandler("onPlayerQuit", root, onPlayerQuit)

function saveAllVehicles() 
	for i, veh in ipairs(getElementsByType("vehicle")) do
		if getElementData(veh, "ID") then
			saveCarData(veh)
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, saveAllVehicles)

-- ==========     Смена номера через внешний ресурс     ==========
function changeNomer(ID, newNomer, player)
	if isResourceRunning("mysql") then
		exports.mysql:dbExec("vehicle", "UPDATE ?? SET licensep = ? WHERE ID = ?", newNomer, ID)
		if player then
			updateVehicleInfo(player)
		end
	else
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot changeNomer() - mysql is not active", 2)
		return false
	end
end


function removeExplodedVeh()
	if isElement(source) then
		if getElementData(source, "doNotRemoveThisCarOnTimeout") then
			setTimer(respawnVehicle, 5000, 1, source)
		else
			setTimer(checkRemove, 60000, 1, source)
		end
	end
end
addEventHandler("onVehicleExplode", root, removeExplodedVeh)
function checkRemove(veh)
	if isElement(veh) and isVehicleBlown(veh) then
		destroyElement(veh)
	end
end

function onVehicleEnter()
	if getElementHealth(source) <= 255 then 
		setVehicleEngineState(source, false)
	else
		if isVehicleDamageProof(source) then
			setVehicleDamageProof(source, false)
		end
	end
end
addEventHandler("onVehicleEnter", resourceRoot, onVehicleEnter)






function checkCarAbilityToSellToPlayer(vehicle, carData, player)
	if (not vehicle) then vehicle = vehiclesByID[ carData[1].ID ] end
	if not isElementWithinColShape(player, colshapes.nomerchange) then
		outputCarSystemError("Невозможно продать автомобиль. Вы должны находиться в центре перерегистрации.", player)
		return false
	end
	if isElement(vehicle) then
		if not isElementWithinColShape(vehicle, colshapes.nomerchange) then
			outputCarSystemError("Невозможно продать автомобиль. Его нужно пригнать к центру перерегистрации.", player)
			return false
		end
	else
		local colX, colY = 1378.286133, 727.662109
		if (getDistanceBetweenPoints2D(colX, colY, carData[1].X, carData[1].Y) > 75) then
			outputCarSystemError("Невозможно продать автомобиль. Его нужно пригнать к центру перерегистрации.", player)
			return false
		end
	end
	return true
end


--	==========     Контроль за машинами, чтобы они не взрывались     ==========
local lowHPcars = {}
setTimer(function()
	for vehicle, _ in pairs(lowHPcars) do
		if isElement(vehicle) then
			if (getElementHealth(vehicle) > 256) then
				setVehicleDamageProof(vehicle, false)
				lowHPcars[vehicle] = nil
			else
				local rotX = getElementRotation(vehicle)
				if (rotX < 90) or (rotX > 270) then
					setVehicleDamageProof(vehicle, false)
					lowHPcars[vehicle] = nil
				end
			end
		else
			lowHPcars[vehicle] = nil
		end
	end
	for _, vehicle in ipairs(getElementsByType("vehicle", resourceRoot)) do
		if (getElementHealth(vehicle) < 256) then
			setElementHealth(vehicle, 256)
			setVehicleDamageProof(vehicle, true)
			setVehicleEngineState(vehicle, false)
			lowHPcars[vehicle] = true
			for _, occupant in pairs(getVehicleOccupants(vehicle)) do
				if getElementData(occupant, "isChased") or getElementData(occupant, "isChasing") then
					setElementData(vehicle, "isBroken", true)
				end
			end
		end
	end
end, 1000, 0)


function clrparking()
	local clrCars, pzdCars = 0, 0
	local clrTime = getTickCount()
	for _, colShape in pairs(colshapes) do
		local vehTable = getElementsWithinColShape(colShape, "vehicle")
		for _, veh in ipairs(vehTable) do
			if (not getVehicleOccupant(veh)) and getElementData(veh, "ID") then 
				destroyVehicle(veh)
				clrCars = clrCars + 1
			end
		end
	end
	local pzdTime = getTickCount()
	clrTime = pzdTime - clrTime
	for i, veh in ipairs (getElementsByType("vehicle", resourceRoot)) do
		local model = getElementModel(veh)
		if ((model == 445) or (model == 462)) and (not getVehicleOccupant(veh)) and (not getElementData(veh, "doNotRemoveThisCarOnTimeout")) then
			destroyVehicle(veh)
			pzdCars = pzdCars + 1
		end
	end
	local garbTime = getTickCount()
	pzdTime = garbTime - pzdTime
	local garbage = collectgarbage("count")
	collectgarbage()
	garbage = math.floor(garbage - collectgarbage("count"))
	garbTime = getTickCount() - garbTime
	outputDebugString("[CARSYSTEM] Clearparking "..clrCars.." cars "..clrTime.." ms, pzd "..pzdCars.." cars "..pzdTime.." ms, collectgarbage "..garbage.."KB "..garbTime.." ms")
end
setTimer(clrparking, 600000, 0)

function setNomer(player,_,nomer)
	if (not nomer) or (nomer=="") then
		outputCarSystemError("Cинтаксис таков: '/SetNomer <nomer>'", player)
		return
	end
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then
		outputCarSystemError("Ты должен сидеть в машине для которой делаешь номер!", player)
		return
	end
	local id = getElementData(vehicle, "ID")	
	if not id then
		outputCarSystemError("Ты должен сидеть в личной машине!", player)
		return
	end
	setElementData(vehicle, "licensep", nomer)
	local owner = getElementData(vehicle, "owner")
	if isResourceRunning("mysql") then
		local data = exports.mysql:dbQuery(-1, "vehicle", "SELECT ID FROM ?? WHERE ID = ?", id)
		if type(data) == "table" and #data ~= 0 then
			exports.mysql:dbExec("vehicle", "UPDATE ?? SET licensep = ? WHERE ID = ?", nomer, id)
			outputDebugString("[CAR-SYSTEM][MANUALNOMERCHANGE] "..getPlayerName(player).." changed nomer to "..nomer.." on "..getVehicleModName(vehicle).." ("..getElementModel(vehicle)..", owner "..owner..")")
		end
		updateVehicleInfo(getAccountPlayer(getAccount(owner)))
	else
		outputDebugString("[CAR_SYSTEM][WARNING] Cannot setnomer - mysql is not active", 2)
	end
end
addCommandHandler("setnomer", setNomer, true, false)

function setRamka(player, _, ramka)
	if (not ramka) or (ramka=="") then
		outputCarSystemError("Cинтаксис таков: '/setramka <ramka>'", player)
		return
	end
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then
		outputCarSystemError("Ты должен сидеть в машине, на которую ставишь рамку!", player)
		return
	end
	local id = getElementData(vehicle, "ID")	
	if not id then
		outputCarSystemError("Ты должен сидеть в личной машине!", player)
		return
	end
	setElementData(vehicle, "licence_frame", ramka)
	local owner = getElementData(vehicle, "owner")
	outputDebugString("[CAR-SYSTEM][CHANGE_RAMKA] "..getPlayerName(player).." changed ramka to "..ramka.." on "..getVehicleModName(vehicle).." ("..getElementModel(vehicle)..", owner "..tostring(owner)..")")
	triggerClientEvent("forceUpdateVehicleComponents", vehicle)
end
addCommandHandler("setramka", setRamka, true, false)




function getDataOnLogin()
	updateVehicleInfo(source)	
end
addEventHandler("onPlayerLogin", root, getDataOnLogin)


--	==========     Функции для полиции     ==========
-- Добавляет полиц. машину игроку в F3
function addPoliceCar(player, model)
	if not isElement(player) then return end
	local accName = getAccountName(getPlayerAccount(player))
	exports.mysql:dbQueryAsync("addPoliceCarCallback", {player=player, accName=accName, model=model}, "vehicle", "SELECT `ID` FROM ?? WHERE `owner` = ? AND `model` = ? AND `flag` = 'police';", accName, model)
end
function addPoliceCarCallback(result, args)
	if isElement(args.player) and (result) and (#result == 0) then
		local newID = getFreeID()
		local licensep = generateNumberplate("b")
		exports.mysql:dbExec("vehicle", [[INSERT INTO ?? (ID, owner, model, x, y, z, rotZ, colors, upgrades, paintjob, HP, fuel, licensep, customTuning, fuelOctane, odometer, userOrder, flag)
			VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);]],
			newID, args.accName, args.model, 5000.0,5000.0,0.0,0.0, "255,255,255,255,255,255", "interiorparts,1", "f90_police", 1000, 80,
			licensep, toJSON({toner = {false, false, false}}, true), 98.0, math.random(15000), getNextUserOrderValue(args.accName), "police"
		)
		exports.mysql:dbExec("handling", "REPLACE INTO ?? (ID, handling) VALUES(?, ?);", newID, "")
		updateVehicleInfo(args.player)
	end
end

addCommandHandler("givecar", 
function(player, cmd, target, model, paintjob)
	local accName = getAccountName(getPlayerAccount(player))
	if not isObjectInACLGroup ("user."..accName, aclGetGroup("GLAdmin")) then
    --or isObjectInACLGroup("user."..accName,aclGetGroup("Moderator")) then
		outputChatBox("Вы не имеете доступа к данной команде!", player, 255, 0, 0)
		return
	end
	paint = paintjob or nil
	if target then
		if tonumber(model) then
			local targetplayer = getPlayerFromName(target)
			if targetplayer then
              --  givePlayerMoney(targetplayer,amount)
                exports.car_system:addBase(targetplayer, model, paint)
				outputChatBox(getPlayerName(player).." выдал вам машину в F3", targetplayer, 0, 255, 0, true)
				outputChatBox("Вы успешно выдали машину. игроку в F3 "..getPlayerName(targetplayer).."!", player, 0, 255, 0, true)
			else
				outputChatBox("Игрок не найден.", player, 255, 0, 0)
			end
		else
			outputChatBox("Используйте: /givecar [Ник] [ID Машины] можно [Винил]", player, 255, 0, 0)
		end
	else 
		outputChatBox("Используйте: /givecar [Ник] [ID Машины] можно [Винил]", player, 255, 0, 0)
	end
end)

--[Функции выдачи донат авто]--
function DonateAuto(arg, model)
	local player = nil
	local accName = nil
	if type(arg) == "string" then
		if not getAccount (arg) then return "Такого аккаунта нет" end
		player = getAccountPlayer (getAccount(arg))
		accName = arg
	else
		player = arg
		accName = getAccountName (getPlayerAccount(arg))
	end
	--local res = exports.mysql:dbQueryAsync("addDonateCarCallback", {player=player, accName=accName, model=model}, "vehicle", "SELECT `ID` FROM ?? WHERE `owner` = ? AND `model` = ? AND `flag` = 'donate';", accName, model)
	local res = addDonateCarCallback (nil, {player=player, accName=accName, model=model})
	return res
end

local donateCars = {
	[412] = true,
	[419] = true,
	[562] = true,
	[459] = true,
	[474] = true,
	[491] = true,
	[545] = true,
	[413] = true,
	[528] = true,
	[466] = true,
	[405] = true,
	[599] = true,
	[453] = true,
}

function addDonateCarCallback(result, args)
	--if (result) and (#result == 0) then
		local newID = getFreeID()
		local licensep = generateNumberplate("a")
		
		-- local 
		
		exports.mysql:dbExec("vehicle", [[INSERT INTO ?? (ID, owner, model, x, y, z, rotZ, colors, upgrades, paintjob, HP, fuel, licensep, customTuning, fuelOctane, odometer, userOrder, flag)
			VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);]],
			newID, args.accName, args.model, 5000.0,5000.0,0.0,0.0, "255,255,255,255,255,255", "", "", 1000, 80,
			licensep, toJSON({toner = {false, false, false}}, true), 98.0, math.random(15000), getNextUserOrderValue(args.accName), donateCars[args.model] and "donate" or ""
		)
		exports.mysql:dbExec("handling", "REPLACE INTO ?? (ID, handling) VALUES(?, ?);", newID, "")
		if args.player and isElement (args.player) then updateVehicleInfo(args.player) end
		return "Автомобиль успешно выдан!"
	--end
end

-- Убирает полицейские машины по окончанию смены
function destroyPoliceCar(accName)
	exports.mysql:dbQueryAsync("destroyPoliceCarCallback", {}, "vehicle", "SELECT `ID` FROM ?? WHERE `flag` = 'police' AND `owner` = ?;", accName)
end
function destroyPoliceCarCallback(result, args)
	for _, row in ipairs(result) do
		local vehicle = vehiclesByID[row.ID]
		if isElement(vehicle) then
			destroyVehicle(vehicle)
		end
	end
end


function getPlayerForAcc(acc)
	for i, v in ipairs(getElementsByType("player")) do
		if getElementData(v, "LOGIN") == acc then
			return v
		end
	end
	return false
end

-- // Для аукциона
function giveVehicleAccForID(ID, acc, owner)
	exports.mysql:dbExec("vehicle", "UPDATE ?? SET owner = ?, userOrder = ? WHERE ID = ?", acc, getNextUserOrderValue(acc), ID)
	if getPlayerForAcc(acc) then
		updateVehicleInfo(getPlayerForAcc(acc))
	end
	if getPlayerForAcc(owner) then
		updateVehicleInfo(getPlayerForAcc(owner))
	end
end

-- // Удаляем авто, если оно заспавнено
function delCar(ID)
	local vehicle = vehiclesByID[ID]
	if isElement(vehicle) then
		destroyVehicle(vehicle)
	end
end



-- Удаляет полицейские машины
function removePoliceCar(player, accName)
	exports.mysql:dbQueryAsync("removePoliceCarCallback", {player=player, accName=accName}, "vehicle", "SELECT `ID`, `model`, `licensep` FROM ?? WHERE `flag` = 'police' AND `owner` = ?;", accName)
end
function removePoliceCarCallback(result, args)
	if (result) and (#result > 0) then
		local tbl = {}
		for _, row in ipairs(result) do
			table.insert(tbl, row.ID)
			local vehicle = vehiclesByID[row.ID]
			if isElement(vehicle) then
				destroyVehicle(vehicle)
			end
		end
		exports.mysql:dbExec("vehicle", "DELETE FROM ?? WHERE `ID` IN ("..table.concat(tbl, ",")..");")
		exports.mysql:dbExec("handling", "DELETE FROM ?? WHERE `ID` IN ("..table.concat(tbl, ",")..");")
		if isElement(args.player) then
			updateVehicleInfo(args.player)
		end
		outputDebugString(string.format("[CARSYSTEM] Removed %i police cars for account %s. Car data: %s",
			#result, args.accName, toJSON(result, true)
		))
	end
end

-- Отдает список игроков, имеющих полицейские машины
function getPoliceCarOwners()
	exports.mysql:dbQueryAsync("getPoliceCarOwnersCallback", {}, "vehicle", "SELECT DISTINCT `owner` FROM ?? WHERE `flag` = 'police';")
end
function getPoliceCarOwnersCallback(result, args)
	local tbl = {}
	for _, row in ipairs(result) do
		table.insert(tbl, row.owner)
	end
	exports.police_ccd:catchPoliceCarOwners(tbl)
end


--	==========     Информационные сообщения     ==========
local serverNumber = tonumber(exports.config:getCCDPlanetNumber() or 0)

local colors = {
	[0] = "#1e8190",
	[1] = "#1e8190",
	[2] = "#c19800",
}

function outputCarSystemInfo(text, player)
	if isResourceRunning ("aw_interface_notify") then
	--	exports.aw_interface_notify:addaw_interface_notify (player, "Автосалон", text:gsub("#цв#", colors[serverNumber]))
			--	exports.aw_interface_notify:showInfobox(source,"info", "Администрация", "Успешная покупка", getTickCount(), 8000)
	else
		outputChatBox("[Автосалон] #58FAF4"..text:gsub("#цв#", "#58FAF4"), player, 38, 122, 216, true)
	end
end
function outputCarSystemWarning(text, player)
	if isResourceRunning ("aw_interface_notify") then
	--	exports.aw_interface_notify:addaw_interface_notify (player, "Автосалон", text:gsub("#цв#", "#FFFF00"))
	else
		outputChatBox("[Автосалон] #FFFF00"..text:gsub("#цв#", "#FFFF00"), player, 38, 122, 216, true)
	end
end
function outputCarSystemError(text, player)
	if isResourceRunning ("aw_interface_notify") then
	--	exports.aw_interface_notify:addaw_interface_notify (player, "Автосалон", text:gsub("#цв#", "#FF3232"))
	else
		outputChatBox("[Автосалон] #FF3232"..text:gsub("#цв#", "#FF3232"), player, 38, 122, 216, true)
	end
end

--	==========     Оставлено для совместимости     ==========
function policeRemoveCar(vehicle)
	outputDebugString(string.format("[CAR_SYSTEM] %s using obsolete function policeRemoveCar(vehicle). Use destroyVehicle(vehicle) instead.", tostring(getResourceName(sourceResource))), 2)
	destroyVehicle(vehicle)
end

--	==========     Получение значка валюты из таблицы     ==========
function currencyToSymbol(currency)
	currency = currency or "RUB"
	return currencyTable[currency] or ""
end

-- ==========     Разбивка числа на части     ==========
function explodeNumber(number)
    number = tostring(number)
    local k
    repeat
        number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')
    until (k==0)    -- true - выход из цикла
    return number
end

--	==========     Получить имя игрока без цветового кода     ==========
function getPlayerNameWoutColor(player)
	return string.gsub(getPlayerName(player), '#%x%x%x%x%x%x', '')
end

--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end


-- ==========     Связанное с удалением аккаунтов     ==========
function wipeAccount(accName)
	local moneyEquivalent = 0
	local data = exports.mysql:dbQuery(-1, "vehicle", "SELECT * FROM ?? WHERE owner = ?", accName)
	for index, car in ipairs(data) do
		exports.mysql:dbExec("vehicle", "DELETE FROM ?? WHERE ID = ?", car.ID)
		exports.mysql:dbExec("handling", "DELETE FROM ?? WHERE ID = ?", car.ID)
		local cost, currency = getCarPrice(car.model)
		outputDebugString(string.format("[CAR-SYSTEM] Deleted car ID %i, owner %s, licensep %s, model %i, name \"%s\", cost %i %s",
			car.ID, car.owner, car.licensep, car.model, getVehicleModName(car.model), cost, (currency or "RUB")
		))
		data[index].cost = exports.bank:convertCurrency(cost, (currency or "RUB"), "RUB")
		moneyEquivalent = moneyEquivalent + data[index].cost
	end
	outputDebugString(string.format("[CAR-SYSTEM] Cars equivalent of account %s: %i", accName, moneyEquivalent))
	return moneyEquivalent, data
end

local pathNumber = "@numbers.txt"



function addBase(player,vehicle,paintjobcar,r1, g1, b1, r2, g2, b2,region)
    if player and isElement( player ) then
	    accName = getAccountName(getPlayerAccount(player))
	else
	    accName = player
	end
local newID = getFreeID() or 1

local color = table.concat({r1, g1, b1, r2, g2, b2}, ",")
    
	local vehicleType = getVehicleType( vehicle )
	local licensePlate = generateNumberplate("a", region)
	if (vehicleType == "Bike") or (vehicleType == "Quad") or (vehicleType == "BMX") then
		licensePlate = generateNumberplate("c", region)
	elseif (vehicleType == "Boat") then
		licensePlate = generateNumberplate("boat")
	elseif (vehicleType == "Helicopter") then
		licensePlate = generateNumberplate("helicopter")
	end
--local licensePlate = generateNumberplate("a", region)
local paintjob = paintjobcar or stockPaintjobs[vehicle]
local fuel = math.random(10, 25)

    exports.mysql:dbExec("vehicle", [[INSERT INTO ?? (ID, owner, model, x, y, z, rotZ, colors, upgrades, paintjob, HP, fuel, licensep, customTuning, fuelOctane, odometer, userOrder)
        VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);]],
        newID, accName, vehicle, 0,0,2,0, color, "", paintjob, 1000.0, fuel, licensePlate, toJSON({toner = {false, false, false}}, true), "92.0", math.random(0, 12), getNextUserOrderValue(accName)
    )
	if player and isElement( player ) then
        updateVehicleInfo(player)
	else
	    local player = getAccountPlayer( getAccount( accName ) )
		if player and isElement( player ) then
		    updateVehicleInfo(player)
		end
	end
    updateVehicleInfo(player)
    exports.mysql:dbExec("handling", "REPLACE INTO ?? (ID, handling) VALUES(?, ?);", newID, "")
end

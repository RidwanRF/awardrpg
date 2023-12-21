
-- carData = {[id] = {tank, consumption, fuel} }
-- stationData = {[id] = {name, showBlip, blipType, blip = {x, y, z}, loadout, pumps = {{x, y, z}} }}

local tankCapacities = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	for id, car in pairs(carData) do
		if (car.consumption) then
			car.consumption = car.consumption / 25000
			-- Число - количество метров за указанный расход
			-- Изначально было 200 литров на 100 километров.
			-- При числе 10000 этому расходу соответствует 20 л/100км в xml
		end
		tankCapacities[id] = {tank = car.tank, isElectric = (fuels[car.fuel].fType=="electric" and true) or nil}
	end
	
	for id, station in pairs(stationData) do
		local blip = 46
		if (station.blipType == "boat") then
			blip = 9
		elseif (station.blipType == "heli") then
			blip = 13
		end
		local blipPos = station.blip
		createBlip(blipPos.x,blipPos.y,blipPos.z, blip, 2, 255,0,0,255, 0, 500)
		for _, pump in ipairs(station.pumps) do
			local marker = createMarker(pump.x, pump.y, pump.z,'corona',3,128,128,0,128)
			setElementData(marker, 'gasStationID', id)
		end
	end
	
	setTimer(startFuelUse, 50, 1, localPlayer, getPedOccupiedVehicleSeat(localPlayer)) -- Задержка нужна, чтобы успело создаться окно гуи
	
	if isResourceRunning("hud_customhud") then
		exports.hud_customhud:setFuelTable(tankCapacities)
	end
end)

local currentVehicle	-- Текущая машина, для которой идет просчет бенза
local fuelDelta			-- Дельта израсходованного бенза от текущего значения в элементдате машины
local odometerDelta		-- То же самое, только пробега
local lastSendDelta		-- Последняя отправленная на сервер дельта. Используется для более точной синхронизации
local lastSendOdometerDelta
local fuelUseTimer		-- Таймер для обновления топлива
local oldCoords			-- Старые координаты машины
local sendCounter = 0	-- Счетчик между посылками данных на серв
local checkForEmptyTank	-- Проверить на пустой бак при посадке в машину

function startFuelUse(player,seat)
    if (player == localPlayer) and (seat == 0) then
		currentVehicle = getPedOccupiedVehicle(localPlayer)
		fuelDelta = 0
		odometerDelta = 0
		oldCoords = false
		
		local fuel = getElementData(currentVehicle, "fuel") or ifFuelNotFound()
		if fuel <= 0.01 then
			vehicleDriedOff(currentVehicle)
			if (checkForEmptyTank) then
				onHitRefuelMarker(localPlayer, true, checkForEmptyTank)
			end
		end
		if getElementData(currentVehicle, "isBroken") then	-- Если машина разбита в погоне
			setVehicleEngineState(currentVehicle, false)
		end
		
		if not isTimer(fuelUseTimer) then
			setTimer(fuelUse, 1000, 1)
		end
	end
end
addEventHandler("onClientVehicleEnter", root, startFuelUse)

function ifFuelNotFound()
	local data = carData[getElementModel(currentVehicle)] or carData[0]
	setElementData(currentVehicle, "fuel", data.tank)
	return data.tank
end

function vehicleDriedOff(vehicle)
	fuelDelta = 0
	setVehicleEngineState(vehicle, false)
	triggerServerEvent("vehicleDriedOff", resourceRoot, vehicle)
end

function fuelUse()
	checkForUnderwater()

	local vehicle = getPedOccupiedVehicle(localPlayer)
	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if (vehicle) and (seat == 0) then
		if not isTimer(fuelUseTimer) then
			setTimer(fuelUse, 1000, 1)
		end
		if not getVehicleEngineState(vehicle) then return end
	
		if (currentVehicle ~= vehicle) then
			currentVehicle = vehicle
			fuelDelta = 0
			odometerDelta = 0
		end
		local fuel = getElementData(vehicle, "fuel")
		
		if (fuel <= 0) then
			setVehicleEngineState(vehicle,false)
			return
		end

		local newCoords = { getElementPosition(vehicle) }
		local oldCoordsLocal = oldCoords or newCoords
		oldCoords = newCoords
	
		local model = getElementModel(vehicle)
		local fuelData = carData[model] or carData[0]
		
		local randCoeff = 150000	-- Коэффициент у рандома определяется как 150 000 деленное на кол-во секунд между проверками
		local realOctane = getElementData(vehicle, "fuelOctane") or 0
		local ethanolMultipler = getEthanolMultiplier(realOctane)
		local distance = getDistanceBetweenPoints2D(oldCoordsLocal[1],oldCoordsLocal[2], newCoords[1],newCoords[2])
		if (distance > 200) then
			distance = 0
		end
		local usedFuel = distance * (fuelData.consumption or 0) * ethanolMultipler	-- Затрачено на перемещение
		usedFuel = usedFuel + (math.random(100,1000)/randCoeff) * ((fuels[fuelData.fuel].fType ~= "electric") and 1.0 or 0.0)	-- Если электромобиль, то при стоянке бенз не тратится
		fuelDelta = fuelDelta - usedFuel
		odometerDelta = odometerDelta + distance/1000
		
		sendCounter = sendCounter + 1
		if (sendCounter > 5) then
			triggerServerEvent("catchFuelDelta", resourceRoot, vehicle, fuelDelta, odometerDelta)
			sendCounter = 0
			lastSendDelta = fuelDelta
			lastSendOdometerDelta = odometerDelta
		end

		if (fuel + fuelDelta <= 0.01) then
			outputChatBox('У тебя кончился бензин.', 255, 50, 50)
			vehicleDriedOff(vehicle)
		end
	else
		oldCoords = false
	end
end

local dyingTimer

function checkForUnderwater()
	local _, pY, pZ = getElementPosition(localPlayer)
	if (pY < -3000) and (pZ < -50) and not isTimer(dyingTimer) then
		triggerServerEvent("ImVeryDrown", resourceRoot)
		dyingTimer = setTimer(function() end, 10000, 1)
	end
end
	

function getCarFuel(vehicle)
	if isElement(vehicle) then
		if (vehicle == currentVehicle) then
			return (getElementData(currentVehicle, "fuel") or 0) + fuelDelta
		else
			return getElementData(vehicle, "fuel") or 0
		end
	else
		return 0
	end
end

function getCarOdometer(vehicle)
	if isElement(vehicle) then
		if (vehicle == currentVehicle) then
			return (getElementData(currentVehicle, "odometer") or 0) + odometerDelta
		else
			return getElementData(vehicle, "odometer") or 0
		end
	else
		return 0
	end
end

function resetDeltaFromServer()
	fuelDelta = (fuelDelta or 0) - (lastSendDelta or 0)
	if (fuelDelta > 0) then
		fuelDelta = 0
	end
	odometerDelta = (odometerDelta or 0) - (lastSendOdometerDelta or 0)
	if (odometerDelta < 0) then
		odometerDelta = 0
	end
end
addEvent("resetDelta", true)
addEventHandler("resetDelta", resourceRoot, resetDeltaFromServer)



-- ==========	Заправка	==========
local currentStationID
local currentStationMarker
local currentRefuellingVehicle
local refuelRequesSent

function onHitRefuelMarker(player, matchingDimension, anotherSource)
	if (player == localPlayer) then
		local vehicle = getPedOccupiedVehicle(player)
		local seat = getPedOccupiedVehicleSeat(player)
		if (vehicle) and (seat == 0) then
			local spX, spY, spZ = getElementVelocity(vehicle)
			local speed = math.sqrt(spX^2 + spY^2 + spZ^2) * 180
			if (speed < 60) then
				local id = getElementData(anotherSource or source, 'gasStationID')	-- anotherSource используется, когда надо определить, на каком маркере стоит машина, когда ентеришься в нее, а у нее пустой бак
				if (id) and (not currentStationID) and checkRefuellingAllowance(getVehicleType(vehicle), stationData[id].blipType) then
					currentRefuellingVehicle = vehicle
					currentStationID = id
					currentStationMarker = marker
					openRefuelWindow()
					setElementVelocity(vehicle, 0, 0, 0)
				end
			end
		end
		checkForEmptyTank = source
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, onHitRefuelMarker)

function checkRefuellingAllowance(vehicleType, stationType)
	if (stationType == "car") and ((vehicleType == "Automobile") or (vehicleType == "Bike") or (vehicleType == "Monster Truck") or (vehicleType == "Quad")) then
		return true
	elseif (stationType == "boat") and (vehicleType == "Boat") then
		return true
	elseif (stationType == "heli") and ((vehicleType == "Plane") or (vehicleType == "Helicopter")) then
		return true
	else
		return false
	end
end

function onClientMarkerLeave(player, matchingDimension)
	if (player == localPlayer) then
		if (currentStationID) then
			closeRefuelWindow()
			currentStationID = false
			currentStationMarker = false
			currentRefuellingVehicle = false
		end
		checkForEmptyTank = false
	end
end
addEventHandler("onClientMarkerLeave", resourceRoot, onClientMarkerLeave)


function openRefuelWindow()
	local model = getElementModel(currentRefuellingVehicle)
	local carParam = carData[model] or carData[0]
	local fuelType = fuels[carParam.fuel].fType
	local vehType = getVehicleType(model)
	local isAircraft = (vehType=="Plane") or (vehType=="Helicopter")
	showPetrolUI(true, carParam.tank-getCarFuel(currentRefuellingVehicle), fuelType, isAircraft)
end


function sendRefuelQuery(fuelType, amount)
	triggerServerEvent("startRefuelling", resourceRoot, currentRefuellingVehicle, fuelType, amount, currentStationID)
	showPetrolUI(false)
	refuelRequesSent = true
end

function closeRefuelWindow()
	showPetrolUI(false)
	if (refuelRequesSent) then
		triggerServerEvent("stopRefuelling", resourceRoot, localPlayer)
	end
end



function getFuelTable()
	return tankCapacities
end










-- local carFuel = {}
-- local fuelMarkers = {}

-- addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
    -- function()
        -- local xml = xmlLoadFile("carData.xml");
        -- local xmlNodes = xmlNodeGetChildren(xml);
        -- for i,node in ipairs(xmlNodes) do
           -- carFuel[tonumber(xmlNodeGetAttribute(node,'id'))] = tonumber(xmlNodeGetAttribute(node,'tank'))
        -- end
        -- xmlUnloadFile(xml);
		-- local res = getResourceFromName("hud_customhud")
		-- if res and (getResourceState(res) == "running") then
			-- exports.hud_customhud:setFuelTable(tankCapacities)
		-- end
		-- triggerServerEvent("getMarkersTable", resourceRoot)
    -- end
-- )

-- addEvent("catchMarkersTable", true)
-- addEventHandler("catchMarkersTable", resourceRoot, function(markersGroups)
	-- for _, group in pairs(markersGroups) do
		-- for _, marker in pairs(group) do
			-- table.insert(fuelMarkers, marker)
		-- end
	-- end
-- end)

-- function checkCarOnGasStation()
	-- local vehicle = getPedOccupiedVehicle(localPlayer)
	-- if vehicle then
		-- for _, marker in pairs(fuelMarkers) do
			-- if isElementWithinMarker(vehicle, marker) then
				-- triggerServerEvent("startVehicleRefuel", resourceRoot, vehicle, marker)
				-- break
			-- end
		-- end
	-- end
-- end
-- setTimer(checkCarOnGasStation, 5000, 0)

-- addEvent("onPedSyphonFuel",true);
-- function startSyphon()
	-- if not isPedInVehicle(localPlayer) then
		-- if isPedOnGround(localPlayer) then
			-- local px, py, pz = getElementPosition(localPlayer);
			-- local rot = getPedRotation(localPlayer);
			 
			-- local a = math.rad(90 - rot);
		 
			-- local dx = math.cos(a) * 1.5;
			-- local dy = math.sin(a) * 1.5;
			-- local ppx = math.cos(a) * 0.2;
			-- local ppy = math.sin(a) * 0.2;
		 
			-- local ex = px-dx;
			-- local ey = py+dy;
			-- px = px-ppx;
			-- py = py+ppy;
			-- hit, x, y, z, elementHit = processLineOfSight(px, py, pz+1, ex, ey, pz);
			-- if elementHit then
				-- if getElementType(elementHit) == 'vehicle' then
					-- triggerServerEvent('pedSyphonVehicle',localPlayer,elementHit);
				-- end
			-- end
		-- end
	-- end
-- end
-- addEventHandler("onPedSyphonFuel",getRootElement(),startSyphon);
-- addCommandHandler('syphon',startSyphon)

-- x,y = guiGetScreenSize()

-- addEvent("onPedReFuel",true);
-- function fillHerUp()
	-- local vehicle = getPedOccupiedVehicle(localPlayer);
	-- if not isPedInVehicle(localPlayer) then
		-- if isPedOnGround(localPlayer) then
			-- local px, py, pz = getElementPosition(localPlayer);
			-- local rot = getPedRotation(localPlayer);
			 
			-- local a = math.rad(90 - rot);
		 
			-- local dx = math.cos(a) * 1.5;
			-- local dy = math.sin(a) * 1.5;
			-- local ppx = math.cos(a) * 0.2;
			-- local ppy = math.sin(a) * 0.2;
		 
			-- local ex = px-dx;
			-- local ey = py+dy;
			-- px = px-ppx;
			-- py = py+ppy;
			-- hit, x, y, z, elementHit = processLineOfSight(px, py, pz+1, ex, ey, pz);
			-- if elementHit then
				-- if getElementType(elementHit) == 'vehicle' then
						-- triggerServerEvent('pedRefuelVehicle',localPlayer,elementHit);				
				-- end
			-- end
		-- end
	-- end
-- end
-- addEventHandler("onPedReFuel",getRootElement(),fillHerUp);
-- addCommandHandler('refuel',fillHerUp)

-- function drawGUI()
	-- local vehicle = getPedOccupiedVehicle(localPlayer);
	-- if vehicle then
		-- local x,y = guiGetScreenSize();
		-- if getVehicleType(vehicle) ~= 'Automobile' and getVehicleType(vehicle) ~= 'Bike' and getVehicleType(vehicle) ~= 'Monster Truck' and getVehicleType(vehicle) ~= 'Quad' then return end
		-- local driver = getVehicleController(vehicle);
		-- if driver ~= localPlayer then return end --###
		-- if getVehicleEngineState(vehicle) == false then return end --###
		-- dxDrawRectangle(x-53,(y/2)-75,40,142,0x66224466);
		-- local maxFuel = carFuel[0];
		-- local curFuel = getElementData(vehicle,'fuel');
		-- local carHealth = getElementHealth(vehicle)/10;
		-- if curFuel == false then return end
		-- if carFuel[getElementModel(vehicle)] then maxFuel = carFuel[getElementModel(vehicle)]; end
		-- local fuel = (curFuel/maxFuel)*100;
		-- local colour = nil;
		-- if fuel > 90 then
			-- colour = 0x9922CC33;
			-- dxDrawRectangle(x-30,(y/2)-71,16,21,colour);
		-- end
		-- if fuel > 75 then
			-- if colour == nil then
				-- colour = 0x99009900;
			-- end
			-- dxDrawRectangle(x-30,(y/2)-48,16,21,colour);
		-- end
		-- if fuel > 60 then
			-- if colour == nil then
				-- colour = 0x99339900;
			-- end
			-- dxDrawRectangle(x-30,(y/2)-25,16,21,colour);
		-- end
		-- if fuel > 45 then
			-- if colour == nil then
				-- colour = 0x99999900;
			-- end
			-- dxDrawRectangle(x-30,(y/2)-2,16,21,colour);
		-- end
		-- if fuel > 30 then
			-- if colour == nil then
				-- colour = 0x99996600;
			-- end
			-- dxDrawRectangle(x-30,(y/2)+21,16,21,colour);
		-- end
		-- if colour == nil then
			-- if fuel > 15 then
				-- colour = 0x99993300;
			-- else
				-- colour = 0x99990000;
			-- end
		-- end
			-- dxDrawRectangle(x-30,(y/2)+44,16,21,colour);
			-- local HealthHeight = ((136/100)*carHealth);
			-- local yOffset = HealthHeight-136
			-- dxDrawRectangle(x-50,(y/2)-71-yOffset,16,HealthHeight,0x99990000);

		-- --dxDrawText(tostring(carHealth)..'%',x-105,y-65);
		-- --dxDrawText(tostring(fuel)..'%',x-105,y-50);
	-- end
-- end
-- addEventHandler("onClientRender",getRootElement(),drawGUI);


-- addEventHandler("onClientElementStreamIn",getRootElement(),function ()
	-- if getElementType(source) ~= 'vehicle' then return end
	-- if getVehicleType(source) ~= 'Automobile' and getVehicleType(source) ~= 'Bike' and getVehicleType(source) ~= 'Monster Truck' and getVehicleType(source) ~= 'Quad' and getVehicleType(source) ~= 'Helicopter' then return end
	-- triggerServerEvent('giveVehicleFuelOnSpawn',source);
-- end);




















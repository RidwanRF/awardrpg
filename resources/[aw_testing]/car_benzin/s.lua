local tankCapacity = {}
local consumption = {}
local fuelPrice = {}

local gasStations = {};
local gasStationsBlip = {};
local gasStationsMarkers = {};
addEventHandler("onResourceStart", resourceRoot,
	function()
		local xml = xmlLoadFile("carData.xml");
		local xmlNodes = xmlNodeGetChildren(xml);
		for _, node in ipairs(xmlNodes) do
			local id = tonumber(xmlNodeGetAttribute(node, "id"))
			tankCapacity[id] = tonumber(xmlNodeGetAttribute(node, "tank"))
			local csp = xmlNodeGetAttribute(node, "consumption")
			if csp then
				consumption[id] = tonumber(csp) / 8000
				-- Число - количество метров за указанный расход
				-- Изначально было 200 литров на 100 километров.
				-- При числе 10000 этому расходу соответствует 20 л/100км в xml
			end
			fuelPrice[id] = tonumber(xmlNodeGetAttribute(node, "price"))
		end
		xmlUnloadFile(xml)
		
		local xml = xmlLoadFile("garageData.xml")
		local xmlNodes = xmlNodeGetChildren(xml)
		for _, node in ipairs(xmlNodes) do
			local name = xmlNodeGetAttribute(node,'name')
			local x = tonumber(xmlNodeGetAttribute(node,'x'))
			local y = tonumber(xmlNodeGetAttribute(node,'y'))
			local z = tonumber(xmlNodeGetAttribute(node,'z'))
			local isBoat = xmlNodeGetAttribute(node,'boat')
			local blip = 46
			if isBoat then blip = 9 end
			gasStationsBlip[name] = createBlip(x,y,z,blip,0,0,0,0,0,0,500)
			local moreKids = xmlNodeGetChildren(node)
			gasStationsMarkers[name] = {}
			for i,v in ipairs(moreKids) do
				local mx = tonumber(xmlNodeGetAttribute(v,'x'))
				local my = tonumber(xmlNodeGetAttribute(v,'y'))
				local mz = tonumber(xmlNodeGetAttribute(v,'z'))
				gasStationsMarkers[name][i] = createMarker(mx,my,mz,'corona',3,128,128,0,128)
				setElementData(gasStationsMarkers[name][i],'gasStation',true)
			end
		end
		xmlUnloadFile(xml);
		for _, player in ipairs(getElementsByType("player")) do
			source = getPedOccupiedVehicle(player)
			startFuelUse(player, getPedOccupiedVehicleSeat(player))
		end
	end
)

addEvent("getMarkersTable", true)
addEventHandler("getMarkersTable", resourceRoot, function()
	triggerClientEvent("catchMarkersTable", resourceRoot, gasStationsMarkers)
end)

function startFuelUse(player,seat)
    if seat ~= 0 then return end
	if getCarFuel(source) <= 0 then
		setVehicleEngineState(source, false)
	end
	setTimer(fuelUse, 1000, 1, player)
end
addEventHandler("onVehicleEnter", root, startFuelUse)

function fuelUse(player)
	if not isElement(player) then return end
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle then
		setTimer(fuelUse, 10000, 1, player)
		if getVehicleController(vehicle) ~= player then return end
		if not getVehicleEngineState(vehicle) then return end
		
		local fuel = getCarFuel(vehicle)
		if fuel == 0 then
			setVehicleEngineState(vehicle,false)
			return
		end
		
		local newCoords = { getElementPosition(vehicle) }
		local oldCoords = getElementData(vehicle, "fuelCoords") or newCoords
		setElementData(vehicle, "fuelCoords", newCoords)
		
		local model = getElementModel(vehicle)
		local usedFuel = getDistanceBetweenPoints2D(oldCoords[1],oldCoords[2], newCoords[1],newCoords[2]) * (consumption[model] or consumption[0])  + (math.random(100,1000)/15000)
		local remainingFuel = takeCarFuel(vehicle, usedFuel)
		
		if remainingFuel < 0.001 then
			outputChatBox('У тебя кончился бензин',player)
			setVehicleEngineState(vehicle,false)
		end
	end
end

local refuelTimer = {}
function hitTheMarker(hitElement)
	if getElementType(hitElement) == "vehicle" and getElementData(source, "gasStation") then
		refuelTimer[hitElement] = setTimer(vehicleRefuel, 500, 1, hitElement, source)
	end
end
addEventHandler('onMarkerHit', root, hitTheMarker)

function startVehicleRefuel(vehicle,marker)
	if not isTimer(refuelTimer[vehicle]) and (getCarFuel(vehicle) < 1) then
		refuelTimer[vehicle] = setTimer(vehicleRefuel, 500, 1, vehicle, marker)
	end
end
addEvent('startVehicleRefuel', true);
addEventHandler('startVehicleRefuel', resourceRoot, startVehicleRefuel)

local pendingBudget = {}
function vehicleRefuel(vehicle,marker)
	if not isElement(vehicle) then return end
	local driver = getVehicleOccupants(vehicle)[0]
	if not driver then return end
	if not isElementWithinMarker(vehicle, marker) then return end
	local liters = 5 -- Сколько заправлять
	local model = getElementModel(vehicle)
	local maxFuel = tankCapacity[model] or tankCapacity[0]
	local fuelCost = fuelPrice[model] or fuelPrice[0]
	local currentFuel = getCarFuel(vehicle)
	if currentFuel >= maxFuel then return end
	if currentFuel + liters > maxFuel then
		liters = maxFuel - currentFuel
		outputChatBox("Машина полностью заправлена",driver)
	else
		refuelTimer[vehicle] = setTimer(vehicleRefuel, 1000, 1, vehicle, marker)
	end
	if (getPlayerMoney(driver) < liters * fuelCost) then
		outputChatBox("Ты не можешь себе позволить больше топлива", driver)
		return
	end
	addCarFuel(vehicle, liters);
    takePlayerMoney(driver, liters*fuelCost)
	pendingBudget[driver] = (pendingBudget[driver] or 0) + liters*fuelCost
end

function exportToBudget()
	if (getResourceState(getResourceFromName("budget")) == "running") then
		for player, value in pairs(pendingBudget) do
			exports.budget:addBudget("car_benzin", player, value, "refueling")
			pendingBudget[player] = nil
		end
	end
end
setTimer(exportToBudget, 180000, 0)




function getCarFuel(v)
	if getElementType(v) == 'vehicle' then
		local fuel = getElementData(v,'fuel');
		local model = getElementModel(v);
		if not tankCapacity[model] then model = 0; end
		if not fuel then
			if tankCapacity[model] then
				fuel = tankCapacity[model];
				setElementData(v,'fuel',tankCapacity[model]);
			else
				fuel = tankCapacity[0];
				setElementData(v,'fuel',tankCapacity[0]);
			end
		end
		return fuel;
	elseif getElementType(v) == 'player' then
		local fuel = getElementData(v,'fuel');
		if not fuel then
			setElementData(v,'fuel',0);
			return 0;
		end
		return fuel;
	end
end

function addCarFuel(v,a)
	if getElementType(v) == 'vehicle' then
		local fuel = getElementData(v,'fuel');
		local model = getElementModel(v);
		if not tankCapacity[model] then model = 0; end
		if not fuel then
			if tankCapacity[model] then
				fuel = tankCapacity[model];
				setElementData(v,'fuel',tankCapacity[model]);
			else
				fuel = tankCapacity[0];
				setElementData(v,'fuel',tankCapacity[0]);
			end
		end
		fuel = fuel + a;
		if fuel > tankCapacity[model] then fuel = tankCapacity[model]; end
		setElementData(v,'fuel',fuel);
		return fuel;
	elseif getElementType(v) == 'player' then
		local fuel = getElementData(v,'fuel');
		if not fuel then
			fuel = 0;
		end
		fuel = fuel + a;
		if fuel > tankCapacity[-1] then fuel = tankCapacity[-1]; end
		setElementData(v,'fuel',fuel);
		return fuel;
	end
end

function takeCarFuel(v,a)
	if getElementType(v) == 'vehicle' then
		local fuel = getElementData(v,'fuel');
		local model = getElementModel(v);
		if not tankCapacity[model] then model = 0; end
			if not fuel then
			if tankCapacity[model] then
				fuel = tankCapacity[model];
				setElementData(v,'fuel',tankCapacity[model]);
			else
				fuel = tankCapacity[0];
				setElementData(v,'fuel',tankCapacity[0]);
			end
		end
		fuel = fuel - a;
		if fuel < 0 then fuel = 0; end
		setElementData(v,'fuel',fuel);
		return fuel;
	elseif getElementType(v) == 'player' then
		local fuel = getElementData(v,'fuel');
		if not fuel then
			fuel = 0;
		end
		fuel = fuel - a;
		if fuel < 0 then fuel = 0; end
		setElementData(v,'fuel',fuel);
		return fuel;
	end
end









function switchEngine(playerSource)
    local theVehicle = getPedOccupiedVehicle(playerSource);
    if theVehicle and getVehicleController(theVehicle) == playerSource then
        local state = getVehicleEngineState(theVehicle)
		if state then
			setVehicleEngineState(theVehicle, false);
			outputChatBox('Машина заглушена',playerSource);
		else
			if getCarFuel(theVehicle) <= 0 then return end
			setVehicleEngineState(theVehicle, true);
			outputChatBox('Машина заведена',playerSource);
		end
    end
end
addCommandHandler("engine",switchEngine);

addEvent('pedSyphonVehicle',true);
function pedSyphon(v)
	if getCarFuel(source) >= tankCapacity[-1] then outputChatBox("У тебя максимум топлива",source); return end
	local n = math.random(100,200)/1000;
	local left = takeCarFuel(v,n);
	local total = addCarFuel(source,n);
	if left <= 0 then outputChatBox("В этой машине не осталось топлива",source); return end
	triggerClientEvent("onPedSyphonFuel",source);
end
addEventHandler('pedSyphonVehicle',root,pedSyphon);

addEvent('pedRefuelVehicle',true);
function pedSyphon(v)
	if getCarFuel(source) <= 0 then outputChatBox("У тебя закончился бензин",source); return end
	local maxFuel = tankCapacity[0];
	if tankCapacity[getElementModel(v)] then
		maxFuel = getFuel[getElementModel(v)];
	end
	if getCarFuel(v) >= maxFuel then
		outputChatBox("Твоя машина полностью заправлена",source); return
	end
	local n = math.random(100,200)/1000;
	local left = takeCarFuel(source,n);
	local total = addCarFuel(v,n);
	triggerClientEvent("onPedReFuel",source);
end
addEventHandler('pedRefuelVehicle',root,pedSyphon);


addEvent('giveVehicleFuelOnSpawn',true);
addEventHandler('giveVehicleFuelOnSpawn',root,function()
	getCarFuel(source);
end);

function onVehicleRespawn(exploded)
if getElementType(source) ~= 'vehicle' then return end
	local model = getElementModel(source);
	if not tankCapacity[model] then model = 0; end
		if not fuel then
		if tankCapacity[model] then
			setElementData(source,'fuel',tankCapacity[model]);
		else
			setElementData(source,'fuel',tankCapacity[0]);
		end
	end
	return;
end
addEventHandler("onVehicleRespawn",root,onVehicleRespawn)
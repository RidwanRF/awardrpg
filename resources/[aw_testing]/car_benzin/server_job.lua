
local stationsTable = {}
local deliveriesShort = {}	-- [player] = {id, fuelType, amount}
local pendingDeliveries = {}
local vehicleToPlayer = {}

local db = dbConnect("sqlite", "fueljob.db")

function onResourceStart()
	dbExec(db, [[
		CREATE TABLE IF NOT EXISTS `stations` (`ID` INTEGER UNIQUE, `fuelTypes` TEXT,
		`AI92` REAL, `AI95` REAL, `AI98` REAL, `AI98plus` REAL, `E85` REAL,
		`DT` REAL, `DTplus` REAL, `TC1` REAL);
	]])
	dbExec(db, "CREATE TABLE IF NOT EXISTS dbData (key TEXT UNIQUE, value TEXT);")

	updateDatabase()
	
	for id, station in pairs(stationData) do
		local dbRow = dbPoll(dbQuery(db, "SELECT * FROM stations WHERE ID = ?;", id), -1)
		stationsTable[id] = {id = id}
		for _, fuelType in ipairs(split(acceptedFuelTypes[station.blipType], ",")) do
			stationsTable[id][fuelType] = dbRow[1][fuelType]
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

function returnTableData()
	triggerClientEvent(client, "catchTableData", resourceRoot, stationsTable, deliveriesShort)
end
addEvent("getTableData", true)
addEventHandler("getTableData", resourceRoot, returnTableData)

--	deliveriesShort = {}	-- [player] = {id, fuelType, amount}
--	pendingDeliveries = {}	-- [client] = {id, fuelType, amount, price, bonus, vehicle}
--	vehicleToPlayer = {}	-- [vehicle] = player

--	sourceMarkerData = {marker = {[1], [2], [3]}, vehicleSpawn = {{[1], [2], [3], rot}}, name},

local prevNumber = 1

function getRandomSpawn(variants)
	prevNumber = prevNumber + 1
	if (prevNumber > #variants) then
		prevNumber = 1
	end
	return variants[prevNumber]
end

function startJob(car, distance, bonus, fuel, id, sourceMarkerData)
	local price = distance * 10 * getRouteCoefficient(sourceMarkerData.name, id)
	local amount = fuelTrucks[car].tank
	local spawnAt = getRandomSpawn(sourceMarkerData.vehicleSpawn)
	local licensep = isResourceRunning("car_system") and exports.car_system:generateNumberplate() or "h-"
	if (car == 414) then
		price = price * 0.8
	end
	if (bonus > 10.0) then
		bonus = 10.0
	end

	destroyAllElements(client)
	
	local vehicle = createVehicle(car, spawnAt[1], spawnAt[2], spawnAt[3], 0, 0, spawnAt.rot)
	setElementData(vehicle, "job.nomer", licensep)
	setRandomFuelAndOdometer(vehicle, car)
	setElementData(vehicle, "misc", 1)
	setElementData(vehicle, "JobVeh", true)
	setTimer(checkAndWarp, 250, 1, client, vehicle)
	triggerClientEvent(client, "catchVehicle", resourceRoot, vehicle, amount)
	triggerClientEvent("forceUpdateVehicleComponents", vehicle)
	
	deliveriesShort[client] = {id = id, fuelType = fuel, amount = amount}
	pendingDeliveries[client] = {id = id, fuelType = fuel, amount = amount, price = price, bonus = bonus, vehicle = vehicle}
	vehicleToPlayer[vehicle] = client
	
	local curTime = getRealTime().timestamp
	pendingDeliveries[client].startTime = curTime
	pendingDeliveries[client].mrkName = sourceMarkerData.name
	pendingDeliveries[client].distance = distance
end
addEvent("startJob", true)
addEventHandler("startJob", resourceRoot, startJob)

function checkAndWarp(player, vehicle)
	if isElement(player) and isElement(vehicle) then
		warpPedIntoVehicle(player, vehicle)
	end
end

function setRandomFuelAndOdometer(vehicle, model)
	if isElement(vehicle) then
		model = model or getElementModel(vehicle)
		local data = carData[model] or carData[0]
		setElementData(vehicle, "fuel", data.tank * (0.33 + (math.random()*0.33)))
		setElementData(vehicle, "fuelOctane", fuels[data.fuel].octane)
		setElementData(vehicle, "odometer", math.random(15000, 1000000))
		setOctaneDependentParameters(vehicle, fuels[data.fuel].octane, data.fuel)
	end
end

function destroyAllElements(player)
	local vehicle = pendingDeliveries[player] and pendingDeliveries[player].vehicle
	if (vehicle) then
		vehicleToPlayer[vehicle] = nil
		if isElement(vehicle) then
			destroyElement(vehicle)
		end
	end
	deliveriesShort[player] = nil
	pendingDeliveries[player] = nil
end

function truckUnloaded()
	local id = deliveriesShort[client].id
	local fuelType = deliveriesShort[client].fuelType
	local amount = deliveriesShort[client].amount
	placeFuelIntoStation(id, fuelType, amount)
	deliveriesShort[client] = nil	
	
	local unloadTime = getRealTime().timestamp - pendingDeliveries[client].startTime
	pendingDeliveries[client].unloadTime = unloadTime
	
	outputDebugString("[CAR_BENZIN] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client)).." money "..getPlayerMoney(client)
		..") unloaded "..tostring(amount).." of "..tostring(fuelType).." on station ID "..tostring(id)..". Time: "..unloadTime.." secs")
end
addEvent("truckUnloaded", true)
addEventHandler("truckUnloaded", resourceRoot, truckUnloaded)



function finishJob()
	local id = pendingDeliveries[client].id
	local fuelType = pendingDeliveries[client].fuelType
	local amount = pendingDeliveries[client].amount
	local price = pendingDeliveries[client].price
	local bonus = pendingDeliveries[client].bonus
	local finalMoney = price*bonus
	givePlayerMoney(client, finalMoney)
	
	outputChatBox("Вы получили "..math.floor(finalMoney).."руб. за перевозку "..math.floor(amount).."л "..fuels[fuelType].name, client, 50,255,50)
	outputDebugString("[CAR_BENZIN] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client)).." money "..getPlayerMoney(client)
		..") got "..tostring(finalMoney).." for his work")
	
	local currentTime = getRealTime().timestamp
	local idFrom = pendingDeliveries[client].mrkName
	local unloadTime = pendingDeliveries[client].unloadTime
	local fullTime = currentTime - pendingDeliveries[client].startTime
	local distance = pendingDeliveries[client].distance
	dbExec(db, [[INSERT INTO log (recordTime, player, account, fuelType, amount, idFrom, idTo, timeUnload, fullTime, price, bonus, distance)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);]],
		currentTime, getPlayerName(client), getAccountName(getPlayerAccount(client)), fuelType, amount, idFrom, id, unloadTime, fullTime, price, bonus, distance)
		
	destroyAllElements(client)
	
	local cargoCount = 0
	while cargoCount < amount do
		local randomCount = math.random(500, amount)
		local stationID = math.random(#stationData)
		local acceptedFuels = split(acceptedFuelTypes[stationData[stationID].blipType], ",")
		local fuelToTake = acceptedFuels[math.random(#acceptedFuels)]
		local fuelOnThisStation = getTankOfStation(stationID, fuelToTake)
		if (fuelOnThisStation > stationTankCapacity) then
			fuelOnThisStation = stationTankCapacity
			takeFuelFromStation(stationID, fuelToTake, fuelOnThisStation-stationTankCapacity)
		end
		takeFuelFromStation(stationID, fuelToTake, randomCount)
		cargoCount = cargoCount + randomCount
    end
	
	
end
addEvent("finishJob", true)
addEventHandler("finishJob", resourceRoot, finishJob)



function balanceCargo()
	local totalCapacity = 0
	local filledCapacity = 0
	for id, station in pairs(stationsTable) do
		for fuelType, _ in pairs(fuels) do
			if tonumber(station[fuelType]) then
				filledCapacity = filledCapacity + tonumber(station[fuelType])
				totalCapacity = totalCapacity + stationTankCapacity
			end
		end
	end
	if (filledCapacity/totalCapacity > 0.95) then
		local difference = filledCapacity - totalCapacity*0.95
		local removedCount = 0
		while removedCount < difference do
			local randomCount = math.random(0,80000)
			local stationID = math.random(#stationData)
			local acceptedFuels = split(acceptedFuelTypes[stationData[stationID].blipType], ",")
			local fuelToTake = acceptedFuels[math.random(#acceptedFuels)]
			local fuelOnThisStation = getTankOfStation(stationID, fuelToTake)
			if (fuelOnThisStation > stationTankCapacity) then
				fuelOnThisStation = stationTankCapacity
				takeFuelFromStation(stationID, fuelToTake, fuelOnThisStation-stationTankCapacity)
			end
			takeFuelFromStation(stationID, fuelToTake, randomCount)
			removedCount = removedCount + randomCount
		end
	end
end
--setTimer(balanceCargo, 1000, 1)



addEventHandler("onVehicleStartEnter", root, function(player, seat)
    if (vehicleToPlayer[source]) and (seat == 0) and (player ~= vehicleToPlayer[source]) then
        cancelEvent()
		outputChatBox("Это не ваш грузовик!", player, 255,50,50)
    end
end)
















function getTankOfStation(id, fuelType)
	if (fuelType ~= "A100") then
		if (stationsTable[id]) then
			return stationsTable[id][fuelType] or 0
		else
			return 0
		end
	else
		return 100
	end
end

function takeFuelFromStation(id, fuelType, amount)
	if (stationsTable[id] and stationsTable[id][fuelType]) then
		local newFuel = stationsTable[id][fuelType] - amount
		if (newFuel < 0) then
			newFuel = 0
		end
		stationsTable[id][fuelType] = newFuel
		dbExec(db, "UPDATE stations SET ?? = ? WHERE ID = ?;", fuelType, newFuel, id)
	end
end

function placeFuelIntoStation(id, fuelType, amount)
	if (stationsTable[id] and stationsTable[id][fuelType]) then
		local newFuel = stationsTable[id][fuelType] + amount
		stationsTable[id][fuelType] = newFuel
		dbExec(db, "UPDATE stations SET ?? = ? WHERE ID = ?;", fuelType, newFuel, id)
	end
end

function onPlayerWasted()
	destroyAllElements(source)
end
addEventHandler("onPlayerWasted", root, onPlayerWasted)

function onVehicleExplode()
	if (vehicleToPlayer[source]) then
		local player = vehicleToPlayer[source]
		if isElement(player) then
			outputChatBox("Ваш грузовик взорван. Работа перевозчика топлива отменена.", player, 255,50,50)
			triggerClientEvent(player, "destroyAllElements", resourceRoot)
		end
		destroyAllElements(player)
	end
end
addEventHandler("onVehicleExplode", root, onVehicleExplode)

function quitPlayer()
	destroyAllElements(source)
end
addEventHandler("onPlayerQuit", root, quitPlayer)



--	deliveriesShort = {}	-- [player] = {id, fuelType, amount}
--	pendingDeliveries = {}	-- [client] = {id, fuelType, amount, price, bonus, vehicle}
--	vehicleToPlayer = {}	-- [vehicle] = player


function updateDatabase()
	local result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (not result) or (not result[1]) or (not result[1].value) or (tonumber(result[1].value) < 1.0) then
		outputDebugString("[DBUPDATE] DB version in car_benzin is unknown! Updating to version 1.0")
		dbExec(db, "INSERT OR REPLACE INTO dbData (key, value) VALUES ('version', '1.0');")
		outputDebugString("[DBUPDATE] Database in car_benzin updated to version 1.0")
	end
	
	result = dbPoll(dbQuery(db, "SELECT COUNT(ID) AS count FROM stations;"), -1)
	if (not result) or (not result[1]) or (not result[1].count) or (tonumber(result[1].count) ~= #stationData) then
		outputDebugString("[DBUPDATE] DB is not complete! Updating fuel stations")
		for id, station in pairs(stationData) do
			local dbRow = dbPoll(dbQuery(db, "SELECT * FROM stations WHERE ID = ?;", id), -1)
			if (dbRow) and (dbRow[1]) then
				dbRow = dbRow[1]
			else
				outputDebugString("[DBUPDATE] Fuel station ID "..tostring(id).." not found")
			end
			dbExec(db, [[
				INSERT OR REPLACE INTO stations (ID, fuelTypes, AI92, AI95, AI98, AI98plus, E85, DT, DTplus, TC1)
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);]],
				id, acceptedFuelTypes[station.blipType],
				orRandom(dbRow.AI92), orRandom(dbRow.AI95), orRandom(dbRow.AI98), orRandom(dbRow.AI98plus), orRandom(dbRow.E85),
				orRandom(dbRow.DT), orRandom(dbRow.DTplus), orRandom(dbRow.TC1)
			)
		end
		outputDebugString("[DBUPDATE] Database updated")
	end

	result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (not result) or (not result[1]) or (not result[1].value) or (tonumber(result[1].value) < 1.1) then
		outputDebugString("[DBUPDATE] DB version in car_benzin is old! Updating to version 1.1")
		dbExec(db, "CREATE TABLE IF NOT EXISTS log (recordTime INTEGER, player TEXT, account TEXT, fuelType TEXT, amount INTEGER, idFrom TEXT, idTo INTEGER, timeUnload INTEGER, fullTime INTEGER);")
		dbExec(db, "INSERT OR REPLACE INTO dbData (key, value) VALUES ('version', '1.1');")
		outputDebugString("[DBUPDATE] Database in car_benzin updated to version 1.1")
	end

	result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (not result) or (not result[1]) or (not result[1].value) or (tonumber(result[1].value) < 1.2) then
		outputDebugString("[DBUPDATE] DB version in car_benzin is old! Updating to version 1.2")
		dbExec(db, "ALTER TABLE log ADD COLUMN price INT;")
		dbExec(db, "ALTER TABLE log ADD COLUMN bonus INT;")
		dbExec(db, "INSERT OR REPLACE INTO dbData (key, value) VALUES ('version', '1.2');")
		outputDebugString("[DBUPDATE] Database in car_benzin updated to version 1.2")
	end

	result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (not result) or (not result[1]) or (not result[1].value) or (tonumber(result[1].value) < 1.3) then
		outputDebugString("[DBUPDATE] DB version in car_benzin is old! Updating to version 1.3")
		dbExec(db, "ALTER TABLE log ADD COLUMN distance INT;")
		dbExec(db, "INSERT OR REPLACE INTO dbData (key, value) VALUES ('version', '1.3');")
		outputDebugString("[DBUPDATE] Database in car_benzin updated to version 1.3")
	end

	result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (not result) or (not result[1]) or (not result[1].value) or (tonumber(result[1].value) < 1.4) then
		outputDebugString("[DBUPDATE] DB version in car_benzin is old! Updating to version 1.4")
		
		dbExec(db, "DELETE FROM log;")
		
		local fuelTypes = split(acceptedFuelTypes.car, ",")
		table.insert(fuelTypes, acceptedFuelTypes.heli)
		local stations = dbPoll(dbQuery(db, "SELECT * FROM stations;"), -1)
		for _, row in ipairs(stations) do
			for _, fuelType in ipairs(fuelTypes) do
				local amount = tonumber(row[fuelType])
				if (amount) then
					if (amount < 2500) then
						dbExec(db, "UPDATE stations SET ?? = 0.0 WHERE ID = ?;", fuelType, row.ID)
					elseif (amount > 100000) then
						dbExec(db, "UPDATE stations SET ?? = 100000.0 WHERE ID = ?;", fuelType, row.ID)
					end
				end
			end
		end
		
		dbExec(db, "INSERT OR REPLACE INTO dbData (key, value) VALUES ('version', '1.4');")
		outputDebugString("[DBUPDATE] Database in car_benzin updated to version 1.4. Fuel amounts truncated.")
	end
	
	dbExec(db, "DELETE FROM log WHERE recordTime < ?;", getRealTime().timestamp-259200)
end


















function or0(number)
	return number or 0
end

function orRandom(number)
	return number or math.random(500,2000)
end


--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end




















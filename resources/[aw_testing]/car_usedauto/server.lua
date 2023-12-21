
local vehicleExitPosition = {x = 1711.96106, y = -1138.724976, z = 24.5, rotZ = 180}

-- ==========     Телепортирование игроков     ==========
function warpPlayer(x, y, z, rot, int, dim)
	fadeCamera(client, false, 1.0)
	setTimer(warpPlayer2, 1100, 1, client, x, y, z, rot, int, dim)
end
addEvent("usedauto.warpPlayer", true)
addEventHandler("usedauto.warpPlayer", resourceRoot, warpPlayer)

function warpPlayer2(player, x, y, z, rot, int, dim)
	if isElement(player) then
		setElementDimension(player, dim)
		setElementInterior(player, int, x, y, z)
		setElementPosition(player, x, y, z)
		setElementRotation(player, 0, 0, rot, "default", true)
		fadeCamera(player, true, 1.0)
		setTimer(setCameraTarget, 50, 1, player)
		triggerClientEvent(player, "startPlayerCheck", resourceRoot, z-1.5)
	end
end

function fixPlayer(z)
	if isElement(client) then
		local x, y, _ = getElementPosition(client)
		setElementPosition(client, x, y, z)
	end
end
addEvent("fixPlayer", true)
addEventHandler("fixPlayer", resourceRoot, fixPlayer)


local db = dbConnect("sqlite", "useddb.db")

local pX = 1
local pY = 2
local pZ = 3
local pRotZ = 4
local pVehicle = 5
local pDim = 6

function onStart(res)
	dbExec(db, "CREATE TABLE IF NOT EXISTS vehicle (ID, Model, owner, price, nomer, Upgrades, Colors, Paintjob, in_index, handling, oldOwners, customTuning, odometer);")
	
	local result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (not result) or (not result[1]) or (not result[1].value) or (tonumber(result[1].value) < 1.0) then
		outputDebugString("[DBUPDATE] Old database in car_usedauto! Updating to version 1.0")
		dbExec(db, "CREATE TABLE IF NOT EXISTS dbData (key TEXT, value TEXT);")
		dbExec(db, "ALTER TABLE vehicle ADD COLUMN fuelOctane REAL;")
		dbExec(db, "INSERT INTO dbData (key, value) VALUES ('version', '1.0');")
		outputDebugString("[DBUPDATE] Database in car_usedauto updated to version 1.0")
	end
	
	local result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (tonumber(result[1].value) < 1.1) then
		outputDebugString("[DBUPDATE] Old database in car_usedauto! Updating to version 1.1")
		dbExec(db, "ALTER TABLE vehicle ADD COLUMN odometer REAL;")
		dbExec(db, "UPDATE dbData SET value = '1.1' WHERE key = 'version';")
		outputDebugString("[DBUPDATE] Database in car_usedauto updated to version 1.1")
	end
		
	local result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (tonumber(result[1].value) < 1.2) then
		outputDebugString("[DBUPDATE] Old database in car_usedauto! It can has big and fuck-priced cars. Updating to version 1.2")
		dbExec(db, "DELETE FROM vehicle WHERE Model IN (506, 536, 403, 431, 437, 515);")
		dbExec(db, "UPDATE dbData SET value = '1.2' WHERE key = 'version';")
		outputDebugString("[DBUPDATE] Database in car_usedauto updated to version 1.2. Big and fuck-priced cars deleted")
	end
		
	local result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (tonumber(result[1].value) < 1.3) then
		outputDebugString("[DBUPDATE] Old database in car_usedauto! It can has bad tuning values. Updating to version 1.3")
		local tuningTables = dbPoll(dbQuery(db, "SELECT ID, Upgrades FROM vehicle WHERE `Upgrades` LIKE '%-%';"), -1)
		for _, row in ipairs(tuningTables) do
			row.Upgrades = string.gsub(row.Upgrades, ",", ";")
			row.Upgrades = string.gsub(row.Upgrades, "-", ",")
			dbExec(db, "UPDATE vehicle SET Upgrades = ? WHERE ID = ?;", row.Upgrades, row.ID)
		end		
		dbExec(db, "UPDATE dbData SET value = '1.3' WHERE key = 'version';")
		outputDebugString("[DBUPDATE] Database in car_usedauto updated to version 1.3. Bad tuning values fixed")
	end
		
	local result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (tonumber(result[1].value) < 1.4) then
		outputDebugString("[DBUPDATE] Old database in car_usedauto! It can has old cars. Updating to version 1.4")
		local result = dbPoll(dbQuery(db, "SELECT COUNT(ID) AS count FROM vehicle WHERE Model IN (541, 551, 596, 490, 526, 480);"), -1)
		outputDebugString("Found "..(result and result[1] and result[1].count or 0).." old cars")
		dbExec(db, "DELETE FROM vehicle WHERE Model IN (541, 551, 596, 490, 526, 480);")
		dbExec(db, "UPDATE dbData SET value = '1.4' WHERE key = 'version';")
		outputDebugString("[DBUPDATE] Database in car_usedauto updated to version 1.4. Old cars deleted")
	end
		
	local result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (tonumber(result[1].value) < 1.5) then
		outputDebugString("[DBUPDATE] Old database in car_usedauto! It has wrong customTuning format. Updating to version 1.5")
		local result = dbPoll(dbQuery(db, "SELECT ID, customTuning FROM vehicle;"), -1)
		outputDebugString("Found "..(#result or 0).." cars")
		for _, car in ipairs(result) do
			local alreadyJSON = fromJSON(car.customTuning)
			if (not alreadyJSON) then
				local newData = {toner = {false, false, false}}
				local toner = split(car.customTuning, ',')
				newData.toner[1] = tonumber(toner[1])
				newData.toner[2] = tonumber(toner[2])
				newData.toner[3] = tonumber(toner[3])
				if (toner[4] == "3200K") then
					newData.xenon = {255, 254, 205}
				elseif (toner[4] == "4000K") then
					newData.xenon = {229, 230, 255}
				elseif (toner[4] == "4300K") then
					newData.xenon = {183, 186, 255}
				elseif (toner[4] == "5000K") then
					newData.xenon = {145, 150, 255}
				elseif (toner[4] == "6000K") then
					newData.xenon = {105, 112, 255}
				elseif (toner[4] == "7500K") then
					newData.xenon = {63, 72, 255}
				end	
				dbExec(db, "UPDATE vehicle SET customTuning = ? WHERE ID = ?;", toJSON(newData, true), car.ID)
			end
		end
		dbExec(db, "UPDATE dbData SET value = '1.5' WHERE key = 'version';")
		outputDebugString("[DBUPDATE] Database in car_usedauto updated to version 1.5. customTuning format fixed")
	end
	
	removeOldCars(1.6, "562, 566, 451, 400, 416, 536, 467, 492, 543, 558")
	
	local result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (tonumber(result[1].value) < 1.7) then
		outputDebugString("[DBUPDATE] Old database in car_usedauto! It can has M4 and R8 with wrong tuning. Updating to version 1.7")
		local result = dbPoll(dbQuery(db, "SELECT COUNT(ID) AS count FROM vehicle WHERE Model IN (527, 422);"), -1)
		outputDebugString("[DBUPDATE] Found "..(result and result[1] and result[1].count or 0).." M4 or R8")
		dbExec(db, "DELETE FROM vehicle WHERE Model IN (527, 422);")
		dbExec(db, "UPDATE dbData SET value = '1.7' WHERE key = 'version';")
		outputDebugString("[DBUPDATE] Database in car_usedauto updated to version 1.7. M4 and R8 deleted")
	end
	
	removeOldCars(1.8, "579, 602, 567, 405, 479, 438, 587")
	
	removeOldCars(1.9, "409")
	
	removeOldCars(2.0, "502, 596, 475, 597, 434, 605, 504, 424, 421, 439, 405")
	
	local cars = dbPoll(dbQuery(db, "SELECT * FROM vehicle"), -1)
	while #cars > #position do
		freeCarPosition()
		cars = dbPoll(dbQuery(db, "SELECT * FROM vehicle"), -1)
    end
	for i, car in ipairs (cars) do
		local freePosition = getFreePosition()
		spawnCar(car, freePosition, tonumber(car.ID))		
	end
	setTimer(triggerClientEvent, 1000, 1, "RefreshCarPlates", root)
end
addEventHandler("onResourceStart", resourceRoot, onStart)

function removeOldCars(version, carsList)
	local result = dbPoll(dbQuery(db, "SELECT value FROM dbData WHERE key = 'version';"), -1)
	if (tonumber(result[1].value) < tonumber(version)) then
		outputDebugString("[DBUPDATE] Old database in car_usedauto! It can has old cars. Updating to version "..version)
		local result = dbPoll(dbQuery(db, "SELECT COUNT(ID) AS count FROM vehicle WHERE Model IN ("..carsList..");"), -1)
		outputDebugString("Found "..(result and result[1] and result[1].count or 0).." old cars")
		dbExec(db, "DELETE FROM vehicle WHERE Model IN ("..carsList..");")
		dbExec(db, "UPDATE dbData SET value = ? WHERE key = 'version';", version)
		outputDebugString("[DBUPDATE] Database in car_usedauto updated to version "..tostring(version)..". Old cars deleted")
	end
end

function freeCarPosition()
	local result = dbPoll(dbQuery(db, "SELECT ID FROM vehicle ORDER BY in_index ASC LIMIT 1"), -1)
	local id = tonumber(result[1].ID)
	dbExec(db, "DELETE FROM vehicle WHERE ID = ?", id)
	local veh = getVehicleByID(id)
	outputDebugString ("[CAR-USED][TRASH] "..exports.car_system:getVehicleModName(veh).." ("..getElementModel(veh)..") was trashed from used carshop")
	local posID = getElementData(veh, "usedauto.posID")
	position[posID][pVehicle] = false
	if isElement(veh) then
		destroyElement(veh)
	end	
end

function getVehicleByID(id)
	id = tonumber(id)
	local v = false
	for _, veh in ipairs (getElementsByType("vehicle")) do
		if getElementData(veh, "usedauto.ID") == id then
			v = veh
			break
		end
	end
	return v
end

function getFreePosition()
	for i, pos in ipairs(position) do
		if (not pos[pVehicle]) then
			return i
		end
	end
end


function spawnCar(car, posID, id)
	local pos = position[posID]
	local Vehicle = createVehicle(car.Model, pos[pX], pos[pY], pos[pZ], 0, 0, pos[pRotZ])
	pos[pVehicle] = Vehicle
	
	local color = split(car.Colors, ',')
	local r1 = color[1] or 255
	local g1 = color[2] or 255
	local b1 = color[3] or 255
	local r2 = color[4] or 255
	local g2 = color[5] or 255
	local b2 = color[6] or 255
	setVehicleColor(Vehicle, r1, g1, b1, r2, g2, b2)
	local paintjob = car.Paintjob
	if (paintjob ~= "3") and (paintjob ~= 3) and (paintjob ~= "") then
		setElementData(Vehicle, "paintjob", paintjob)
	end
	local customTuning = fromJSON(car.customTuning)
	if (customTuning) then
		local toner = customTuning.toner
		local xenon = customTuning.xenon
		if (toner) then
			setElementData(Vehicle, "tint_front", toner[1])
			setElementData(Vehicle, "tint_side", toner[2])
			setElementData(Vehicle, "tint_rear", toner[3])
		end
		if (xenon) then
			setVehicleHeadLightColor(Vehicle, unpack(xenon))
			setElementData(Vehicle, "xenon", tostring(xenon[1])..","..tostring(xenon[2])..","..tostring(xenon[3]))
		end
	end
	
	setElementData(Vehicle, "usedauto.ID", id)
	setElementData(Vehicle, "usedauto.posID", posID)
	setElementData(Vehicle, "usedauto.price", car.price)
	setElementData(Vehicle, "usedauto.owner", car.owner)
	setElementData(Vehicle, "usedauto.nomer", car.nomer)
	setElementData (Vehicle, "doNotRemoveThisCarOnTimeout", true )
	setElementData(Vehicle, "fuel", 0)
	setElementData(Vehicle, "odometer", car.odometer)
	
	local upgrades = split(tostring(car.Upgrades), ';')
	for _, upgrade in ipairs(upgrades) do
		local upgrParts = split(upgrade, ',')
		setElementData(Vehicle, upgrParts[1], (tonumber(upgrParts[2]) or upgrParts[2]))
	end
	
	setVehicleDamageProof(Vehicle, true)
	setTimer ( freezeCar, 3000, 1, Vehicle)	
	--setElementFrozen ( Vehicle, true )
	if (car.Model == 587) or (car.Model == 562) then
		setVehicleOverrideLights(Vehicle, 1)
	end
	setElementDimension(Vehicle, pos[pDim])
	setElementInterior(Vehicle, 1)
end

function freezeCar(veh)
	if isElement(veh) then
		setElementFrozen ( veh, true )
	end
end

-- function addCarToUsedShop(Model, owner, price, nomer, Upgrades, Colors, Paintjob, src, handling, oldOwners, customTuning, fuelOctane, odometer)
function addCarToUsedShop(data, money, player)
	local ID = getFreeID()
	if ID > #position then
		freeCarPosition()
		ID = getFreeID()
	end
	local freePosition = getFreePosition()
	local pos = position[freePosition]
	dbExec(db, [[INSERT INTO vehicle (ID, Model, owner, price, nomer, Upgrades, Colors, Paintjob, in_index, handling, oldOwners, customTuning, fuelOctane, odometer)
		VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]],
		ID, data.model, data.owner, money, data.licensep, data.upgrades, data.colors, data.paintjob, getLastIndex()+1, data.handling, nil, data.customTuning, data.fuelOctane, data.odometer)
	local car = dbPoll(dbQuery(db, "SELECT * FROM vehicle WHERE ID = ?", ID), -1)
	spawnCar(car[1], freePosition, ID)
	-- outputDebugString ("[CAR-USED][ADD] "..getPlayerName(src).." (acc "..getAccountName(getPlayerAccount(src))..", money "..getPlayerMoney(src)..") sold "..exports.car_system:getVehicleModName(Model).." ("..Model..") with price "..tonumber(price).." into used carshop")
end

function getFreeID()
	newID = false
	local result = dbPoll(dbQuery(db, "SELECT ID FROM vehicle ORDER BY ID ASC"), -1)
	for i, vehRow in pairs (result) do
		if vehRow.ID ~= i then
			newID = i
			break
		end
	end
	if newID then
		return newID
	else
		return #result + 1
	end
end

function getLastIndex()
	local index
	local result = dbPoll(dbQuery(db, "SELECT in_index FROM vehicle ORDER BY in_index DESC"), -1)
	if type(result) == "table" and #result ~= 0 then
		index = tonumber(result[1].in_index)
	else
		index = 1
	end
	return index
end

function onBuyUsedCar()
	local vehicle = getPedOccupiedVehicle(client)
	if (not vehicle) then return end
	local ID = getElementData(vehicle, "usedauto.ID")
	local posID = getElementData(vehicle, "usedauto.posID")
	if (not ID) or (not posID) then return end

	local result = dbPoll(dbQuery(db, "SELECT * FROM vehicle WHERE ID = ?", ID), -1)
	if (not result) or (#result ~= 1) then
		outputDebugString("[CAR-USED][ERROR] Problem with car ID "..ID.." result="..tostring(result and #result), 1)
		return
	end
	
	result = result[1]
	result.price = tonumber(result.price)
	result.model = tonumber(result.Model)
	result.colors = result.Colors
	result.upgrades = result.Upgrades
	result.paintjob = result.Paintjob
	result.licensep = result.nomer

	if not isResourceRunning("car_system") then
		outputDebugString("[CAR-USED][ERROR] Unable to buy car - car_system is not running", 1)
		return
	end
	
	if exports.car_system:BuyVehicleByUsed(client, result, vehicleExitPosition) then
		destroyElement(vehicle)
		position[posID][pVehicle] = false
		dbExec(db, "DELETE FROM vehicle WHERE ID = ?", ID)	
	end
end
addEvent("OnPlayerBuyNewUsedCar", true)
addEventHandler("OnPlayerBuyNewUsedCar", resourceRoot, onBuyUsedCar)


-- addCommandHandler("addusedcar", function(source, _, Model, owner, price, nomer, Upgrades, Colors, Paintjob)
	-- if (not hasObjectPermissionTo(source, "command.setmoney")) then
		-- outputChatBox("Только Вова может добавлять сюда машины!", source, 255, 50, 50)
		-- return
	-- end
	-- outputDebugString ("[CAR-USED][ADMINADDING] "..getPlayerName(source).." (acc "..getAccountName(getPlayerAccount(source))..") added "..tonumber(Model).." with price "..tonumber(price).." into used carshop")
	-- addCarToUsedShop(Model, owner, price, nomer, Upgrades, Colors, Paintjob, source, "", owner, "")
-- end)

function checkNomerExistance(nomer)
	local data = dbPoll(dbQuery(db, "SELECT nomer, owner, Model FROM vehicle WHERE nomer = ?", nomer), -1)
	for _, uData in ipairs(data) do
		uData.model = uData.Model
		uData.licensep = uData.nomer
	end
	return (#data > 0), data
end


--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end

-- ==========     Связанное с удалением аккаунтов     ==========
function endOfWipe()
	setTimer(restartResource, 1000, 1, resource)
end

function wipeAccount(accName)
	local cars = dbPoll(dbQuery(db, "SELECT * FROM vehicle WHERE owner = ?", accName), -1)
	for _, car in ipairs(cars) do
		dbExec(db, "DELETE FROM vehicle WHERE ID = ?", car.ID)
		outputDebugString(string.format("[CAR-USED] Deleted used car ID %i, licensep %s, owner %s",
			car.ID, car.nomer, car.owner
		))
	end
end

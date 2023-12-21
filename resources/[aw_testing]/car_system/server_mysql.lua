
--	==========     Обновление винилов     ==========
function checkAndUpdatePaintjobs()
	local rt = getRealTime()
	if (paintjobsToUpdate[rt.month+1]) and (paintjobsToUpdate[rt.month+1][rt.monthday]) then
		outputDebugString(string.format("[DBUPDATE] Wow, it's a %02i.%02i! Time to update paintjobs.", rt.month+1, rt.monthday))
		for _, paintjob in ipairs(paintjobsToUpdate[rt.month+1][rt.monthday]) do
			local query = ""
			if (paintjob.pType == "apply") then
				query = exports.mysql:dbPrepareString("vehicle", "UPDATE ?? SET `paintjob`=? WHERE `licensep`=? AND owner=?;", paintjob.fileName, paintjob.licensep, paintjob.owner)
			elseif (paintjob.pType == "remove") then
				query = exports.mysql:dbPrepareString("vehicle", "UPDATE ?? SET `paintjob`='' WHERE `paintjob`=?;", paintjob.fileName)
			elseif (paintjob.pType == "customQuery") then
				query = exports.mysql:dbPrepareString("vehicle", paintjob.customQuery)
			end
			exports.mysql:dbExec("", query)
			outputDebugString(query)
		end
	else
		outputDebugString("No paintjob updates found")
	end
	return true
end

--	==========     Проверка и обновление таблиц     ==========
function checkAndUpdateTables()
	--[[local result = exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")
	if (tonumber(result[1].value) < 1.1) then
		updateTo_1_1()
	end
	
	result = exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")
	if (tonumber(result[1].value) < 1.2) then
		updateTo_1_2()
	end
	
	result = exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")
	if (tonumber(result[1].value) < 1.3) then
		updateTo_1_3()
	end
	
	result = exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")
	if (tonumber(result[1].value) < 1.4) then
		addUserOrder()
	end
	
	result = exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")
	if (tonumber(result[1].value) < 1.5) then
		convertXenonStoreFormat()
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 1.6) then
		pulverizeCars(1.6, {
			[562] = {price =   230000, name = "Nissan 240SX"},
			[566] = {price =   500000, name = "Toyota Mark II JZX100"},
			[451] = {price = 12000000, name = "Bentley Continental"},
			[400] = {price = 10500000, name = "Mercedes-Benz GLE63 AMG Coupe"},
			[416] = {price = 20000000, name = "Rolls Royce Ghost EWB"},
			[536] = {price =  2000000*57.34, name = "Koenigsegg Regera 2016"},
			[467] = {price =   875000, name = "Toyota Camry"},
			[492] = {price =   700000, name = "Audi A6"},
			[543] = {price =   400000, name = "Nissan Silvia S15"},
			[558] = {price =  1100000, name = "Nissan Skyline R34 GT-R"},
		})
	end
	
	result = exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")
	if (tonumber(result[1].value) < 1.7) then
		convertM4AndR8Tuning()
	end
	
	result = exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")
	if (tonumber(result[1].value) < 1.8) then
		addFlagColumn()
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 1.9) then
		pulverizeCars(1.9, {
			[579] = {price = 7000000, name = "Cadillac Escalade ESV 2016"},
			[602] = {price = 6000000, name = "BMW 850CSI E31"},
			[567] = {price =  230000, name = "Mazda 626"},
			[405] = {price =  950000, name = "Subaru Impreza WRX STi 09"},
			[479] = {price =  450000, name = "BMW M5 E28"},
			[438] = {price =  700000, name = "BMW 730i E38"},
			[587] = {price =  190000, name = "Toyota Sprinter Trueno AE86"},
		})
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.0) then
		pulverizeCars(2.0, {
			[409] = {price = 1100000, name = "BMW M5 E39"},
		})
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.1) then
		resetBoatsHandling()
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.2) then
		resetWrongLicenseps()
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.3) then
		pulverizeCars(2.3, {
			[551] = {price = 8547500, name = "Tesla Model S P90D"},
		})
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.4) then
		pulverizeCars(2.4, {
			[456] = {price = 248579389, name = "Ferrari LaFerrari"},
		})
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.5) then
		pulverizeCars(2.5, {
			[600] = {price = 13500000, name = "Mercedes-Benz G63 Coupe"},
			[419] = {price = 188075432, name = "Mercedes-Benz AMG Project ONE"},
			[442] = {price = 20300000, name = "BMW Z4"},
			[489] = {price = 10500000, name = "Mercedes-Benz X-Class"},
			[562] = {price = 22170001, name = "Zenvo STI GT 2019"},
			[466] = {price = 15000000, name = "GMC"},
		})
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.6) then
		pulverizeCars(2.6, {
			[410] = {price = 295875000, name = "Vemeno"},
		})
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.7) then
		convert_OldID_to_newID(534, 562, 2.7)
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.8) then
		pulverizeCars(2.8, {
			[459] = {price = 100000000, name = "artem1"},
			[482] = {price = 100000000, name = "artem2"},
			[528] = {price = 100000000, name = "artem3"},
			[483] = {price = 100000000, name = "artem4"},
			[477] = {price = 100000000, name = "artem5"},
			[609] = {price = 100000000, name = "artem6"},
			[588] = {price = 100000000, name = "artem7"},
			[456] = {price = 100000000, name = "artem8"},
		})
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 2.9) then
		clearHanling (2.9, {"tractionMultiplier", "tractionLoss"}, {1, 1})
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 3.0) then
		fixHandling (3.0)
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 3.1) then
		removePoliceNumber (3.1)
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 3.2) then
		pulverizeCars(3.2, {
			[502] = {price = 18000000, name = "Audi TT"},
			[596] = {price = 8000000, name = "Audi A8 D4"},
			[475] = {price = 10000000, name = "BMW F30 320d"},
			[597] = {price = 1320000, name = "BMW M5 E34"},
			[434] = {price = 0, name = "MB C63s"},
			[605] = {price = 11400000, name = "Audi RS5"},
			[504] = {price = 19900000, name = "Lexus LC500"},
			[424] = {price = 5000000, name = "Koenigsegg Jesko"},
			[421] = {price = 0, name = "Lexus ES250"},
			[439] = {price = 6000000, name = "Dodge Charger R/T"},
			[405] = {price = 650000, name = "Subaru Impreza"},
		})
	end
	
	result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 3.3) then
		delAllCars (3.3)
	end]]
	
	
	--[[result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if result < 3.4 then
		reloadCarsCount (true)
	end]]
	
	
	-- result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	-- if (result < 3.5) then
		-- pulverizeCars(3.5, {
			-- [467] = {price =   1, name = "Nissan 240SX"},
			-- [566] = {price =   2, name = "Toyota Mark II JZX100"},
			-- [495] = {price = 3, name = "Bentley Continental"},
			-- [559] = {price = 4, name = "Mercedes-Benz GLE63 AMG Coupe"},
			-- [517] = {price = 5, name = "Rolls Royce Ghost EWB"},
			-- [587] = {price =  6, name = "Koenigsegg Regera 2016"},
			-- [478] = {price =   7, name = "Toyota Camry"},
			-- [576] = {price =   8, name = "Audi A6"},
			-- [503] = {price =   9, name = "Nissan Silvia S15"},
			-- [526] = {price =  10, name = "Nissan Skyline R34 GT-R"},
		-- })
	-- end
	
	-- result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	-- if (result < 3.6) then
		-- delAllCarsObnova (3.6)
	-- end
	
	--[[result = tonumber(exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")[1].value)
	if (result < 4.0) then
		pulverizeCars(4.0, {
			[475] = {price = 0, name = "Volkswagen Touareg"},
			[525] = {price = 4000000, name = "Volkswagen Touareg"},
			[442] = {price = 25000000, name = "Volkswagen Touareg"},
			[477] = {price = 2100000, name = "Volkswagen Touareg"},
			[470] = {price = 15000000, name = "Volkswagen Touareg"},
			[516] = {price = 2000000, name = "Volkswagen Touareg"},
			[507] = {price = 1500000, name = "Volkswagen Touareg"},
			[466] = {price = 10000000, name = "Volkswagen Touareg"},
			[560] = {price = 3500000, name = "Volkswagen Touareg"},
			[458] = {price = 4000000, name = "Volkswagen Touareg"},
			[490] = {price = 2500000, name = "Volkswagen Touareg"},
			[576] = {price = 750000, name = "Volkswagen Touareg"},
			[467] = {price = 1400000, name = "Volkswagen Touareg"},
			[529] = {price = 1950000, name = "Volkswagen Touareg"},
			[541] = {price = 13500000, name = "Volkswagen Touareg"},
			[596] = {price = 45000000, name = "Volkswagen Touareg"},
			[405] = {price = 33000000, name = "Volkswagen Touareg"},
			[517] = {price = 90000000, name = "Volkswagen Touareg"},
			[434] = {price = 1000000000, name = "Volkswagen Touareg"},
			[402] = {price = 1000000000, name = "Volkswagen Touareg"},
			[439] = {price = 950000, name = "Volkswagen Touareg"},
		})
	end]]
	
	
	return true
end

function convert_OldID_to_newID(old, new, ver)
	exports.mysql:dbExec("dbData", "UPDATE `car_system_vehicle` SET `model`= "..new.." WHERE `model` = "..old)
	exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '"..ver.."');")
	outputDebugString("[DBUPDATE] Database in car_system updated to version "..ver)
end

local donat = {
	[466] = true,
	[405] = true,
	[474] = true,
	[518] = true,
	[605] = true,
	[477] = true,
	[562] = true,
	[491] = true,
	[412] = true,
	[419] = true,
	[459] = true,
	[545] = true,
	[413] = true,
	[528] = true,
	[599] = true,
	[453] = true,
}

function delAllCarsObnova(newVersionNumber)
	local carTable = exports.mysql:dbQuery(-1, "vehicle", "SELECT * FROM ??")
	
	for _, car in ipairs(carTable) do
		if not donat[car.model] and car.owner ~= "Enzo" and car.owner ~= "HydrX" then
			local acc = getAccount(car.owner)
			if acc then
				exports.car_nomerchange:addNomerToBase(car.licensep, car.owner)
				outputDebugString(string.format("Account %s saved licensep %s for car ID %i model %i",
					car.owner, car.licensep, car.ID, car.model
				))
			else
				outputDebugString(string.format("Not found account %s for car ID %i (model %i licensep %s)",
					car.owner, car.ID, car.model, car.licensep
				))
			end
			exports.mysql:dbExec("vehicle", "DELETE FROM ?? WHERE ID = ?;", car.ID)
			exports.mysql:dbExec("handling", "DELETE FROM ?? WHERE ID = ?;", car.ID)
		end
	end
	
	if (#carTable > 0) then
	else
		exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '"..tostring(newVersionNumber).."');")
		outputDebugString("[DBUPDATE] Database in car_system updated to version "..tostring(newVersionNumber)..". Replaced cars deleted")
		setTimer(restartResource, 50, 1, resource)
	end
end

function delAllCars(newVersionNumber)
	local carTable = exports.mysql:dbQuery(-1, "vehicle", "SELECT ID, owner, model, licensep FROM ??")
	
	for _, car in ipairs(carTable) do
		local acc = getAccount(car.owner)
		if acc then
			exports.car_nomerchange:addNomerToBase(car.licensep, car.owner)
		end
		exports.mysql:dbExec("vehicle", "DELETE FROM ?? WHERE ID = ?;", car.ID)
		exports.mysql:dbExec("handling", "DELETE FROM ?? WHERE ID = ?;", car.ID)
	end
	
	if (#carTable > 0) then
		setTimer(delAllCars, 50, 1, newVersionNumber)
	else
		exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '"..tostring(newVersionNumber).."');")
		outputDebugString("[DBUPDATE] Database in car_system updated to version "..tostring(newVersionNumber)..". Replaced cars deleted")
		setTimer(restartResource, 50, 1, resource)
	end
end

function clearHanling(ver, name, val)
	local result = exports.mysql:dbQuery(-1, "handling", "SELECT * FROM ??")
	for i, v in ipairs (result) do
		local t = fromJSON(v["handling"])
		if type(t) == "table" then
			if type(name) == "table" then
				for num, property in ipairs (name) do
					if t[property] and tonumber(t[property]) > val[num] then
						exports.mysql:dbExec("handling", "REPLACE ?? (`ID`, `handling`) VALUES ("..v["ID"]..", '');")
					end
				end
			else
				if t[name] and tonumber(t[name]) > val then
					exports.mysql:dbExec("handling", "REPLACE ?? (`ID`, `handling`) VALUES ("..v["ID"]..", '');")
				end
			end
		end
	end
	if ver then
		exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '"..ver.."');")
		outputDebugString("[DBUPDATE] Database in car_system updated to version "..ver)
	end
end

function fixHandling(ver)
	local result = exports.mysql:dbQuery(-1, "vehicle", "SELECT * FROM ??")
	for i, v in ipairs (result) do
		local hand = exports.mysql:dbQuery(-1, "handling", "SELECT * FROM ?? WHERE ID = ?;", v["ID"])
		if not hand or #hand == 0 then
			exports.mysql:dbExec("handling", "REPLACE ?? (`ID`, `handling`) VALUES ("..v["ID"]..", '');")
		elseif #hand > 1 then
			for k, m in ipairs (hand) do
				exports.mysql:dbExec("handling", "DELETE FROM ?? WHERE ID = ?;", car.ID)
			end
			exports.mysql:dbExec("handling", "REPLACE ?? (`ID`, `handling`) VALUES ("..hand[1]["ID"]..", '');")
		end
	end
	exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '"..ver.."');")
	outputDebugString("[DBUPDATE] Database in car_system updated to version "..ver)
end

function removePoliceNumber(ver)
	local res = exports.mysql:dbQuery(-1, "vehicle", "SELECT * FROM `car_system_vehicle` WHERE `licensep` LIKE '%b-%' AND  `flag` IS NULL")
	for i, v in ipairs (res) do
		local licensePlate = generateNumberplate("a", 77)
		exports.mysql:dbExec("vehicle", "UPDATE ?? SET licensep = ? WHERE ID = ?;", licensePlate, v.ID)
	end
	exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '"..ver.."');")
	outputDebugString("[DBUPDATE] Database in car_system updated to version "..ver)
	setTimer(restartResource, 50, 1, resource)
end

--	==========     Сброс номеров мотоциклов на машинах и наоборот     ==========
function resetWrongLicenseps()
	outputDebugString("[DBUPDATE] Old database in car_system! It has bike licenseps on cars and vice versa. Updating to version 2.2")
	local startTime = getTickCount()
	wrongLicensepsResult = exports.mysql:dbQuery(-1, "vehicle", "SELECT * FROM ?? WHERE `licensep` LIKE 'c-%' AND `model` NOT IN (448, 461, 462, 463, 468, 471, 521, 522, 523, 581, 586);")
	outputDebugString(string.format("[DBUPDATE] Found %i cars with bike licenseps in %i ms", #wrongLicensepsResult, getTickCount()-startTime))
	Mode = "wrongCars"
	setTimer(resetWrongLicensepsWorker, 50, 1, 1)
end
function resetWrongLicensepsWorker(startRow)
	local result = wrongLicensepsResult
	if (startRow <= #result) then
		local portionSize = 20
		local portionStart, updatedCars = getTickCount(), 0
		local endRow = startRow + portionSize - 1
		if (Mode == "wrongCars") then	-- машины с номерами мотоциклов
			for i = startRow, endRow do
				local row = result[i]
				if (row) then
					local newLicensep = exports.car_system:generateNumberplate()
					exports.mysql:dbExec("vehicle", "UPDATE ?? SET licensep = ? WHERE ID = ?;", newLicensep, row.ID)
					outputDebugString(string.format("[DBUPDATE] Updated licensep on car ID %i model %i licensep %s owner %s. New licensep: %s", row.ID, row.model, row.licensep, row.owner, newLicensep))
					updatedCars = updatedCars + 1
				end
			end
		else						-- мотоциклы с номерами машин
			for i = startRow, endRow do
				local row = result[i]
				if (row) then
					local newLicensep = exports.car_system:generateNumberplate("c")
					exports.mysql:dbExec("vehicle", "UPDATE ?? SET licensep = ? WHERE ID = ?;", newLicensep, row.ID)
					outputDebugString(string.format("[DBUPDATE] Updated licensep on bike ID %i model %i licensep %s owner %s. New licensep: %s", row.ID, row.model, row.licensep, row.owner, newLicensep))
					updatedCars = updatedCars + 1
				end
			end
		end
		local elapsed = getTickCount()-portionStart
		outputDebugString(string.format("Updated %i vehicles in %i ms. Speed: %.2f cars/s", updatedCars, elapsed, updatedCars/(elapsed/1000)))
		
		setTimer(resetWrongLicensepsWorker, 50, 1, endRow+1)
	else
		if (Mode == "wrongCars") then
			Mode = "wrongBikes"
			local startTime = getTickCount()
			wrongLicensepsResult = exports.mysql:dbQuery(-1, "vehicle", "SELECT * FROM ?? WHERE `licensep` NOT LIKE 'c-%' AND `model` IN (448, 461, 462, 463, 468, 471, 521, 522, 523, 581, 586);")
			outputDebugString(string.format("[DBUPDATE] Found %i bikes with car licenseps in %i ms", #wrongLicensepsResult, getTickCount()-startTime))
			setTimer(resetWrongLicensepsWorker, 50, 1, 1)
		else
			exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '2.2');")
			outputDebugString("[DBUPDATE] Database in car_system updated to version 2.2")
			setTimer(restartResource, 50, 1, resource)
		end
	end
end


--	==========     Сброс хандлинга на лодках     ==========
function resetBoatsHandling()
	outputDebugString("[DBUPDATE] Old database in car_system! Needs to reset handling on boats. Updating to version 2.1")
	local vehicleTable = exports.mysql:getTableName("vehicle")
	exports.mysql:dbExec("handling", "UPDATE ?? SET `handling` = '' WHERE `ID` IN (SELECT `ID` FROM ?? WHERE `model` IN (430, 446, 452, 453, 454, 472, 473, 484, 493, 595));", vehicleTable)
	exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '2.1');")
	outputDebugString("[DBUPDATE] Database in car_system updated to version 2.1")
end

--	==========     Добавление поля флагов для машины     ==========
function addFlagColumn()
	outputDebugString("[DBUPDATE] Old database in car_system! Needs to add column `flag`. Updating to version 1.8")
	exports.mysql:dbExec("vehicle", "ALTER TABLE ?? ADD COLUMN flag VARCHAR(20);")
	exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '1.8');")
	outputDebugString("[DBUPDATE] Database in car_system updated to version 1.8")
end

--	==========     Обновление тюнинга на M4 и R8     ==========
local stats
function convertM4AndR8Tuning()
	outputDebugString("[DBUPDATE] Old database in car_system! It can has tuning mistakes on M4 and R8. Updating to version 1.7")
	local startTime = getTickCount()
	
	local result = exports.mysql:dbQuery(-1, "vehicle", "SELECT COUNT(ID) AS count, MAX(ID) AS maxID FROM ?? WHERE model IN (527, 422);")
	local carsCount = result[1].count
	local maxID = result[1].maxID
	stats = {updatedCars=0, elapsed=getTickCount()-startTime, startTime=startTime, carsCount=carsCount, maxID=maxID}
	setTimer(convertM4AndR8TuningWorker, 50, 1, 0)
	
	outputDebugString(string.format("[DBUPDATE] Found %i cars in %i ms, maxID = %i", carsCount, getTickCount()-startTime, maxID))
end
function convertM4AndR8TuningWorker(startID)
	if (startID < stats.maxID) then
		local portionSize = 100
		local portionStart = getTickCount()
		local updatedCars = 0
		
		local carsTable = exports.mysql:dbQuery(-1, "vehicle", "SELECT ID, model, owner, licensep, upgrades FROM ?? WHERE ID > ? AND model IN (527, 422) ORDER BY ID ASC LIMIT ?;", startID, portionSize)
		for _, car in ipairs(carsTable) do
			local upgrades = {}
			for _, upgrade in ipairs(split(car.upgrades, ";")) do
				local upgradeSplitted = split(upgrade, ",")
				table.insert(upgrades, {upgName=upgradeSplitted[1], upgValue=tostring(upgradeSplitted[2])})
			end
		
			if (tonumber(car.model) == 527) then
				local tuning = {}
				local changed = ""
				for index, upgrade in ipairs(upgrades) do
					if (upgrade.upgName == "bumper_f")	and (tonumber(upgrade.upgValue) == 1) or
						(upgrade.upgName == "bumper_r") and (tonumber(upgrade.upgValue) == 1) or
						(upgrade.upgName == "skirts")	and (tonumber(upgrade.upgValue) == 1) or
						(upgrade.upgName == "fenders_f")and (tonumber(upgrade.upgValue) == 1) or
						(upgrade.upgName == "fenders_r")and (tonumber(upgrade.upgValue) == 1) or
						(upgrade.upgName == "bonnet")	and (tonumber(upgrade.upgValue) == 1) or
						(upgrade.upgName == "diffuser") and (tonumber(upgrade.upgValue) == 1) then
						changed = changed..string.format("%s,%s;", upgrade.upgName, tostring(upgrade.upgValue))
					else
						table.insert(tuning, upgrade.upgName..","..upgrade.upgValue)
					end
				end
				
				if (changed ~= "") then
					exports.mysql:dbExec("vehicle", "UPDATE ?? SET upgrades = ? WHERE ID = ?;", table.concat(tuning, ";"), car.ID)
					outputDebugString(string.format("[DBUPDATE] Updated tuning on ID %i licensep %s owner %s. Removed: %s", car.ID, car.licensep, car.owner, changed))
					updatedCars = updatedCars + 1
				end
				
			elseif (tonumber(car.model) == 422) then
				local changed = false
				local tuning = {}
				for _, upgrade in ipairs(upgrades) do
					if (upgrade.upgName == "spoiler") and (tonumber(upgrade.upgValue) == 4) then
						changed = true
						upgrade.upgValue = "5"
						table.insert(tuning, upgrade.upgName..","..upgrade.upgValue)
					end
				end
				
				if (changed) then
					exports.mysql:dbExec("vehicle", "UPDATE ?? SET upgrades = ? WHERE ID = ?;", table.concat(tuning, ";"), car.ID)
					outputDebugString(string.format("[DBUPDATE] Updated spoiler on ID %i licensep %s owner %s.", car.ID, car.licensep, car.owner))
					updatedCars = updatedCars + 1
				end
			end
			startID = car.ID
		end
		
		local thisPortion = getTickCount()-portionStart
		stats.updatedCars = stats.updatedCars + updatedCars
		stats.elapsed = stats.elapsed + thisPortion
		outputDebugString(string.format("[DBUPDATE] Updated %i cars in %i ms. Total: %.2f%% cars", updatedCars, thisPortion, startID/stats.maxID*100))
		
		setTimer(convertM4AndR8TuningWorker, 50, 1, startID, stats)
	else
		outputDebugString(string.format("[DBUPDATE] Successfully updated %i of %i cars in %i ms (%i ms total).", stats.updatedCars, stats.carsCount, stats.elapsed, getTickCount()-stats.startTime))
		exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '1.7');")
		outputDebugString("[DBUPDATE] Database in car_system updated to version 1.7")
		setTimer(restartResource, 50, 1, resource)
	end
end

--	==========     Добавление поля userOrder     ==========
function convertXenonStoreFormat()
	outputDebugString("[DBUPDATE] Old database in car_system! Xenon is stored in wrong format. Updating to version 1.4")
	local startTime = getTickCount()
	
	local result = exports.mysql:dbQuery(-1, "vehicle", "SELECT COUNT(ID) AS count, MAX(ID) AS maxID FROM ??;")
	local carsCount = result[1].count
	local maxID = result[1].maxID
	setTimer(convertXenonStoreFormatWorker, 50, 1, 0, {updatedCars=0, elapsed=getTickCount()-startTime, startTime=startTime, carsCount=carsCount, maxID = maxID})
	
	outputDebugString(string.format("Found %i cars in %i ms, maxID = %i", carsCount, getTickCount()-startTime, maxID))
end
function convertXenonStoreFormatWorker(startID, stats)
	if (startID < stats.maxID) then
		local portionSize = 500
		local portionStart = getTickCount()
		local updatedCars = 0
		
		local carsTable = exports.mysql:dbQuery(-1, "vehicle", "SELECT ID, customTuning FROM ?? WHERE ID > ? ORDER BY ID ASC LIMIT ?;", startID, portionSize)
		for _, car in ipairs(carsTable) do
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
				exports.mysql:dbExec("vehicle", "UPDATE ?? SET customTuning = ? WHERE ID = ?;", toJSON(newData, true), car.ID)
				updatedCars = updatedCars + 1
			end
			startID = car.ID
		end
		
		local thisPortion = getTickCount()-portionStart
		stats.updatedCars = stats.updatedCars + updatedCars
		stats.elapsed = stats.elapsed + thisPortion
		outputDebugString(string.format("Updated %i cars in %i ms. Total: %.2f%% cars", updatedCars, thisPortion, startID/stats.maxID*100))
		
		setTimer(convertXenonStoreFormatWorker, 50, 1, startID, stats)
	else
		outputDebugString(string.format("Successfully updated %i of %i cars in %i ms (%i ms total).", stats.updatedCars, stats.carsCount, stats.elapsed, getTickCount()-stats.startTime))
		exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '1.5');")
		outputDebugString("[DBUPDATE] Database in car_system updated to version 1.5")
	end
end

--	==========     Добавление поля userOrder     ==========
function addUserOrder()
	outputDebugString("[DBUPDATE] Old database in car_system! userOrder column is missing. Updating to version 1.4")
	local startTime = getTickCount()
	
	exports.mysql:dbExec("vehicle", "ALTER TABLE ?? ADD userOrder SMALLINT UNSIGNED;")
	local allOwners = exports.mysql:dbQuery(-1, "vehicle", "SELECT DISTINCT owner FROM ??;")
	local carsCount = exports.mysql:dbQuery(-1, "vehicle", "SELECT COUNT(ID) AS count FROM ??;")[1].count
	setTimer(addUserOrderWorker, 50, 1, allOwners, 1, {updatedCars=0, updatedUsers=0, elapsed=getTickCount()-startTime, startTime=startTime, carsCount=carsCount})
	
	outputDebugString(string.format("Found %i owners and %i cars in %i ms", #allOwners, carsCount, getTickCount()-startTime))
end
function addUserOrderWorker(ownersTable, startID, stats)
	if (startID <= #ownersTable) then
		local portionSize = 50
		local endID = startID + portionSize - 1
		if (endID > #ownersTable) then
			endID = #ownersTable
		end
		local portionStart = getTickCount()
		local updatedCars = 0
		
		for i = startID, endID do
			local owner = ownersTable[i].owner
			local carsTable = exports.mysql:dbQuery(-1, "vehicle", "SELECT ID FROM ?? WHERE owner = ? ORDER BY ID ASC;", owner)
			local userOrder = 1
			for _, row in ipairs(carsTable) do
				exports.mysql:dbExec("vehicle", "UPDATE ?? SET userOrder = ? WHERE ID = ?;", userOrder, row.ID)
				userOrder = userOrder + 1
				updatedCars = updatedCars + 1
			end
			stats.updatedUsers = stats.updatedUsers + 1
		end
		
		local thisPortion = getTickCount()-portionStart
		stats.updatedCars = stats.updatedCars + updatedCars
		stats.elapsed = stats.elapsed + thisPortion
		outputDebugString(string.format("Updated %i cars in %i ms. Total: %.2f%% players and %.2f%% cars", updatedCars, thisPortion, stats.updatedUsers/#ownersTable*100, stats.updatedCars/stats.carsCount*100))
		
		setTimer(addUserOrderWorker, 50, 1, ownersTable, endID+1, stats)
	else
		outputDebugString(string.format("Successfully updated %i cars of %i owners in %i ms (%i ms total).", stats.updatedCars, stats.updatedUsers, stats.elapsed, getTickCount()-stats.startTime))
		exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '1.4');")
		outputDebugString("[DBUPDATE] Database in car_system updated to version 1.4")
	end
end


--	==========     Удаление машин и возврат денег за них     ==========
function pulverizeCars(newVersionNumber, carDetails)
	outputDebugString("[DBUPDATE] Old database in car_system! It has replaced cars. Updating to version "..tostring(newVersionNumber))
	
	local IDString = ""
	for model, data in pairs(carDetails) do
		IDString = IDString..tostring(model)..","
	end
	IDString = string.sub(IDString, 1, -2)

	local carCount = exports.mysql:dbQuery(-1, "vehicle", "SELECT COUNT(ID) AS count FROM ?? WHERE model IN ("..IDString..");")
	local fullCount = carCount and carCount[1] and carCount[1].count or 0
	outputDebugString(fullCount.." cars found.")

	if isResourceRunning("bank") and isResourceRunning("car_nomerchange") then
		setTimer(pulverizeCarsWorker, 50, 1, carDetails, IDString, {fullCount=fullCount, newVersionNumber=newVersionNumber})
	else
		outputDebugString("bank or car_nomerchange is not running!!", 1)
		setTimer(restartResource, 10000, 1, resource)
	end
end
function pulverizeCarsWorker(prices, IDString, args)
	local carTable = exports.mysql:dbQuery(-1, "vehicle", "SELECT ID, owner, model, licensep FROM ?? WHERE model IN ("..IDString..") LIMIT 30;")
	
	for _, car in ipairs(carTable) do
		local acc = getAccount(car.owner)
		local money = prices[tonumber(car.model)].price
		local name = prices[tonumber(car.model)].name
		if acc then
			exports.bank:giveAccountBankMoney(acc, money, "RUB")
			exports.car_nomerchange:addNomerToBase(car.licensep, car.owner)
			outputDebugString(string.format("Account %s got %i and saved licensep %s for car ID %i model %i (%s)",
				car.owner, money, car.licensep, car.ID, car.model, name
			))
		else
			outputDebugString(string.format("Not found account %s for car ID %i (model %i licensep %s name %s)",
				car.owner, car.ID, car.model, car.licensep, name
			))
		end
		exports.mysql:dbExec("vehicle", "DELETE FROM ?? WHERE ID = ?;", car.ID)
		exports.mysql:dbExec("handling", "DELETE FROM ?? WHERE ID = ?;", car.ID)
	end
	
	if (#carTable > 0) then
		setTimer(pulverizeCarsWorker, 50, 1, prices, IDString, args)
	else
		exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '"..tostring(args.newVersionNumber).."');")
		outputDebugString("[DBUPDATE] Database in car_system updated to version "..tostring(args.newVersionNumber)..". Replaced cars deleted")
		setTimer(restartResource, 50, 1, resource)
	end
end


--	==========     Старые обновления таблицы     ==========
function updateTo_1_1()
	outputDebugString("[DBUPDATE] Old database in car_system! Updating to version 1.1")
	local tuningTables = exports.mysql:dbQuery(-1, "vehicle", "SELECT ID, upgrades FROM ?? WHERE `upgrades` LIKE '%-%';")
	for _, row in ipairs(tuningTables) do
		row.upgrades = string.gsub(row.upgrades, ",", ";")
		row.upgrades = string.gsub(row.upgrades, "-", ",")
		exports.mysql:dbExec("vehicle", "UPDATE ?? SET upgrades = ? WHERE ID = ?;", row.upgrades, row.ID)
	end		
	exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '1.1');")
	outputDebugString("[DBUPDATE] Database in car_system updated to version 1.1")
end

function updateTo_1_2()
	outputDebugString("[DBUPDATE] Old database in car_system! Needs to modify column `upgrades`. Updating to version 1.2")
	exports.mysql:dbExec("vehicle", "ALTER TABLE ?? MODIFY upgrades TEXT;")
	exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '1.2');")
	outputDebugString("[DBUPDATE] Database in car_system updated to version 1.2")
end

function updateTo_1_3()
	outputDebugString("[DBUPDATE] Old database in car_system! It has replaced cars. Updating to version 1.3")
--[[
	local carCount = exports.mysql:dbQuery(-1, "vehicle", "SELECT COUNT(ID) AS count FROM ?? WHERE model IN (541,551,596,490,526,480);")
	local fullCount = carCount and carCount[1] and carCount[1].count or 0
	outputDebugString(fullCount.." cars found.")
	if isResourceRunning("bank") and isResourceRunning("car_nomerchange") then
		setTimer(pulverizeCars, 50, 1, fullCount, {
			[541] = {price = 12000000, name = "RUF RT35"},
			[551] = {price =  2500000, name = "Ford Focus III RS"},
			[596] = {price =  1200000, name = "Chevrolet Volt"},
			[490] = {price =  5000000, name = "Volvo XC90 R-Design 2015"},
			[526] = {price = 12000000, name = "Mercedes-Benz 560SEC AMG W126 1991"},
			[480] = {price = 11800000, name = "Porsche 911 Carrera S"},
		})
	else
		outputDebugString("bank or car_nomerchange is not running!!", 1)
		setTimer(restartResource, 10000, 1, resource)
	end
]]
end

--	==========     Подготовка таблиц при запуске и импорт старых данных из SQLite     ==========
function prepareTables()
	exports.mysql:dbExec("dbData", "CREATE TABLE IF NOT EXISTS ?? (`key` VARCHAR(255) NOT NULL PRIMARY KEY, `value` VARCHAR(255)) COLLATE=utf8_unicode_ci;")
	exports.mysql:dbExec("handling", "CREATE TABLE IF NOT EXISTS ?? (`ID` INT UNSIGNED NOT NULL PRIMARY KEY, `handling` TEXT) COLLATE=utf8_unicode_ci;")
	exports.mysql:dbExec("vehicle", [[CREATE TABLE IF NOT EXISTS ?? (`ID` INT UNSIGNED NOT NULL PRIMARY KEY, 
		`owner` TEXT, `model` SMALLINT UNSIGNED, `x` FLOAT, `y` FLOAT, `z` FLOAT, `rotZ` FLOAT,
		`colors` VARCHAR(255), `upgrades` TEXT, `paintjob` VARCHAR(255), `HP` FLOAT, `fuel` FLOAT,
		`licensep` VARCHAR(50), `customTuning` TEXT, `fuelOctane` FLOAT, `odometer` FLOAT, `userOrder` SMALLINT UNSIGNED) COLLATE=utf8_unicode_ci;
	]])
	local result = exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")
	if (not result) or (not result[1]) or (not result[1].value) then
		initializeDB()
		return false
	end
	return true
end
function initializeDB()
	outputDebugString("[DBUPDATE] Database in car_system not initialized!")
	if fileExists("cars.db") and fileExists("handling.db") then
		outputDebugString("[DBUPDATE] Found old SQLite database, starting import")
		
		outputDebugString("[DBUPDATE] Truncating tables...")
		exports.mysql:dbExec("handling", "TRUNCATE TABLE ??;")
		exports.mysql:dbExec("vehicle", "TRUNCATE TABLE ??;")
		
		fileCopy("cars.db", "cars.db.old", true)
		fileCopy("handling.db", "handling.db.old", true)
		
		oldDB = dbConnect("sqlite", "cars.db")
		oldHandlingDB = dbConnect("sqlite", "handling.db")
		local result = dbPoll(dbQuery(oldDB, "SELECT COUNT(ID) AS count FROM vehicle"), -1)
		fullCount = result[1].count
		updatedCount = 0
		elapsedTime = 0
		outputDebugString("[DBUPDATE] Found "..tostring(fullCount).." cars.")
		
		oldDBimportPart()
	else
		outputDebugString("[DBUPDATE] Old SQLite databases not found, skipping import")
		endDBinit()
	end
end
function oldDBimportPart()
	local startTime = getTickCount()
	local result = dbPoll(dbQuery(oldDB, "SELECT * FROM vehicle LIMIT 30"), -1)
	if (#result > 0) then
		for _, car in ipairs(result) do
			local handling = dbPoll(dbQuery(oldHandlingDB, "SELECT handling FROM handlings WHERE ID = ?", car.ID), -1)
			exports.mysql:dbExec("vehicle", [[INSERT INTO ?? (`ID`, `owner`, `model`, `x`, `y`, `z`, `rotZ`, `colors`, 
				`upgrades`, `paintjob`, `HP`, `fuel`, `licensep`, `customTuning`, `fuelOctane`, `odometer`)
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);]],
				car.ID, car.owner, car.Model, car.X, car.Y, car.Z, car.RotZ, car.Colors, car.Upgrades,
				car.Paintjob, car.HP, car.fuel, car.licensep, car.customTuning, car.fuelOctane, car.odometer
			)
			if (#handling > 0) then
				exports.mysql:dbExec("handling", "INSERT INTO ?? (`ID`, `handling`) VALUES (?, ?);",
					car.ID, handling[1].handling
				)
			end
			dbExec(oldDB, "DELETE FROM vehicle WHERE ID = ?", car.ID)
			dbExec(oldHandlingDB, "DELETE FROM handlings WHERE ID = ?", car.ID)
		end
		updatedCount = updatedCount + #result
		local portionTime = getTickCount()-startTime
		elapsedTime = elapsedTime + portionTime
		outputDebugString(string.format("[DBUPDATE] Transferred %i cars (%.0f%%). Speed: %.2f cars/s, this portion %i ms", updatedCount, updatedCount/fullCount*100, #result / (portionTime/1000), portionTime))
		setTimer(oldDBimportPart, 50, 1)
	else
		destroyElement(oldDB)
		destroyElement(oldHandlingDB)
		fileDelete("cars.db")
		fileDelete("handling.db")
		outputDebugString(string.format("[DBUPDATE] Fully transferred %i cars in %.2f secs.", fullCount, elapsedTime/1000))
	
		endDBinit()
	end
end
function endDBinit()
	exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '1.0');")
	outputDebugString("[DBUPDATE] Database in car_system updated to version 1.0")
	
	outputDebugString("[DBUPDATE] car_system will be restarted")
	restartResource(resource)
end


--	==========     Парсинг CSV файла     ==========
function fromCSV(input)
    local lines = split(input, "\n")
    local result = {}
    for i, line in ipairs(lines) do
        line = line:gsub("\r", "")
        table.insert(result, parseCSVLine(line))
    end
    return result
end

function parseCSVLine(line, sep)
    local res = {}
    local pos = 1
    sep = sep or ','
    while true do
        local c = string.sub(line,pos,pos)
        if (c == "") then break end
        if (c == '"') then
            -- quoted value (ignore separator within)
            local txt = ""
            repeat
                local startp,endp = string.find(line,'^%b""',pos)
                txt = txt..string.sub(line,startp+1,endp-1)
                pos = endp + 1
                c = string.sub(line,pos,pos)
                if (c == '"') then txt = txt..'"' end
                -- check first char AFTER quoted string, if it is another
                -- quoted string without separator, then append it
                -- this is the way to "escape" the quote char in a quote. example:
                --   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
            until (c ~= '"')
            table.insert(res,txt)
            --assert(c == sep or c == "")
            pos = pos + 1
        else
            -- no quotes used, just look for the first separator
            local startp,endp = string.find(line,sep,pos)
            if (startp) then
                table.insert(res,string.sub(line,pos,startp-1))
                pos = endp + 1
            else
                -- no separator found -> use rest of string and terminate
                table.insert(res,string.sub(line,pos))
                break
            end
        end
    end
    return res
end


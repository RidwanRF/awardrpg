
-- ==========     Работа с БД     ==========
addEventHandler("onResourceStart", resourceRoot, function()
	if isResourceRunning("mysql") then
		exports.mysql:dbExec("storage", "CREATE TABLE IF NOT EXISTS ?? (`ID` INT UNSIGNED NOT NULL PRIMARY KEY, `owner` TEXT, `licensep` VARCHAR(50), `time` INT UNSIGNED) COLLATE=utf8_unicode_ci;")
	else
		outputDebugString("[CAR_NOMERCHANGE][ERROR] Cannot onResourceStart - mysql is not active", 1)
	end
end)

addEvent("dbCallback", false)
addEventHandler("dbCallback", resourceRoot, function(queryResult, callbackFunctionName, callbackArguments)
	_G[callbackFunctionName](queryResult, callbackArguments)
end)

function checkTimedOutLicenseps()
	if isResourceRunning("mysql") then
		exports.mysql:dbQueryAsync("checkTimedOutLicensepsCallback", {}, "storage", "SELECT * FROM ?? WHERE time < ?;", getRealTime().timestamp-storageTime)
	else
		outputDebugString("[CAR_NOMERCHANGE][ERROR] Cannot checkTimedOutLicenseps - mysql is not active", 1)
	end
end
function checkTimedOutLicensepsCallback(result, args)
	for _, row in ipairs(result) do
		exports.mysql:dbExec("storage", "DELETE FROM ?? WHERE ID = ?;", row.ID)
		outputDebugString(string.format("[CAR_NOMERCHANGE][TIMEDOUT] Licensep %s of acc %s timed out and deleted (added at %i)", row.licensep, row.owner, row.time))
		
		local player = getAccountPlayer(getAccount(row.owner))
		if (player) then
			outputBadMessage("Ваш номер "..exports.car_system:convertPlateIDtoLicensep(row.licensep).." был удален из хранилища по истечению срока хранения", player)
		end		
	end
end
setTimer(checkTimedOutLicenseps, 5*60*1000, 0)
setTimer(checkTimedOutLicenseps, 1000, 1)

-- ==========     Отправка списка номеров     ==========
function updateStorageInfo(player)
	player = player or client
	if not isElement(player) then return end
	local accName = getAccountName(getPlayerAccount(player))
	if isResourceRunning("mysql") then
		exports.mysql:dbQueryAsync("updateStorageInfoCallback", {player=player}, "storage",
			"(SELECT ID, licensep, owner, time, NULL AS status, NULL AS comment FROM ?? WHERE owner=?) UNION (SELECT ID, licensep, owner, NULL AS time, status, comment FROM ?? WHERE owner=?);",
			accName, exports.mysql:getTableName("moderation"), accName
		)
	else
		outputDebugString("[CAR_NOMERCHANGE][WARNING] Cannot updateStorageInfo - mysql is not active", 2)
	end
end
function updateStorageInfoCallback(result, args)
	if not isElement(args.player) then return end
	triggerClientEvent(args.player, "refreshStorageList", resourceRoot, result)
end
addEvent("updateStorageInfo", true)
addEventHandler("updateStorageInfo", resourceRoot, updateStorageInfo)
addEventHandler("onPlayerLogin", root, function()
	updateStorageInfo(source)
end)

-- ==========     Сохранение и замена случайным     ==========
function saveAndReplaceRandom()
	if not isResourceRunning("car_system") or not isResourceRunning("mysql") or not isResourceRunning("bank") then
		outputBadMessage("Невозможно сохранить номер.", client)
		return
	end
	
	local vehicle = getPedOccupiedVehicle(client)
	if (not vehicle) then
		outputBadMessage("Вы должны сидеть в машине, чтобы сохранить номер.", client)
		return
	end
	
	local ID = tonumber(getElementData(vehicle, "ID"))
	if (not ID) then
		outputBadMessage("Вы не можете сохранить номер. Это не личная машина.", client)
		return
	end
	
	local oldNomer = getElementData(vehicle, "licensep")
	if (not oldNomer) then return end
	
	if (oldNomer:sub(1, 1) == "b") then
		outputBadMessage("Вы не можете сохранить полицейский номер.", client)
		return
	end
	
	local accName = getAccountName(getPlayerAccount(client))
	local vehOwner = getElementData(vehicle, "owner")
	if (accName ~= vehOwner) then
		outputBadMessage("Вы не можете сохранить номер. Это не ваша машина.", client)
		return
	end
	
	local moneyAmount, currency = savingPrices.saveSetRandom.amount, savingPrices.saveSetRandom.currency
	if (exports.bank:getPlayerBankMoney(client, currency) < moneyAmount) then
		outputBadMessage("Вы не можете сохранить номер. У вас недостаточно средств на банковском счету. Стоимость: "..savingPrices.saveSetRandom.text, client)
		return
	end
	
	local randomNomer
	if not isBikeType(getVehicleType(vehicle)) then
		randomNomer = exports.car_system:generateNumberplate()
	else
		randomNomer = exports.car_system:generateNumberplate("c")
	end
	
	addNomerToBase(oldNomer, accName)
	
	exports.bank:takePlayerBankMoney(client, moneyAmount, currency)
	
	exports.car_system:changeNomer(ID, randomNomer, client)
	setElementData(vehicle, "licensep", randomNomer)

	triggerClientEvent(client, "closePanel", resourceRoot)
	updateStorageInfo(client)

	outputMessage("Вы успешно сохранили номер!", client)
	outputDebugString(string.format("[CAR-NMRCHNG] %s (acc %s, bank %i%s) applied random numberplate %s to his %s (ID %i model %i) for %i%s and saved %s into storage",
		getPlayerName(client), accName, exports.bank:getPlayerBankMoney(client, currency), currency, randomNomer, exports.car_system:getVehicleModName(vehicle), ID, getElementModel(vehicle), moneyAmount, currency, oldNomer))
	triggerClientEvent("playWrenchSound", resourceRoot, getElementPosition(client))
end
addEvent("saveAndReplaceRandom", true)
addEventHandler("saveAndReplaceRandom", resourceRoot, saveAndReplaceRandom)

-- ==========     Добавление номера в список сохраненных     ==========
function addNomerToBase(nomer, accName)
	if isResourceRunning("mysql") then
		exports.mysql:dbExec("storage", "INSERT INTO ?? (`ID`, `owner`, `licensep`, `time`) VALUES (?, ?, ?, ?);", getFreeID("storage"), accName, nomer, getRealTime().timestamp)
	else
		outputDebugString("[CAR_NOMERCHANGE][ERROR] Cannot addNomerToBase - mysql is not active", 1)
	end
end

-- ==========     Замена из хранилища     ==========
function setFromStorage(storageID)
	if isResourceRunning("mysql") then
		storageID = tonumber(storageID)
		exports.mysql:dbQueryAsync("setFromStorageCallback", {player = client, storageID = storageID}, "storage", "SELECT owner, licensep FROM ?? WHERE ID = ?;", storageID)
	else
		outputBadMessage("Невозможно установить номер.", client)
	end
end
function setFromStorageCallback(result, args)
	result = result[1]
	if not isElement(args.player) then return end
	if (not result) then 
		outputBadMessage("Неизвестная ошибка (#2).", args.player)
		return
	end
	
	if not isResourceRunning("car_system") or not isResourceRunning("mysql") or not isResourceRunning("bank") then
		outputBadMessage("Невозможно установить номер (#3).", args.player)
		return
	end
	
	local vehicle = getPedOccupiedVehicle(args.player)
	if (not vehicle) then
		outputBadMessage("Вы должны сидеть в машине, чтобы установить номер.", args.player)
		return
	end
	
	if (string.sub(result.licensep, 1, 1) == "c") then
		if not isBikeType(getVehicleType(vehicle)) then
			outputBadMessage("Вы не можете поставить номер мотоцикла на другой транспорт.", client)
			return
		end
	else
		if not isAutomobileType(getVehicleType(vehicle)) then
			outputBadMessage("Вы не можете поставить автомобильный номер на данный транспорт.", client)
			return
		end
	end
	
	local ID = tonumber(getElementData(vehicle, "ID"))
	if (not ID) then
		outputBadMessage("Вы не можете установить номер. Это не личная машина.", args.player)
		return
	end
	
	local oldNomer = getElementData(vehicle, "licensep")
	if (not oldNomer) then return end
	if (oldNomer:sub(1, 1) == "b") then
		outputBadMessage("Вы не можете изменить номер на полицейском автомобиле.", client)
		return
	end
	
	local account = getPlayerAccount(args.player)
	local accName = getAccountName(account)
	local vehOwner = getElementData(vehicle, "owner")
	if (accName ~= vehOwner) then
		outputBadMessage("Вы не можете установить номер. Это не ваша машина.", args.player)
		return
	end
	if (accName ~= result.owner) then
		outputBadMessage("Неизвестная ошибка (#4).", args.player)
		return
	end
	
	local moneyAmount, currency = savingPrices.onlyLoad.amount, savingPrices.onlyLoad.currency
	if (exports.bank:getPlayerBankMoney(args.player, currency) < moneyAmount) then
		outputBadMessage("Вы не можете установить номер. У вас недостаточно средств на банковском счету. Стоимость: "..savingPrices.onlyLoad.text, args.player)
		return
	end
	
	exports.mysql:dbExec("storage", "DELETE FROM ?? WHERE ID = ?;", args.storageID)
	
	exports.bank:takePlayerBankMoney(args.player, moneyAmount, currency)
	
	exports.car_system:changeNomer(ID, result.licensep, args.player)
	setElementData(vehicle, "licensep", result.licensep)

	triggerClientEvent(args.player, "closePanel", resourceRoot)
	updateStorageInfo(args.player)

	outputMessage("Вы успешно установили номер!", args.player)
	outputDebugString(string.format("[CAR-NMRCHNG] %s (acc %s, bank %i%s) applied numberplate %s from storage to his %s (ID %i model %i licensep %s) for %i%s",
		getPlayerName(args.player), accName, exports.bank:getPlayerBankMoney(args.player, currency), currency, result.licensep, exports.car_system:getVehicleModName(vehicle), ID, getElementModel(vehicle), oldNomer, moneyAmount, currency))
	triggerClientEvent("playWrenchSound", resourceRoot, getElementPosition(args.player))
end
addEvent("setFromStorage", true)
addEventHandler("setFromStorage", resourceRoot, setFromStorage)

-- ==========     Сохранение и установка из хранилища     ==========
function replaceFromStorage(storageID)
	if isResourceRunning("mysql") then
		storageID = tonumber(storageID)
		exports.mysql:dbQueryAsync("replaceFromStorageCallback", {player = client, storageID = storageID}, "storage", "SELECT owner, licensep FROM ?? WHERE ID = ?;", storageID)
	else
		outputBadMessage("Невозможно заменить номер (#5).", client)
	end
end
function replaceFromStorageCallback(result, args)
	result = result[1]
	if not isElement(args.player) then return end
	if (not result) then 
		outputBadMessage("Неизвестная ошибка (#6).", args.player)
		return
	end
	
	if not isResourceRunning("car_system") or not isResourceRunning("mysql") or not isResourceRunning("bank") then
		outputBadMessage("Невозможно заменить номер (#7).", args.player)
		return
	end
	
	local vehicle = getPedOccupiedVehicle(args.player)
	if (not vehicle) then
		outputBadMessage("Вы должны сидеть в машине, чтобы заменить номер.", args.player)
		return
	end
	
	if (string.sub(result.licensep, 1, 1) == "c") then
		if not isBikeType(getVehicleType(vehicle)) then
			outputBadMessage("Вы не можете поставить номер мотоцикла на другой транспорт.", client)
			return
		end
	else
		if not isAutomobileType(getVehicleType(vehicle)) then
			outputBadMessage("Вы не можете поставить автомобильный номер на данный транспорт.", client)
			return
		end
	end
	
	local ID = tonumber(getElementData(vehicle, "ID"))
	if (not ID) then
		outputBadMessage("Вы не можете заменить номер. Это не личная машина.", args.player)
		return
	end
	
	local oldNomer = getElementData(vehicle, "licensep")
	if (not oldNomer) then return end
	
	if (oldNomer:sub(1, 1) == "b") then
		outputBadMessage("Вы не можете сохранить полицейский номер.", client)
		return
	end
	
	local accName = getAccountName(getPlayerAccount(args.player))
	local vehOwner = getElementData(vehicle, "owner")
	if (accName ~= vehOwner) then
		outputBadMessage("Вы не можете заменить номер. Это не ваша машина.", args.player)
		return
	end
	if (accName ~= result.owner) then
		outputBadMessage("Неизвестная ошибка (#8).", args.player)
		return
	end
	
	local moneyAmount, currency = savingPrices.saveLoad.amount, savingPrices.saveLoad.currency
	if (exports.bank:getPlayerBankMoney(args.player, currency) < moneyAmount) then
		outputBadMessage("Вы не можете заменить номер. У вас недостаточно средств на банковском счету. Стоимость: "..savingPrices.saveLoad.text, args.player)
		return
	end
	
	exports.mysql:dbExec("storage", "DELETE FROM ?? WHERE ID = ?;", args.storageID)
	addNomerToBase(oldNomer, accName)
	
	exports.bank:takePlayerBankMoney(args.player, moneyAmount, currency)
	
	exports.car_system:changeNomer(ID, result.licensep, args.player)
	setElementData(vehicle, "licensep", result.licensep)

	triggerClientEvent(args.player, "closePanel", resourceRoot)
	updateStorageInfo(args.player)

	outputMessage("Вы успешно заменили номер!", args.player)
	outputDebugString(string.format("[CAR-NMRCHNG] %s (acc %s, bank %i%s) applied numberplate %s from storage to his %s (ID %i model %i) for %i%s and saved %s",
		getPlayerName(args.player), accName, exports.bank:getPlayerBankMoney(args.player, currency), currency, result.licensep, exports.car_system:getVehicleModName(vehicle), ID, getElementModel(vehicle), moneyAmount, currency, oldNomer))
	triggerClientEvent("playWrenchSound", resourceRoot, getElementPosition(args.player))
end
addEvent("saveAndReplace", true)
addEventHandler("saveAndReplace", resourceRoot, replaceFromStorage)

-- ==========     Заказ номера     ==========
function orderLicensep(newNomer, moneyType, player)
	local useDonat = (moneyType == "DONATE")
	local useRoubles = not useDonat
	
	local _, canBeBought, _, donatSum, _, price = getNomerTypeAndCost(newNomer)
	local donatUsed = false

	if (not canBeBought) then
		outputBadMessage("Вы не можете заказать этот номер.", player)
		return
	end
	
	if existsNomer(newNomer) then
		outputBadMessage("Этот номер уже занят, попробуйте другой", player)
		return
	end

	if (useDonat) then
		if isResourceRunning("bank") and (donatSum) then
			if (exports.bank:getPlayerBankMoney(player, "DONATE") < donatSum) then
				outputBadMessage("Невозможно поставить номер. У вас недостаточно средств. Стоимость: "..explodeNumber(donatSum).." ед.", player)
				return
			end	
			exports.bank:takePlayerBankMoney(player, donatSum, "DONATE")
			donatUsed = true
		else
			outputBadMessage("Невозможно заказать номер. Произошла ошибка.", player)
			return
		end
	else
		-- if (price) then
			-- if (getPlayerMoney(player) < price) then
				-- outputBadMessage("Невозможно поставить номер. У вас недостаточно средств. Стоимость: "..explodeNumber(price).." рублей.", player)
				-- return
			-- end	
			-- takePlayerMoney(player, price)
		-- else
			outputBadMessage("Невозможно заказать номер. Ошибка в стоимости номера.", player)
			return
		-- end
	end
	
	local accName = getAccountName(getPlayerAccount(player))
	addNomerToModeration(newNomer, donatSum, accName, player)
	
	outputMessage("Вы успешно заказали номер!", player)
	outputDebugString(string.format("[CAR-NMRCHNG][ORDER] %s (acc %s, money %i, bank %iDONATE) ordered numberplate %s for %s",		
		getPlayerName(player), accName, getPlayerMoney(player), exports.bank:getPlayerBankMoney(player, "DONATE"), newNomer, (donatUsed and tostring(donatSum).."DONATE" or tostring(price)))
	)
end

-- ==========     Удалить номер     ==========
function removeNomer(ID, clientInfo)
	ID = tonumber(ID)
	if (not clientInfo) or (not ID) then return end
	
	if (clientInfo.time) then
		if isResourceRunning("mysql") then
			exports.mysql:dbQueryAsync("removeNomerFromStorageCallback", {player = client}, "storage", "SELECT * FROM ?? WHERE ID = ?;", ID)
		else
			outputBadMessage("Невозможно удалить номер (#9).", client)
		end
	
	elseif (clientInfo.status) then
		deleteFromModeration(ID, client)
	end
end
function removeNomerFromStorageCallback(result, args)
	if (not result) or (not result[1]) or (not isElement(args.player)) then return end
	result = result[1]
	local account = getPlayerAccount(args.player)
	local accName = getAccountName(account)
	
	if (accName ~= result.owner) then
		return
	end
	
	exports.mysql:dbExec("storage", "DELETE FROM ?? WHERE ID = ?;", result.ID)
	outputMessage(string.format("Вы удалили номер %s из хранилища", (isResourceRunning("car_system") and exports.car_system:convertPlateIDtoLicensep(result.licensep) or "")), args.player)
	outputDebugString(string.format("[CAR_NOMERCHANGE][DELFROMSTORAGE] %s (acc %s money %i) deleted licensep %s from storage",
		getPlayerName(args.player), accName, getPlayerMoney(args.player), result.licensep))
	updateStorageInfo(args.player)
end
addEvent("removeNomer", true)
addEventHandler("removeNomer", resourceRoot, removeNomer)

-- Получение свободного ID
function getFreeID(tableName)
	local result = exports.mysql:dbQuery(-1, tableName, "SELECT ID FROM ?? ORDER BY ID ASC;")
	local newID
	for index, row in ipairs(result) do
		if (row.ID ~= index) then
			newID = index
			break
		end
	end
	return (newID) or (#result + 1)
end

-- ==========     Проверить наличие номера в базах      ==========
function checkNomerExistance(nomer)
	local data = exports.mysql:dbQuery(-1, "storage",
		"(SELECT ID, licensep, owner, time, NULL AS status, NULL AS comment FROM ?? WHERE licensep=?) UNION (SELECT ID, licensep, owner, NULL AS time, status, comment FROM ?? WHERE licensep=? AND status<>'refused');", 
		nomer, exports.mysql:getTableName("moderation"), nomer
	) or {}
	return (#data > 0), data
end


-- ==========     Связанное с удалением аккаунтов     ==========
function wipeAccountStorage(accName)
	local data = exports.mysql:dbQuery(-1, "storage", "SELECT * FROM ?? WHERE owner = ?;", accName)
	for _, row in ipairs(data) do
		exports.mysql:dbExec("storage", "DELETE FROM ?? WHERE ID = ?;", row.ID)
		outputDebugString(string.format("[NOMERCHANGE] Deleted licensep from storage ID %i, licensep %s, owner %s",
			row.ID, row.licensep, row.owner
		))
	end
	return 0, data
end

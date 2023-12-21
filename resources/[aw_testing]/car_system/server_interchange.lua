
local generalErrorText = "Произошла ошибка. Попробуйте начать обмен еще раз"

local interchanges = {}

addEvent("startInterchange", true)
addEventHandler("startInterchange", resourceRoot, function()
	local inf = getAccountData(getPlayerAccount(client), "INF")
	if (inf) and (inf > 10000) then
		outputCarSystemError("Невозможно начать обмен. У вас имеются неоплаченные штрафы!", client)
		return
	end
	local ID = ic_createInterchange(client)
	triggerClientEvent(client, "ic_startInterchange", resourceRoot, ID)
end)

function ic_createInterchange(player)
	local tempID
	repeat
		tempID = generateString(8)
	until (not interchanges[tempID])	-- true - выход из цикла
	interchanges[tempID] = {player1 = player}
	return tempID
end

function ic_cancelInterchange(ID, triggerCancelIC, textToPlayers, reason)
	local intData = interchanges[ID]
	if (not intData) then return end
	if (triggerCancelIC) then
		if isElement(intData.player1) then triggerClientEvent(intData.player1, "ic_cancelInterchange", resourceRoot) end
		if isElement(intData.player2) then triggerClientEvent(intData.player2, "ic_cancelInterchange", resourceRoot) end
	end
	if (textToPlayers) then
		if isElement(intData.player1) then outputCarSystemError(textToPlayers, intData.player1) end
		if isElement(intData.player2) then outputCarSystemError(textToPlayers, intData.player2) end
	end
	if (reason) then
		outputServerLog(string.format("[INTERCHG][CANCEL] icID:%s, p1: %s (%s), p2: %s (%s). Reason: %s",
			ts(ID), getName(intData.player1), getAccName(intData.player1), getName(intData.player2), getAccName(intData.player2), ts(reason)
		))
	end
	interchanges[ID] = nil
end

addEvent("ic_cancelInterchange", true)
addEventHandler("ic_cancelInterchange", resourceRoot, function(ID, player1text, player2text, reason)
	local intData = interchanges[ID]
	if (not intData) then return end
	if (player1text) and isElement(intData.player1) then outputCarSystemInfo(player1text, intData.player1) end
	if (player2text) and isElement(intData.player2) then outputCarSystemInfo(player2text, intData.player2) end
	ic_cancelInterchange(ID, true, false, reason)
end)

addEvent("ic_Request", true)
addEventHandler("ic_Request", resourceRoot, function(ID, player)
	local intData = interchanges[ID]
	if (not intData) then return end
	if isElement(player) then
		intData.player2 = player
		local inf = getAccountData(getPlayerAccount(player), "INF")
		if (inf) and (inf > 10000) then
			outputCarSystemWarning("Невозможно начать обмен. У покупателя есть неоплаченные штрафы.", client)
			ic_cancelInterchange(ID, true)
			return
		end
		triggerClientEvent(player, "ic_requestsPlayer", resourceRoot, ID, client)
	else
		outputCarSystemError("Невозможно начать обмен, игрок покинул сервер.", client)
		ic_cancelInterchange(ID, true)
	end
end)

addEvent("ic_playerIsBusy", true)
addEventHandler("ic_playerIsBusy", resourceRoot, function(ID)
	local intData = interchanges[ID]
	if (not intData) then return end
	if isElement(intData.player2) then
		outputCarSystemWarning(getPlayerName(intData.player2).."#цв# не может принять ваше предложение, так как уже совершает обмен", intData.player1)
	else
		outputCarSystemWarning("Этот игрок не может принять ваше предложение", intData.player1)
	end
	intData.player2 = nil
	ic_cancelInterchange(ID, true)
end)

addEvent("ic_inviteAccepted", true)
addEventHandler("ic_inviteAccepted", resourceRoot, function(ID)
	local intData = interchanges[ID]
	if (not intData) then return end
	if isElement(intData.player1) and isElement(intData.player2) then
		triggerClientEvent(intData.player1, "ic_inviteAccepted", resourceRoot, intData.player2, getAccName(intData.player2))
		triggerClientEvent(intData.player2, "ic_inviteAccepted", resourceRoot, intData.player1, getAccName(intData.player1))
		outputServerLog(string.format("[INTERCHG][START] icID:%s. p1: %s (%s), p2: %s (%s)",
			ts(ID), getName(intData.player1), getAccName(intData.player1), getName(intData.player2), getAccName(intData.player2)
		))
	else
		ic_cancelInterchange(ID, true, generalErrorText)
	end
end)

addEvent("syncGrid", true)
addEventHandler("syncGrid", resourceRoot, function(ID, newData, fee)
	local intData = interchanges[ID]
	if (not intData) then return end
	if isElement(intData.player1) and isElement(intData.player2) then
		intData.player1_ready = false
		intData.player2_ready = false
		intData.player1_confirmed = false
		intData.player2_confirmed = false
		if (client == intData.player1) then
			intData.player1_data = newData
			intData.player1_fee = fee
			triggerClientEvent(intData.player2, "catchGridData", resourceRoot, newData, fee)
		elseif (client == intData.player2) then
			intData.player2_data = newData
			intData.player2_fee = fee
			triggerClientEvent(intData.player1, "catchGridData", resourceRoot, newData, fee)
		end
	else
		outputServerLog(string.format("[INTERCHG][FAIL] icID:%s. Not isElement on syncGrid. isElement(p1)=%s, isElement(p2)=%s",
			ts(ID), ts(isElement(intData.player1)), ts(isElement(intData.player2))
		))
		ic_cancelInterchange(ID, true, generalErrorText)
	end
end)

addEvent("updateReadyState", true)
addEventHandler("updateReadyState", resourceRoot, function(ID, stateType, state)
	local intData = interchanges[ID]
	if (not intData) then return end
	if isElement(intData.player1) and isElement(intData.player2) then
		if (client == intData.player1) then
			if (stateType == "ready") then
				intData.player1_ready = state
			elseif (stateType == "confirm") then
				intData.player1_confirmed = state
			end
			triggerClientEvent(intData.player2, "updateReadyState", resourceRoot, stateType, state)
		elseif (client == intData.player2) then
			if (stateType == "ready") then
				intData.player2_ready = state
			elseif (stateType == "confirm") then
				intData.player2_confirmed = state
			end
			triggerClientEvent(intData.player1, "updateReadyState", resourceRoot, stateType, state)
		end
		if not (intData.player1_ready and intData.player2_ready) then
			intData.player1_confirmed = false
			intData.player2_confirmed = false
		end
		if (intData.player1_confirmed and intData.player2_confirmed) then
			performInterchange(ID)
		end
	else
		outputServerLog(string.format("[INTERCHG][FAIL] icID:%s. Not isElement on updateReadyState. isElement(p1)=%s, isElement(p2)=%s",
			ts(ID), ts(isElement(intData.player1)), ts(isElement(intData.player2))
		))
		ic_cancelInterchange(ID, true, generalErrorText)
	end
end)

function performInterchange(ID)
	local intData = interchanges[ID]
	if not isResourceRunning("mysql") then
		outputDebugString("[INTERCHG] Cannot interchange - mysql is not active", 1)
		ic_cancelInterchange(ID, true, "Невозможно произвести обмен - системная ошибка. Сообщите об этом администратору.", "mysql is not active")
		return
	end
	local player1_accName = getAccountName(getPlayerAccount(intData.player1))
	local player2_accName = getAccountName(getPlayerAccount(intData.player2))
	
	-- =====     Хватит ли обоим денег для совершения сделки     =====
	local moneyFrom1, moneyFrom2, moneyTo1, moneyTo2 = 0, 0, 0, 0
	moneyFrom1 = math.floor((intData.player1_fee or 0) + (intData.player2_fee or 0) + (intData.player1_data and intData.player1_data.money or 0))
	moneyFrom2 = math.floor(intData.player2_data and intData.player2_data.money or 0)
	moneyTo1 = math.floor(intData.player2_data and intData.player2_data.money or 0)
	moneyTo2 = math.floor(intData.player1_data and intData.player1_data.money or 0)
	if (exports.bank:getPlayerBankMoney(intData.player1) - moneyFrom1) < 0 then
	--if (getPlayerMoney(intData.player1) - moneyFrom1) < 0 then
		outputCarSystemError("У вас недостаточно денег на руках для совершения сделки", intData.player1)
		outputCarSystemWarning("У "..getPlayerName(intData.player1).."#цв# недостаточно денег для совершения сделки", intData.player2)
		outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. Player1 has not enough money. p1: has %s, moneyFrom1 %s, moneyTo1 %s. p2: has %s, moneyFrom2 %s, moneyTo2 %s",
			ts(ID), ts(exports.bank:getPlayerBankMoney(intData.player1)), ts(moneyFrom1), ts(moneyTo1), ts(exports.bank:getPlayerBankMoney(intData.player2)), ts(moneyFrom2), ts(moneyTo2)
		))
		resetReady(ID)
		return
	end
	if (exports.bank:getPlayerBankMoney(intData.player2) - moneyFrom2) < 0 then
	--if (getPlayerMoney(intData.player2) - moneyFrom2) < 0 then
		outputCarSystemWarning("У "..getPlayerName(intData.player2).."#цв# недостаточно денег для совершения сделки", intData.player1)
		outputCarSystemError("У вас недостаточно денег на руках для совершения сделки", intData.player2)
		outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. Player2 has not enough money. p1: has %s, moneyFrom1 %s, moneyTo1 %s. p2: has %s, moneyFrom2 %s, moneyTo2 %s",
			ts(ID), ts(exports.bank:getPlayerBankMoney(intData.player1)), ts(moneyFrom1), ts(moneyTo1), ts(exports.bank:getPlayerBankMoney(intData.player2)), ts(moneyFrom2), ts(moneyTo2)
		))
		resetReady(ID)
		return
	end
	
	-- =====     Не будет ли переполнения денег после сделки     =====
	--[[if (exports.bank:getPlayerBankMoney(intData.player1) - moneyFrom1 + moneyTo1) > 99999999 then
	--if (getPlayerMoney(intData.player1) - moneyFrom1 + moneyTo1) > 99999999 then
		outputCarSystemError("У вас будет слишком много денег на руках после совершения сделки", intData.player1)
		outputCarSystemWarning("У "..getPlayerName(intData.player1).."#цв# будет слишком много денег на руках после совершения сделки", intData.player2)
		outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. Player1 will have too much money. p1: has %s, moneyFrom1 %s, moneyTo1 %s. p2: has %s, moneyFrom2 %s, moneyTo2 %s",
			ts(ID), ts(exports.bank:getPlayerBankMoney(intData.player1)), ts(moneyFrom1), ts(moneyTo1), ts(exports.bank:getPlayerBankMoney(intData.player2)), ts(moneyFrom2), ts(moneyTo2)
		))
		resetReady(ID)
		return
	end
	if (exports.bank:getPlayerBankMoney(intData.player2) - moneyFrom2 + moneyTo2) > 99999999 then
	--if (getPlayerMoney(intData.player2) - moneyFrom2 + moneyTo2) > 99999999 then
		outputCarSystemWarning("У "..getPlayerName(intData.player2).."#цв# будет слишком много денег на руках после совершения сделки", intData.player1)
		outputCarSystemError("У вас будет слишком много денег на руках после совершения сделки", intData.player2)
		outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. Player2 will have too much money. p1: has %s, moneyFrom1 %s, moneyTo1 %s. p2: has %s, moneyFrom2 %s, moneyTo2 %s",
			ts(ID), ts(exports.bank:getPlayerBankMoney(intData.player1)), ts(moneyFrom1), ts(moneyTo1), ts(exports.bank:getPlayerBankMoney(intData.player2)), ts(moneyFrom2), ts(moneyTo2)
		))
		resetReady(ID)
		return
	end]]
	
	-- =====     Принадлежат ли машины владельцам     =====
	local carsToCheck1, carsToCheck2 = {}, {}
	if intData.player1_data then
		for _, car in ipairs(intData.player1_data.cars) do
			table.insert(carsToCheck1, car.data)
		end
		if intData.player1_data.nomer then
			table.insert(carsToCheck1, intData.player1_data.nomer.data)
		end
	end
	if intData.player2_data then
		for _, car in ipairs(intData.player2_data.cars) do
			table.insert(carsToCheck2, car.data)
		end
		if intData.player2_data.nomer then
			table.insert(carsToCheck2, intData.player2_data.nomer.data)
		end
	end
	local player1_carIDs = "("..table.concat(carsToCheck1, ",")..")"
	local player2_carIDs = "("..table.concat(carsToCheck2, ",")..")"
	local query1 = (#carsToCheck1 > 0) and exports.mysql:dbQuery(-1, "vehicle", "SELECT ID, owner, model, licensep, flag FROM ?? WHERE ID IN ??", player1_carIDs)
	local query2 = (#carsToCheck2 > 0) and exports.mysql:dbQuery(-1, "vehicle", "SELECT ID, owner, model, licensep, flag FROM ?? WHERE ID IN ??", player2_carIDs)
	if (type(query1) ~= "table" and #carsToCheck1 > 0) or (type(query2) ~= "table" and #carsToCheck2 > 0) then
		outputDebugString("[INTERCHG] Cannot interchange - query1 = "..inspect(query1)..", query2 = "..inspect(query2), 1)
		ic_cancelInterchange(ID, true, "Невозможно произвести обмен - системная ошибка. Сообщите об этом администратору.", "query error on performInterchange")
		return
	end
	query1 = query1 or {}
	query2 = query2 or {}
	local IDtoModel, IDtoInfo = {}, {}	-- Для использования далее
	for _, row in ipairs(query1) do
		IDtoModel[tonumber(row.ID)] = tonumber(row.model)
		IDtoInfo[tonumber(row.ID)] = row
		if (row.owner ~= player1_accName) then
			outputCarSystemError(string.format("Произошла ошибка. Вы не владелец машины с номером %s", convertPlateIDtoLicensep(row.licensep)), intData.player1)
			outputCarSystemWarning(string.format("Произошла ошибка. %s#цв# не владелец машины с номером %s", getPlayerName(intData.player1), convertPlateIDtoLicensep(row.licensep)), intData.player2)
			outputDebugString(string.format("[INTERCHG] icID:%s. p1 %s (%s) is not owner of car ID %s (model %s real owner %s lic %s)",
				ts(ID), getName(intData.player1), ts(player1_accName), ts(row.ID), ts(row.model), ts(row.owner), ts(row.licensep)
			), 2)
			ic_cancelInterchange(ID, true, false, "player1 is not owner")
			return
		elseif tostring(row.flag) == "police" then
			local text = string.format("Запрещены операции над машиной с номером %s.", convertPlateIDtoLicensep(row.licensep))
			outputCarSystemError(text, intData.player1)
			outputCarSystemWarning(text, intData.player2)
			outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. Car ID %s (model %s lic %s) of p1 (%s, %s) has flag: %s",
				ts(ID), ts(row.ID), ts(row.model), ts(row.licensep), getName(intData.player1), ts(player1_accName), ts(row.flag)
			))
			resetReady(ID)
			return
		end
	end
	for _, row in ipairs(query2) do
		IDtoModel[tonumber(row.ID)] = tonumber(row.model)
		IDtoInfo[tonumber(row.ID)] = row
		if (row.owner ~= player2_accName) then
			outputCarSystemWarning(string.format("Произошла ошибка. %s#цв# не владелец машины с номером %s", getPlayerName(intData.player2), convertPlateIDtoLicensep(row.licensep)), intData.player1)
			outputCarSystemError(string.format("Произошла ошибка. Вы не владелец машины с номером %s", convertPlateIDtoLicensep(row.licensep)), intData.player2)
			outputDebugString(string.format("[INTERCHG] icID:%s. p2 %s (%s) is not owner of car ID %s (model %s real owner %s lic %s)",
				ts(ID), getName(intData.player2), ts(player2_accName), ts(row.ID), ts(row.model), ts(row.owner), ts(row.licensep)
			), 2)
			ic_cancelInterchange(ID, true, false, "player2 is not owner")
			return
		elseif tostring(row.flag) == "police" then
			local text = string.format("Запрещены операции над машиной с номером %s.", convertPlateIDtoLicensep(row.licensep))
			outputCarSystemWarning(text, intData.player1)
			outputCarSystemError(text, intData.player2)
			outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. Car ID %s (model %s lic %s) of p2 (%s, %s) has flag: %s",
				ts(ID), ts(row.ID), ts(row.model), ts(row.licensep), getName(intData.player2), ts(player2_accName), ts(row.flag)
			))
			resetReady(ID)
			return
		end
	end	
	
	-- =====     Если есть машины на обмен номеров     =====
	local usingNomerChange = false
	if (intData.player1_data and intData.player1_data.nomer) or (intData.player2_data and intData.player2_data.nomer) then
		-- =====     Если обмен номеров, то две ли машины     =====
		if not (intData.player1_data and intData.player1_data.nomer and intData.player2_data and intData.player2_data.nomer) then
			local text = "Оба игрока должны выбрать машину для обмена номеров"
			outputCarSystemError(text, intData.player1)
			outputCarSystemError(text, intData.player2)
			outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. Only 1 car to exchange licenseps. Car1: %s. Car2: %s",
				ts(ID), inspect(intData.player1_data and intData.player1_data.nomer), inspect(intData.player2_data and intData.player2_data.nomer)
			))
			resetReady(ID)
			return
		end
		-- =====     Если обмен номеров, то только машины на машины     =====		
		local nomer1row, nomer2row
		for index, row in ipairs(query1) do
			if (row.ID == intData.player1_data.nomer.data) then
				nomer1row = index
				break
			end
		end
		for index, row in ipairs(query2) do
			if (row.ID == intData.player2_data.nomer.data) then
				nomer2row = index
				break
			end
		end
		if (not nomer1row) or (not nomer2row) then
			local text = "Произошла неизвестная ошибка. Попробуйте выставить машины еще раз."
			outputCarSystemError(text, intData.player1)
			outputCarSystemError(text, intData.player2)
			outputDebugString(string.format("[INTERCHG] icID:%s. Nomer1row: %s nomer2row: %s",
				ts(ID), inspect(nomer1row), inspect(nomer2row)
			), 2)
			resetReady(ID)
			return
		end
		local nomer1model, nomer2model = query1[nomer1row].model, query2[nomer2row].model
		if overPricedCar[nomer1model] or isHeli[nomer1model] or isBoat[nomer1model] or isMotorcycle[nomer1model] then
			local text = "Изменение номера на "..getVehicleModName(nomer1model).." недоступно"
			outputCarSystemError(text, intData.player1)
			outputCarSystemWarning(text, intData.player2)
			outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. Car1 is wrong to change lic (ID %s model %s lic %s name %s)",
				ts(ID), ts(query1[nomer1row].ID), ts(nomer1model), ts(query1[nomer1row].licensep), getVehicleModName(nomer1model)
			))
			resetReady(ID)
			return
		end
		if overPricedCar[nomer2model] or isHeli[nomer2model] or isBoat[nomer2model] or isMotorcycle[nomer2model] then
			local text = "Изменение номера на "..getVehicleModName(nomer2model).." недоступно"
			outputCarSystemWarning(text, intData.player1)
			outputCarSystemError(text, intData.player2)
			outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. Car2 is wrong to change lic (ID %s model %s lic %s name %s)",
				ts(ID), ts(query2[nomer2row].ID), ts(nomer2model), ts(query2[nomer2row].licensep), getVehicleModName(nomer2model)
			))
			resetReady(ID)
			return
		end
		usingNomerChange = {
			player1car = query1[nomer1row].ID,
			player1nomer = query1[nomer1row].licensep,
			nomer1row = nomer1row,
			player2car = query2[nomer2row].ID,
			player2nomer = query2[nomer2row].licensep,
			nomer2row = nomer2row
		}
	end
	
	-- =====     Хватит ли парковочных мест     =====
	if isResourceRunning("house") then
		local parkLotsDelta1, parkLotsDelta2 = 0, 0
		if (intData.player1_data) then
			for _, car in ipairs(intData.player1_data.cars) do
				if (not notSlottingCar[ IDtoModel[car.data] ]) then
					parkLotsDelta1 = parkLotsDelta1 - 1
					parkLotsDelta2 = parkLotsDelta2 + 1
				end
			end
		end
		if (intData.player2_data) then
			for _, car in ipairs(intData.player2_data.cars) do
				if (not notSlottingCar[ IDtoModel[car.data] ]) then
					parkLotsDelta1 = parkLotsDelta1 + 1
					parkLotsDelta2 = parkLotsDelta2 - 1
				end
			end
		end
		if (parkLotsDelta1 > 0) then
			local parkLotsPlayer1 = exports.house:getPlayerParkingLots(player1_accName)+(tonumber(getElementData(intData.player1, "customSlots")) or 0)
			local parkLotsUsedPlayer1 = getUsedParkLots(player1_accName)
			if (parkLotsUsedPlayer1 + parkLotsDelta1 > parkLotsPlayer1 + 1) then
				outputCarSystemError("Обмен невозможен, у вас недостаточно парковочных мест", intData.player1)
				outputCarSystemWarning("Обмен невозможен, у "..getPlayerName(intData.player1).."#цв# недостаточно парковочных мест", intData.player2)
				outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. p1 has not enough parking lots. Has %s, uses %s, delta1 %s",
					ts(ID), ts(parkLotsPlayer1), ts(parkLotsUsedPlayer1), ts(parkLotsDelta1)
				))
				resetReady(ID)
				return
			end
		end
		if (parkLotsDelta2 > 0) then
			local parkLotsPlayer2 = exports.house:getPlayerParkingLots(player2_accName)+(tonumber(getElementData(intData.player2, "customSlots")) or 0)
			local parkLotsUsedPlayer2 = getUsedParkLots(player2_accName)
			if (parkLotsUsedPlayer2 + parkLotsDelta2 > parkLotsPlayer2 + 1) then
				outputCarSystemWarning("Обмен невозможен, у "..getPlayerName(intData.player2).."#цв# недостаточно парковочных мест", intData.player1)
				outputCarSystemError("Обмен невозможен, у вас недостаточно парковочных мест", intData.player2)
				outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. p2 has not enough parking lots. Has %s, uses %s, delta2 %s",
					ts(ID), ts(parkLotsPlayer2), ts(parkLotsUsedPlayer2), ts(parkLotsDelta2)
				))
				resetReady(ID)
				return
			end
		end
	end
	
	-- =====     Не будет ли переполнения по моделям     =====
	local carDelta1, carDelta2 = {}, {}
	if (intData.player1_data) then
		for _, car in ipairs(intData.player1_data.cars) do
			local model = IDtoModel[car.data]
			carDelta1[model] = (carDelta1[model] or 0) - 1
			carDelta2[model] = (carDelta2[model] or 0) + 1
		end
	end
	if (intData.player2_data) then
		for _, car in ipairs(intData.player2_data.cars) do
			local model = IDtoModel[car.data]
			carDelta1[model] = (carDelta1[model] or 0) + 1
			carDelta2[model] = (carDelta2[model] or 0) - 1
		end
	end
	for model, count in pairs(carDelta1) do
		if (count > 0) then
			local data = exports.mysql:dbQuery(-1, "vehicle", "SELECT model FROM ?? WHERE owner = ? AND model = ?", player1_accName, model)
			if (not data) or (#data + count > 3) then
				outputCarSystemError("Обмен невозможен, у вас будет слишком много "..getVehicleModName(model), intData.player1)
				outputCarSystemWarning(string.format("Обмен невозможен, у %s#цв# будет слишком много %s", getPlayerName(intData.player1), getVehicleModName(model)), intData.player2)
				outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. p1 will have too many %s (model %s) or sql error (%s)",
					ts(ID), getVehicleModName(model), ts(model), ts(not data)
				))
				resetReady(ID)
				return
			end
		end
	end
	for model, count in pairs(carDelta2) do
		if (count > 0) then
			local data = exports.mysql:dbQuery(-1, "vehicle", "SELECT model FROM ?? WHERE owner = ? AND model = ?", player2_accName, model)
			if (not data) or (#data + count > 3) then
				outputCarSystemWarning(string.format("Обмен невозможен, у %s#цв# будет слишком много %s", getPlayerName(intData.player2), getVehicleModName(model)), intData.player1)
				outputCarSystemError("Обмен невозможен, у вас будет слишком много "..getVehicleModName(model), intData.player2)
				outputServerLog(string.format("[INTERCHG][MISTAKE] icID:%s. p2 will have too many %s (model %s) or sql error (%s)",
					ts(ID), getVehicleModName(model), ts(model), ts(not data)
				))
				resetReady(ID)
				return
			end
		end
	end
	
	-- =====     Выполнение обмена     =====
	
	--takePlayerMoney(intData.player1, moneyFrom1)
	--givePlayerMoney(intData.player1, moneyTo1)
	--takePlayerMoney(intData.player2, moneyFrom2)
	--givePlayerMoney(intData.player2, moneyTo2)
	
	exports.bank:takePlayerBankMoney(intData.player1, moneyFrom1)
	exports.bank:givePlayerBankMoney(intData.player1, moneyTo1)
	exports.bank:takePlayerBankMoney(intData.player2, moneyFrom2)
	exports.bank:givePlayerBankMoney(intData.player2, moneyTo2)
	
	
	if usingNomerChange then
		local vehicle = getVehicleByID(usingNomerChange.player1car)
		if isElement(vehicle) then destroyVehicle(vehicle) end
		vehicle = getVehicleByID(usingNomerChange.player2car)
		if isElement(vehicle) then destroyVehicle(vehicle) end
		exports.mysql:dbExec("vehicle", "UPDATE ?? SET licensep = ? WHERE ID = ?", usingNomerChange.player2nomer, usingNomerChange.player1car)
		exports.mysql:dbExec("vehicle", "UPDATE ?? SET licensep = ? WHERE ID = ?", usingNomerChange.player1nomer, usingNomerChange.player2car)
	end
	
	local logString1, logString2 = {}, {}
	if (intData.player1_data) then
		for _, car in ipairs(intData.player1_data.cars) do
			local vehicle = getVehicleByID(car.data)
			if isElement(vehicle) then destroyVehicle(vehicle) end
			exports.mysql:dbExec("vehicle", "UPDATE ?? SET owner = ?, userOrder = ? WHERE ID = ?", player2_accName, getNextUserOrderValue(player2_accName), car.data)
			local info = IDtoInfo[car.data] or IDtoInfo[tonumber(car.data)] or {}
			table.insert(logString1, string.format("ID %s, name %s, lic %s, model %s", ts(info.ID), ts(getVehicleModName(info.model)), ts(info.licensep), ts(info.model) ))
		end
	end
	if (intData.player2_data) then
		for _, car in ipairs(intData.player2_data.cars) do
			local vehicle = getVehicleByID(car.data)
			if isElement(vehicle) then destroyVehicle(vehicle) end
			exports.mysql:dbExec("vehicle", "UPDATE ?? SET owner = ?, userOrder = ? WHERE ID = ?", player1_accName, getNextUserOrderValue(player1_accName), car.data)
			local info = IDtoInfo[car.data] or IDtoInfo[tonumber(car.data)] or {}
			table.insert(logString2, string.format("ID %s, name %s, lic %s, model %s", ts(info.ID), ts(getVehicleModName(info.model)), ts(info.licensep), ts(info.model) ))
		end
	end
	
	updateVehicleInfo(intData.player1)
	updateVehicleInfo(intData.player2)
	
	outputServerLog(string.format("[INTERCHG][SUCCESSFUL] icID:%s. p1 (acc %s) got %+i money, now he has %s. p2 (%s): got %+i, now %s",
		ts(ID), player1_accName, moneyTo1-moneyFrom1, ts(exports.bank:getPlayerBankMoney(intData.player1)), player2_accName, moneyTo2-moneyFrom2, ts(exports.bank:getPlayerBankMoney(intData.player2))
	))
	if usingNomerChange then
		outputServerLog(string.format("[INTERCHG][SUCCESSFUL] icID:%s. Nomerchange: p1 (%s) veh %s ID %s lic %s got lic %s from p2 (%s)",
			ts(ID), player1_accName, ts(getVehicleModName(query1[usingNomerChange.nomer1row].model)), ts(usingNomerChange.player1car), ts(query1[usingNomerChange.nomer1row].licensep),
			ts(usingNomerChange.player2nomer), player2_accName
		))
		outputServerLog(string.format("[INTERCHG][SUCCESSFUL] icID:%s. Nomerchange: p2 (%s) veh %s ID %s lic %s got lic %s from p1 (%s)",
			ts(ID), player2_accName, ts(getVehicleModName(query2[usingNomerChange.nomer2row].model)), ts(usingNomerChange.player2car), ts(query2[usingNomerChange.nomer2row].licensep),
			ts(usingNomerChange.player1nomer), player1_accName
		))
	end
	logString1 = table.concat(logString1, "; ")
	logString2 = table.concat(logString2, "; ")
	if (logString1 ~= "") or (logString2 ~= "") then
		outputServerLog(string.format("[INTERCHG][SUCCESSFUL] icID:%s. Cars: p2 (%s) -> p1 (%s): %s",
			ts(ID), player2_accName, player1_accName, (logString2 ~= "" and logString2 or "nothing")
		))
		outputServerLog(string.format("[INTERCHG][SUCCESSFUL] icID:%s. Cars: p1 (%s) -> p2 (%s): %s",
			ts(ID), player1_accName, player2_accName, (logString1 ~= "" and logString1 or "nothing")
		))
	end
	
	outputCarSystemInfo("Вы успешно совершили обмен с игроком "..getPlayerName(intData.player2), intData.player1)
	outputCarSystemInfo("Вы успешно совершили обмен с игроком "..getPlayerName(intData.player1), intData.player2)
	ic_cancelInterchange(ID, true)
end

function resetReady(ID)
	local intData = interchanges[ID]
	intData.player1_ready = false
	intData.player2_ready = false
	intData.player1_confirmed = false
	intData.player2_confirmed = false
	triggerClientEvent(intData.player1, "resetReady", resourceRoot)
	triggerClientEvent(intData.player2, "resetReady", resourceRoot)
end		

addEventHandler("onPlayerQuit", root, function()
	for ID, data in pairs(interchanges) do
		if (data.player1 == source) or (data.player2 == source) then
			outputServerLog(string.format("[INTERCHG][FAIL] icID:%s. Player (%s) left server. p1: (%s), p2: (%s)",
				ts(ID), getAccName(source), getAccName(data.player1), getAccName(data.player2)
			))
			ic_cancelInterchange(ID, true, "Обмен прерван. "..getPlayerName(source).."#цв# покинул сервер.")
		end
	end
end)





function json(data)
	return toJSON((data or false), true)
end

function getAccName(player)
	if isElement(player) then
		return tostring(getAccountName(getPlayerAccount(player)))
	else
		return "false"
	end
end

function getName(player)
	if isElement(player) then
		return tostring(getPlayerName(player))
	else
		return "false"
	end
end

ts = tostring




-- ==========     Генерация строки символов     ==========
local symbols = {}
for _, range in ipairs({{48, 57}, {65, 90}, {97, 122}}) do -- numbers/lowercase chars/uppercase chars
	for i = range[1], range[2] do
		table.insert(symbols, i)
	end
end
function generateString(length)
	length = tonumber(length) or 8	
	local str, symbolCount = "", #symbols
	for i = 1, length do
		str = str..string.char(symbols[math.random(1, symbolCount)])
	end
	return str
end

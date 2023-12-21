
addEvent("enterHouse", true)
addEventHandler("enterHouse", resourceRoot, function(markerData)
	if getElementData(client, "isChased") then return end
	fadeCamera(client, false)
	toggleAllControls(client, false)
	setTimer(enterHouse2, 1200, 1, client, markerData)
	createInventoryOnHouseEnter(client, markerData.intID, markerData.dim, markerData.owner)
end)
function enterHouse2(player, data)
	if isElement(player) then
		if isPedInVehicle(player) then removePedFromVehicle(player) end
		setElementInterior(player, data.int, data.enterPointX, data.enterPointY, data.enterPointZ)
		setElementPosition(player, data.enterPointX, data.enterPointY, data.enterPointZ)
		setElementDimension(player, data.dim)
		toggleAllControls(player, true)
		fadeCamera(player, true)
	end
end

addEvent("exitHouse", true)
addEventHandler("exitHouse", resourceRoot, function(exitData)
	toggleAllControls(client, false)
	fadeCamera(client, false)
	setTimer(exitHouse2, 1200, 1, client, exitData)
	removeInventory(client)
end)
function exitHouse2(player, data)
	if isElement(player) then
		if isPedInVehicle(player) then removePedFromVehicle(player) end
		setElementPosition(player, data.exitPointX, data.exitPointY, data.exitPointZ)
		setElementInterior(player, 0)
		setElementDimension(player, 0)
		toggleAllControls(player, true)
		fadeCamera(player, true)
	end
end

function onBuyHouse(markerData, key)
	local hData = houseData[markerData.ID]
	if (not hData) then
		outputChatBad("Произошла ошибка. Попробуйте ещё раз.", client)
		return
	end
	if exports.bank:getPlayerBankMoney(client, "RUB") <= hData.cost then
		outputChatBad("У вас недостаточно средств!", client)
		return
	end
	local result = dbPoll(dbQuery(db, "SELECT owner FROM house_data WHERE ID = ?", hData.ID), -1)
	if (not result[1]) then
		outputDebugString ("[HOUSE][ERROR] "..getPlayerName(client).." got error on buing house "..tostring(hData.ID))
		outputChatBad("Произошла ошибка. Попробуйте ещё раз.", client)
		return
	end
	if (result[1].owner ~= "") then
		outputChatBad("Этот дом уже куплен!", client)
		return
	end
	local accName = getAccountName(getPlayerAccount(client))
	if (getHousesCount(accName) >= maxHousesCount) then
		outputChatBad("К сожалению, вы не можете купить больше "..maxHousesCount.." домов!", client)
		return
	end
	--takePlayerMoney(client, hData.cost)
	exports.bank:takePlayerBankMoney(client, hData.cost, "RUB")
	updateHouse(hData.ID, "key", key)
	updateHouse(hData.ID, "owner", accName)
	dbExec(db, "UPDATE house_data SET owner = ?, key = ? WHERE ID = ?", accName, key, hData.ID)
	outputDebugString ("[HOUSE][BUY] "..getPlayerName(client).." (acc "..accName..", money "..exports.bank:getPlayerBankMoney(client, "RUB")..") bought house "..hData.ID.." for "..hData.cost)
	outputChatOK("Поздравляем, вы приобрели недвижимость!", client)
	outputChatOK("Вам доступно "..getPlayerParkingLots(accName).." парковочных мест!", client)
	outputChatOK("Ваш новый ключ: "..key, client)
	triggerClientEvent(client, "playConfirm", resourceRoot)
	triggerClientEvent(client, "refreshHouseBlips", resourceRoot)
	local carsystRes = getResourceFromName("car_system")
	if (carsystRes) and (getResourceState(carsystRes) == "running") then
		exports.car_system:updateVehicleInfo(client)
	end
end
addEvent("buyHouse", true)
addEventHandler("buyHouse", resourceRoot, onBuyHouse)

function onSellHouse(markerData)
	local hData = houseData[markerData.ID]
	local accName = getAccountName(getPlayerAccount(client))
	local result = dbPoll(dbQuery(db, "SELECT owner FROM house_data WHERE ID = ?", hData.ID), -1)
	if result[1].owner == "" then
		outputChatBad("Этот дом уже продан!", client)
		return
	end
	if result[1].owner ~= accName then
		outputChatBad("Это не ваш дом!", client)
		return
	end
	local price = math.ceil(hData.cost/2)
	--givePlayerMoney(client, price)
	exports.bank:givePlayerBankMoney(client, price, "RUB")
	updateHouse(hData.ID, "key", "")
	updateHouse(hData.ID, "owner", "")
	dbExec(db, "UPDATE house_data SET owner = '', key = '' WHERE ID = ?", hData.ID)
	outputDebugString ("[HOUSE][SELL] "..getPlayerName(client).." (acc "..accName..", money "..exports.bank:getPlayerBankMoney(client, "RUB")..") sold house "..hData.ID.." for "..price)
	outputChatOK("Вы продали ваш дом!", client)
	outputChatOK("Вам доступно "..getPlayerParkingLots(accName).." парковочных мест!", client)
	triggerClientEvent(client, "playConfirm", resourceRoot)
	triggerClientEvent(client, "refreshHouseBlips", resourceRoot)
	local carsystRes = getResourceFromName("car_system")
	if (carsystRes) and (getResourceState(carsystRes) == "running") then
		exports.car_system:updateVehicleInfo(client)
	end
end
addEvent("sellHouse", true)
addEventHandler("sellHouse", resourceRoot, onSellHouse)

function onChangeKey(markerData, oldKey, newKey)
	local hData = houseData[markerData.ID]
	local accName = getAccountName(getPlayerAccount(client))
	local result = dbPoll(dbQuery(db, "SELECT owner, key FROM house_data WHERE ID = ?", hData.ID), -1)
	if result[1].owner ~= accName then
		outputChatBad("Это не ваш дом!", client)
		return
	end
	-- if result[1].key ~= oldKey then
		-- outputChatBad("Старый ключ неверен!", client)
		-- return
	-- end
	updateHouse(hData.ID, "key", newKey)
	dbExec(db, "UPDATE house_data SET key = ? WHERE ID = ?", newKey, hData.ID)
	outputDebugString ("[HOUSE][CHANGEKEY] "..getPlayerName(client).." (acc "..accName..", money "..exports.bank:getPlayerBankMoney(client, "RUB")..") changed key for house "..hData.ID)
	outputChatOK("Ваш новый ключ: #FFFF00"..newKey, client)
	triggerClientEvent(client, "playConfirm", resourceRoot)
end
addEvent("changeKey", true)
addEventHandler("changeKey", resourceRoot, onChangeKey)





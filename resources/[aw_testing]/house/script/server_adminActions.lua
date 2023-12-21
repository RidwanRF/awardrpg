
function returnHouseData(partOfData)
	local result = dbPoll(dbQuery(db, "SELECT * FROM house_data WHERE ID = ?", partOfData.ID), -1)
	triggerClientEvent(client, "catchHouseData", resourceRoot, result[1])
end
addEvent("getHouseData", true)
addEventHandler("getHouseData", resourceRoot, returnHouseData)

function onDeleteHouse(ID)
	local hData = houseData[ID]
	if not isAdmin(client) then return	end
	dbExec(db, "DELETE FROM house_data WHERE ID = ?", ID)
	removeHouse(ID)
	outputDebugString ("[HOUSE][DELETE] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..") deleted house "..ID)
	outputChatOK("Вы успешно удалили дом с ID = "..ID, client)
	triggerClientEvent(client, "playConfirm", resourceRoot)
end
addEvent("deleteHouse", true)
addEventHandler("deleteHouse", resourceRoot, onDeleteHouse)

function sendToBighpanel(mrkData)
	if not isAdmin(client) then return end
	
	if isResourceRunning("house_apartments") then
		local result = dbPoll(dbQuery(db, "SELECT * FROM house_data WHERE ID = ?", mrkData.ID), -1)
		local resRoot = getResourceRootElement(getResourceFromName("house_apartments"))
		triggerClientEvent(client, "getInfoFromHouseResource", resRoot, result[1])
	else
		outputChatBad("house_apartments не запущен", client)
	end
end
addEvent("sendToBighpanel", true)
addEventHandler("sendToBighpanel", resourceRoot, sendToBighpanel)

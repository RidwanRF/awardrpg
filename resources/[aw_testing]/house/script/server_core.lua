maxHousesCount = 2

db = dbConnect("sqlite", "house.db")
houseData = {}
local dbLoaded = false
local playersToDelayedSend = {}

-- ==========     ЗАГРУЗКА И СИНХРОНИЗАЦИЯ МАРКЕРОВ     ==========
function onResourceStart()
	dbExec(db, "CREATE TABLE IF NOT EXISTS house_data (ID INTEGER, \
				enterMrkX REAL, enterMrkY REAL, enterMrkZ REAL, \
				enterPointX REAL, enterPointY REAL, enterPointZ REAL, \
				exitMrkX REAL, exitMrkY REAL, exitMrkZ REAL, \
				exitPointX REAL, exitPointY REAL, exitPointZ REAL, \
				int INTEGER, dim INTEGER, cost INTEGER, owner TEXT, key TEXT, \
				carLots INTEGER, intID INTEGER)"
	)
	checkForInteriorIDs()
	local houses = dbPoll(dbQuery(db, "SELECT * FROM house_data"), -1)
	for _, house in ipairs(houses) do
		houseData[house.ID] = house
	end
	dbLoaded = true
	delayedHouseSending()
end
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

function getAllHouses()
	if dbLoaded then
		triggerClientEvent(client, "takeAllHouses", resourceRoot, houseData)
	else
		table.insert(playersToDelayedSend, client)
	end
end
addEvent("getAllHouses", true)
addEventHandler("getAllHouses", resourceRoot, getAllHouses)

function delayedHouseSending()
	for _, player in ipairs(playersToDelayedSend) do
		triggerClientEvent(player, "takeAllHouses", resourceRoot, houseData)
	end
	playersToDelayedSend = nil
end

function updateHouse(ID, key, value)
	houseData[ID][key] = value
	if (key == "owner") then
		triggerClientEvent("updateHouse", resourceRoot, ID, "owner", value)
	end
end

function removeHouse(ID)
	houseData[ID] = nil
	triggerClientEvent("removeHouse", resourceRoot, ID)
end

-- ==========     ПРОВЕРКИ ДЛЯ ОТКРЫТИЯ ПАНЕЛИ ИГРОКА     ==========
function givePlayerPanel(ID)
	local buttons = {buy = false, sell = false, changeKey = false, enter = true, newOwner = false, edit = false}
	if isAdmin(client) then
		buttons.edit = true
	end
	if (houseData[ID].owner == getAccountName(getPlayerAccount(client))) then
		buttons.sell = true
		buttons.changeKey = true
		buttons.newOwner = true
	end
	if (houseData[ID].owner == "") then
		buttons.buy = true
	end
	triggerClientEvent(client, "openPlayerPanel", resourceRoot, houseData[ID], buttons)
end
addEvent("givePlayerPanel", true)
addEventHandler("givePlayerPanel", resourceRoot, givePlayerPanel)




-- ==========     ПЕРЕДАЧА ИНФЫ ОБ АККАУНТЕ     ==========
function returnPlayerAccount()
	local accName = getAccountName(getPlayerAccount(client))
	triggerClientEvent(client, "takeAccount", resourceRoot, accName)	
end
addEvent("getMyAccount", true)
addEventHandler("getMyAccount", resourceRoot, returnPlayerAccount)

function returnAccountOnLogin(_, theCurrentAccount)
	local accName = getAccountName(theCurrentAccount)
	triggerClientEvent(source, "takeAccount", resourceRoot, accName)	
end
addEventHandler("onPlayerLogin", root, returnAccountOnLogin)


-- ==========     Сообщения в чат     ==========
function outputChatOK(text, player)
	outputChatBox("[Домоуправление] #33FF24"..text, player, 56,120,172, true)
end
function outputChatBad(text, player)
	outputChatBox("[Домоуправление] #FF3324"..text, player, 56,120,172, true)
end

-- ==========     Получение количества парковочных мест     ==========
function getPlayerParkingLots(accName)
	local data = dbPoll(dbQuery(db, "SELECT SUM(carLots) AS sum FROM house_data WHERE owner = ?", accName), -1)
	local sum = (data) and (data[1]) and (data[1].sum) or 0
	if isResourceRunning("house_apartments") then
		sum = sum + exports.house_apartments:getPlayerParkingLots(accName)
	end
	return sum
end

-- ==========     Получение количества купленных домов и квартир     ==========
function getHousesCount(accName)
	local data = dbPoll(dbQuery(db, "SELECT COUNT(ID) AS count FROM house_data WHERE owner = ?", accName), -1)
	local count = (data) and (data[1]) and (data[1].count) or 0
	if isResourceRunning("house_apartments") then
		count = count + exports.house_apartments:getApartmentCount(accName)
	end
	return count
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
	local moneyEquivalent = 0
	local data = dbPoll(dbQuery(db, "SELECT * FROM house_data WHERE owner = ?", accName), -1)
	for _, house in ipairs(data) do
		dbExec(db, "UPDATE house_data SET owner = '', key = '' WHERE ID = ?", house.ID)
		outputDebugString(string.format("[HOUSE] Sold house ID %i with %i parking lots of account %s for %i",
			house.ID, house.carLots, house.owner, house.cost
		))
		moneyEquivalent = moneyEquivalent + house.cost
	end
	outputDebugString(string.format("[HOUSE] House equivalent of account %s: %i", accName, moneyEquivalent))
	return moneyEquivalent, data
end


-- ==========     Для составления таблицы интерьеров     ==========
function getAllInteriorPositions()
	return dbPoll(dbQuery(db, "SELECT ID, enterPointX, enterPointY, enterPointZ, int FROM house_data ORDER BY ID ASC"), -1)
end

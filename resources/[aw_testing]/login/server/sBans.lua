local db = dbConnect("sqlite", "database/bans.db")
dbExec(db, "CREATE TABLE IF NOT EXISTS bans    (ID INT, account TEXT, admin TEXT, reason TEXT, duration INT, banStart INT, banEnd INT, serial TEXT)")
dbExec(db, "CREATE TABLE IF NOT EXISTS oldbans (ID INT, account TEXT, admin TEXT, reason TEXT, duration INT, banStart INT, banEnd INT, serial TEXT)")


-- ==========     Админские функции     ==========
-- Открытие бан-панели
function openBanPanel(playerSource)
	triggerClientEvent(playerSource, "openBanPanel", resourceRoot)
end
addCommandHandler("banpanel", openBanPanel, true, false)

-- Получение списка банов
addEvent("getBansList", true)
addEventHandler("getBansList", resourceRoot, function(filter, activeBans, page)
	if not isAdmin(client) then
		outputDebugString(string.format("%s (acc %s serial %s) tried to access sendBansToPlayer",
			getPlayerName(client), getAccountName(getPlayerAccount(client)), getPlayerSerial(client)
		), 1)
		return
	end
	if (type(filter) ~= "table") then outputDebugString("not filter provided", 1) return end
	
	local tableName = activeBans and "bans" or "oldbans"
	local dbFilter = {}
	local dbArgs = {}
	if (filter.login) then
		table.insert(dbFilter, "(account LIKE '%??%' OR serial LIKE '%??%')")
		table.insert(dbArgs, filter.login)
		table.insert(dbArgs, filter.login)
	end
	if (filter.admin) then
		table.insert(dbFilter, "admin LIKE '%??%'")
		table.insert(dbArgs, filter.admin)
	end
	if (filter.reason) then
		table.insert(dbFilter, "reason LIKE '%??%'")
		table.insert(dbArgs, filter.reason)
	end
	if (filter.startLeft) then
		table.insert(dbFilter, "banStart >= ?")
		table.insert(dbArgs, filter.startLeft)
	end
	if (filter.startRight) then
		table.insert(dbFilter, "banStart <= ?")
		table.insert(dbArgs, filter.startRight)
	end
	if (filter.endLeft) then
		table.insert(dbFilter, "banEnd >= ?")
		table.insert(dbArgs, filter.endLeft)
	end
	if (filter.endRight) then
		table.insert(dbFilter, "banEnd <= ?")
		table.insert(dbArgs, filter.endRight)
	end
	local orderStatement
	if (filter.sortingCriteria) and (filter.sortingCriteria ~= "default") then
		orderStatement = string.format("ORDER BY `%s` %s", filter.sortingCriteria, (filter.sortingAsc and "ASC" or "DESC"))
	else
		orderStatement = "ORDER BY banStart DESC"
	end
	
	local whereStatement = dbPrepareString(db,
		string.format("WHERE %s", (#dbFilter > 0) and table.concat(dbFilter, " AND ") or "1"),
		unpack(dbArgs)
	)
	
	local count = dbPoll(dbQuery(db, "SELECT COUNT(ID) AS count FROM ?? "..whereStatement, tableName), -1)
	count = (count) and (count[1]) and (count[1].count) or 0
	
	local pageCapacity = 19
	local pagesCount = math.floor((count-1) / pageCapacity) + 1
	page = clamp(page, 1, pagesCount)
	local offset = (page-1) * pageCapacity
	
	local bans = dbPoll(dbQuery(db, string.format("SELECT * FROM %s %s %s LIMIT %i OFFSET %i", tableName, whereStatement, orderStatement, pageCapacity, offset)), -1)
	triggerClientEvent(client, "takeBansList", resourceRoot, bans, page, pagesCount, activeBans)
end)

addEvent("getBanInfo", true)
addEventHandler("getBanInfo", resourceRoot, function(id, useActiveBans)
	if not isAdmin(client) then
		outputDebugString(string.format("%s (acc %s serial %s) tried to access getBanInfo",
			getPlayerName(client), getAccountName(getPlayerAccount(client)), getPlayerSerial(client)
		), 1)
		return
	end

	local tableName = useActiveBans and "bans" or "oldbans"
	local data = dbPoll(dbQuery(db, "SELECT * FROM ?? WHERE ID = ?", tableName, id), -1)
	data = data[1] or {}
	
	local countLogin, countSerial = 0, 0
	if (data.account) and (data.account ~= "") then
		countLogin = dbPoll(dbQuery(db, "SELECT COUNT(ID) AS count FROM bans WHERE account = ?", data.account), -1)
		countLogin = (countLogin) and (countLogin[1]) and (countLogin[1].count) or 0
	end
	if (data.serial) and (data.serial ~= "") then
		countSerial = dbPoll(dbQuery(db, "SELECT COUNT(ID) AS count FROM bans WHERE serial = ?", data.serial), -1)
		countSerial = (countSerial) and (countSerial[1]) and (countSerial[1].count) or 0
	end
	triggerClientEvent(client, "takeBanInfo", resourceRoot, data, countLogin, countSerial, useActiveBans)
end)

addEvent("findSerial",true)
addEventHandler("findSerial", resourceRoot, function(accName)
	if not isAdmin(client) then
		outputDebugString(string.format("%s (acc %s serial %s) tried to access findSerial",
			getPlayerName(client), getAccountName(getPlayerAccount(client)), getPlayerSerial(client)
		), 1)
		return
	end
	local account = getAccount(accName)
	if (account) then
		triggerClientEvent(client, "takeSerial", resourceRoot, getAccountSerial(account))
	else
		outputChatBox("Аккаунт не найден!", client, 255,0,0)
	end	
end)


-- ==========     Функции бана и разбана     ==========
function banAccount(accName, serial, banTime, reason)
	if (accName == "") then accName = false end
	if (serial == "") then serial = false end
	if (accName) and (not getAccount(accName)) then
		outputChatIfElement("Внимание! Аккаунт "..accName.." не существует. Будет забанен только серийник.", client, 255,127,0, true)
		accName = false
	end
	
	local adminAccName = isElement(client) and getAccountName(getPlayerAccount(client)) or "Console"
	local newID = getFreeID("bans")
	local currentTime = getRealTime().timestamp
	local banEnd = currentTime + banTime
	if (banEnd < 0) or (banEnd > 2147483647) then
		outputChatIfElement("Переполнение времени бана. Бан должен окончиться раньше 2038 года.", client, 255,0,0, true)
		return
	end
	dbExec(db, "INSERT INTO bans VALUES(?, ?, ?, ?, ?, ?, ?, ?)", newID, (accName or ""), adminAccName, reason, banTime, currentTime, banEnd, (serial or ""))
	if (serial) then
		addBan(nil, (accName or nil), serial, client, reason, banTime)
	end
	outputDebugString(string.format("[LOGINPANEL][BAN] Acc '%s' and serial %s was banned by %s for %i. Reason: %s",
		(accName or ""), (serial or ""), adminAccName, banTime, tostring(reason)
	))
	if (accName) then
		outputChatIfElement("Аккаунт "..accName.." успешно забанен.", client, 255,255,255, true)
		local bannedPlayer = getAccountPlayer(getAccount(accName))
		if (bannedPlayer) then
			kickPlayer(bannedPlayer, client, "You have been banned from this server")
		end
	end
	if (serial) then
		outputChatIfElement("Серийный номер "..serial.." успешно забанен.", client, 255,255,255, true)
	end
	triggerClientEvent(getAllAdmins(), "banListOutdated", resourceRoot)
end
addEvent("banPlayer",true)
addEventHandler("banPlayer", resourceRoot, function(...)
	if isAdmin(client) then
		banAccount(...)
	else
		outputDebugString(string.format("%s (acc %s serial %s) tried to access banAccount",
			getPlayerName(client), getAccountName(getPlayerAccount(client)), getPlayerSerial(client)
		), 1)
	end
end)

addEvent("unbanAccount", true)
addEventHandler("unbanAccount", resourceRoot, function(id, loginToUnban, serialToUnban)
	if not isAdmin(client) then
		outputDebugString(string.format("%s (acc %s serial %s) tried to access unbanAccount",
			getPlayerName(client), getAccountName(getPlayerAccount(client)), getPlayerSerial(client)
		), 1)
		return
	end
	
	local ban = dbPoll(dbQuery(db, "SELECT * FROM bans WHERE ID = ?", id), -1)
	ban = (ban) and (ban[1])
	if (not ban) then
		outputChatBox("Ошибка! Бан не найден.", client, 255,0,0, true)
		return
	end
	if ((loginToUnban) and (loginToUnban ~= ban.account)) or ((serialToUnban) and (serialToUnban ~= ban.serial)) then
		outputChatBox("Ошибка при поиске бана. Найден бан с другими данными. Пожалуйста, обновите информацию о бане.", client, 255,0,0, true)
		return
	end
	
	local newID = getFreeID("oldbans")
	local curTime = getRealTime().timestamp
	dbExec(db, "INSERT INTO oldbans VALUES(?, ?, ?, ?, ?, ?, ?, ?)", newID, ban.account, ban.admin, ban.reason, ban.duration, ban.banStart, curTime, ban.serial)
	dbExec(db, "DELETE FROM bans WHERE ID = ?", id)
	if (ban.serial) and (ban.serial ~= "") then
		for _, serBan in ipairs(getBans()) do
			if (getBanSerial(serBan) == ban.serial) then
				removeBan(serBan, client)
			end
		end
	end
	
	outputDebugString(string.format(
		"[LOGINPANEL][UNBAN] Acc %s serial %s was unbanned by %s (%i days left)",
		tostring(ban.account), tostring(ban.serial),
		getAccountName(getPlayerAccount(client)),
		(ban.banStart+ban.duration-curTime)/86400
	))
	
	if (ban.account) and (ban.account ~= "") then
		outputChatBox("Аккаунт "..ban.account.." успешно разбанен.", client, 255,255,255, true)
		if (not loginToUnban) then
			banAccount(ban.account, false, ban.banEnd-curTime, ban.reason)
		end
	end
	if (ban.serial) and (ban.serial ~= "") then
		outputChatBox("Серийный номер "..ban.serial.." успешно разбанен.", client, 255,255,255, true)
		if (not serialToUnban) then
			banAccount(false, ban.serial, ban.banEnd-curTime, ban.reason)
		end
	end
	triggerClientEvent(getAllAdmins(), "banListOutdated", resourceRoot)
end)

-- Проверка на наличие бана и авторазбан при необходимости
function isBanned(accName, player, serial)
	local data = dbPoll(dbQuery(db, "SELECT * FROM bans WHERE account = ? OR serial = ? ORDER BY banEnd DESC LIMIT 1", accName, serial), -1)
	if (not data) or (#data == 0) then
		return false
	end
	data = data[1]
	local currentTime = getRealTime().timestamp
	if (data.banEnd < currentTime) then
		autoUnban(data.ID)
		return false
	end
	outputDebugString("[LOGINPANEL][ATTEMPT] "..getPlayerName(player).." tried to log into acc "..accName..", but it was banned")
	return data
end
function autoUnban(id)
	id = tonumber(id)
	local data = dbPoll(dbQuery(db, "SELECT * FROM bans WHERE ID = ?", id), -1)
	local ban, newID = data[1], getFreeID("oldbans")
	dbExec(db, "INSERT INTO oldbans VALUES(?, ?, ?, ?, ?, ?, ?, ?)", newID, ban.account, ban.admin, ban.reason, ban.duration, ban.banStart, ban.banEnd, ban.serial)
	dbExec(db, "DELETE FROM bans WHERE ID = ?", id)
	outputDebugString("[LOGINPANEL][UNBAN] "..ban.account.." was automatically unbanned")
end


-- ==========     Проверка и получение списка админов     ==========
function isAdmin(player)
	return hasObjectPermissionTo(player, "command.banpanel", false)
end

local adminsTable = {}
function getAllAdmins()
	local admins = {}
	for admin, _ in pairs(adminsTable) do
		table.insert(admins, admin)
	end
	return admins
end
addEventHandler("onResourceStart", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		if isAdmin(player) then
			adminsTable[player] = true
		end
	end
end)
addEventHandler("onPlayerLogin", root, function(_, theCurrentAccount)
	if isAdmin(source) then
		adminsTable[source] = true
	end
end)
addEventHandler("onPlayerQuit", root, function()
	if isAdmin(source) then
		adminsTable[source] = nil
	end
end)

-- Экспорт для никлогина
function getBannedLoginsFromTable(loginsPairs, serialsPairs)
	local time = getTickCount()
	local logins, serials = {}, {}
	for login, _ in pairs(loginsPairs) do
		login = login:gsub("'", "''")
		table.insert(logins, login)
	end
	for serial, _ in pairs(serialsPairs) do
		table.insert(serials, serial)
	end
	local data = dbPoll(dbQuery(db, "SELECT account, serial FROM bans WHERE account IN ('"..table.concat(logins, "','").."') OR serial IN ('"..table.concat(serials, "','").."')"), -1)
	local banned = {}
	for _, row in ipairs(data) do
		banned[row.account] = true
		banned[row.serial] = true
	end
	return banned
end


-- ==========     Мелкие функции     ==========
-- Ограничить число указанными пределами
function clamp(value, minValue, maxValue)
	return math.max(minValue, math.min(value, maxValue))
end

-- Отправить сообщение только если элемент корректный
function outputChatIfElement(...)
	local args = {...}
	if isElement(args[2]) then
		outputChatBox(...)
	end
end

-- Получить свободный ID в таблице
function getFreeID(baseName)
	local result = dbPoll(dbQuery(db, "SELECT ID FROM ? ORDER BY ID ASC", baseName), -1)
	local newID = false
	for i, row in pairs (result) do
		if row.ID ~= i then
			newID = i
			break
		end
	end
	return newID or #result+1
end


-- ==========     Служебные экспортные функции для амнистии     ==========
function getAllBans()
	return dbPoll(dbQuery(db, "SELECT * FROM bans"), -1)
end

function deleteBan(id)
	local data = dbPoll(dbQuery(db, "SELECT * FROM bans WHERE ID = ?", id), -1)
	dbExec(db, "DELETE FROM bans WHERE ID = ?", id)
	outputDebugString("[LOGINPANEL] Deleted ban ID "..tostring(id)..". Info: "..toJSON(data, true))
end

function deleteAccountBan(accName)
	local data = dbPoll(dbQuery(db, "SELECT * FROM bans WHERE account = ?", accName), -1)
	local idTable = {}
	for _, row in ipairs(data) do
		dbExec(db, "UPDATE bans SET account = '' WHERE ID = ?", row.ID)
		table.insert(idTable, row.ID)
	end
	outputDebugString(string.format("[LOGINPANEL] Deleted account %s from bans ID (%s). Info: %s", tostring(accName), table.concat(idTable, ","), toJSON(data, true)))
end

function deleteSerialBan(serial)
	for _, ban in ipairs(getBans()) do
		if (getBanSerial(ban) == serial) then
			outputDebugString(string.format("[LOGINPANEL] Unbanned serial %s, banned by %s, at timestamp %s, nick or login \"%s\", reason \"%s\", IP %s",
				serial,
				getBanAdmin(ban) or "false",
				getBanTime(ban) or "false",
				getBanNick(ban) or "false",
				getBanReason(ban) or "false",
				getBanIP(ban) or "false"
			))
			removeBan(ban)
		end
	end
	
	local data = dbPoll(dbQuery(db, "SELECT * FROM bans WHERE serial = ?", serial), -1)
	local idTable = {}
	for _, row in ipairs(data) do
		dbExec(db, "DELETE FROM bans WHERE ID = ?", row.ID)
		table.insert(idTable, row.ID)
	end
	outputDebugString(string.format("[LOGINPANEL] Deleted serial %s from bans ID (%s). Info: %s", tostring(serial), table.concat(idTable, ","), toJSON(data, true)))
end

function deleteEmptyBans()
	local data = dbPoll(dbQuery(db, "SELECT * FROM bans WHERE account = '' AND serial = ''", serial), -1)
	local idTable = {}
	for _, row in ipairs(data) do
		dbExec(db, "DELETE FROM bans WHERE ID = ?", row.ID)
		table.insert(idTable, row.ID)
	end
	outputDebugString(string.format("[LOGINPANEL] Deleted empty bans. ID list: (%s). Info: %s", table.concat(idTable, ","), toJSON(data, true)))
end


-- ==========     Вайтлист для тестового серва     ==========
function checkWhitelist()
	local serials = {
		["4C6B04830C8171AE77C93F3452F42EA1"] = true,	-- Daeman
		["CE94206582CD38DA947C9AA677317F03"] = true,	-- Loodrive
		["208F345946594D5047838C755631A493"] = true,	-- IMineev
		["A7232668874E0933D653482A01F429A3"] = true,	-- Sheva
		["AB503061E3C869BA0827EE284319E644"] = true,	-- artem.bahiya
		["AE7AFA9FEEED2FAA412AAE7B55B68494"] = true,	-- autoligenda
		["0287E7544A96B37B16D324C941D886A2"] = true,	-- Eric
		["DFCCDD2D32DD13472ABC88729C1B8E02"] = true,	-- ChubA
		["753A7079DACD67BC42E0E9881B345F44"] = true,	-- Marvinold
		["23965A460642A51099478C2AFF66AC04"] = true,	-- Миша
		["43C40AD766D9B1D4F13138589DEEBC81"] = true,	-- Никита скриптер
		["41C2238F0DDBC9410502FA30900B7E71"] = true,	-- IMineev
		["DE190D31D9C0A6DE7E9572ED19B77912"] = true,	-- Никита скриптер еще серийник
		["C06747054F52FBB543242BB3C30A35A3"] = true,	-- Андрей Mr.Datsun
		["34458BBE7E7475E7CE2823A0E4A655F4"] = true,	-- Evoman94
		["3DB47A7775800DF1E6B8C5AFB7329AF2"] = true,	-- Руденко
		["647F0F054D2F10C6997AACC949BCD842"] = true,	-- Wherry
		["3325E191738BCA20F185AE6DE5307942"] = true,	-- Бахия
		["13ED2C549F20BEF59C134BE646EF67E4"] = true,	-- Лагутин
		["231D9CB663CAC8AE99C3B77109E5F183"] = true,	-- Вадим Бессчастный
		["46D543408A7092C25087C9EF233D4C12"] = true,	-- Бахия
		["221998EB0B49481BB0BD4EE8B9EED0A1"] = true,	-- Чуба
		["17C832A5B83289846DB3263E5EF8B3F2"] = true,	-- Дрягунов
		["1837709FF16982C1B80EA4A3D5D07BE3"] = true,	-- Daeman (ноутбук)
		["96EE9DAEF911A42879D5593DA7E11C62"] = true,	-- Eclipse
		["A6941022EA03B64BAA991DEA2CCAE5E4"] = true,	-- Анискин
		["266C511DCA990547E9EE3B1664C5BC02"] = true,	-- Skoping
		["C91EE015E04EFB2362D4F00F84A39053"] = true,	-- Sheva
		["78E90FCFF321D0D84CC2B099DE6B6643"] = true,	-- Sergeydmitr
		["D60B912996DD6B91D609DF50351BA8A1"] = true,	-- Сквики
		["3B40C7EFFF148756EFB6FA3EDE13A8F4"] = true,	-- Sheva
		["24595A066C96C27A46A38C25BD916342"] = true,	-- Вадим Бессчастный
		["3A2E599C7AB420650E250A99FC20DB84"] = true,	-- Бахия
	}
	
	local playerSerial = getPlayerSerial(source)
	if (not serials[playerSerial]) then
		banAccount("", playerSerial, 86400, "Whitelist fail")
	else
		outputChatBox("Твой серийный номер найден в списке разрешенных.", source)
	end
end
if (getServerName() == "C_C_D_test_server") then
	addEventHandler("onPlayerJoin", root, checkWhitelist)
end
